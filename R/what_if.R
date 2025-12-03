#' Title
#'
#' @param x
#' @param feature
#' @param raster
#' @param hod
#' @param doy
#'
#' @return
#' @export
#'
#' @examples
what_if <- function(x, feature, rast, hod = NA, doy = NA) {

  # --------------------------------------
  cat(" ... validation\n")
  stopifnot(inherits(x, "cityModel"))

  stopifnot(feature %in% colnames(x$features))
  stopifnot(inherits(x$shapefile, "sf"))

  # Note: for now, just hard_code for tree
  stopifnot(feature == 'tree_fraction')

  # --------------------------------------
  cat(" ... extract raster\n")
  # clean and extract raster
  if(any(is.na(as.matrix(rast)))) {
    warning('some NA raster cells are NA')
  }

  # why is this failing
  # because the tif dimensions have to be correct, need to give
  # failures for that
  rast_map <- exact_extract(rast, x$shapefile, fun = 'mean')

  warning("check basis")

  rast_df <- data.table(id = x$shapefile$id, rast = rast_map)

  # subset
  if(!is.na(hod) & !is.na(doy)) {

    rr <- which(x$features$hod == hod & x$features$doy == doy)
    x$features <- x$features[rr, ]
    x$features <- merge(x$features, xdf, by = c('id'))
    # NB: check that you actually put things in that are there
    stopifnot(nrow(x$features) == length(unique(x$shapefile$id)))

  } else {

    # you can assume that this is for every feature
    xdf <- unique(x$features[, c('id', 'hod', 'doy')])
    xdf <- merge(xdf, rast_df)
    orig_n <- nrow(x$features)
    x$features <- merge(x$features, xdf, by = c('id', 'hod', 'doy'))
    stopifnot(nrow(x$features) == nrow(xdf))
    stopifnot(nrow(x$features) == orig_n)

  }

  # --------------------------------------
  cat(" ... apply model\n")
  xcoef <- as.matrix(x$coefficients)
  xvcov <- as.matrix(x$vcov)  # you can do mvnorm later to get eCI

  # --------------------------------------



  # --------------------------------------
  # Now, updated predicted values
  warning('hard-coded matrix variable names')
  # tree_fraction + albedo + wind_m_s + wtr_dist_m +
  #   solar_w_m2 + max_temp_daymet_C + hod + I(hod^2)

  # *********
  # BASELINE
  feat_names <- c("tree_fraction" ,         "albedo" ,        "wind_m_s" ,
                  "wtr_dist_m", "solar_w_m2" ,    "max_temp_daymet_C" ,
                  "hod")
  X_mat <- subset(x$features, select = feat_names)
  X_mat$`I(hod^2)` <- X_mat$hod^2
  X_mat <- cbind(1, X_mat)
  X_mat <- as.matrix(X_mat)
  head(X_mat)
  dim(X_mat)
  dim(xcoef)

  ## apply new coefficients
  y_hat <- X_mat %*% xcoef

  # Pointwise standard errors
  se_fit <- sqrt(rowSums((X_mat %*% xvcov) * X_mat))

  # Combine
  oo <- as.data.frame(cbind(y_hat, se_fit))
  names(oo) <- c('air_temp', 'se_fit')
  oo$type = 'baseline'
  head(oo)

  # *********
  # UPDATED
  feat_names <- c("rast" ,         "albedo" ,        "wind_m_s" ,
                  "wtr_dist_m", "solar_w_m2" ,    "max_temp_daymet_C" ,
                  "hod")
  X_mat <- subset(x$features, select = feat_names)
  X_mat$`I(hod^2)` <- X_mat$hod^2
  X_mat <- cbind(1, X_mat)
  X_mat <- as.matrix(X_mat)
  head(X_mat)
  dim(X_mat)
  dim(xcoef)

  ## apply new coefficients
  y_hat <- X_mat %*% xcoef

  # Pointwise standard errors
  se_fit <- sqrt(rowSums((X_mat %*% xvcov) * X_mat))

  # Combine
  tt <- as.data.frame(cbind(y_hat, se_fit))
  names(tt) <- c('air_temp', 'se_fit')
  tt$type = 'modified'
  head(tt)

  dim(tt)

  # and now cbind
  x$features$air_temp_baseline <- oo$air_temp
  x$features$air_temp_modified <- tt$air_temp

  #
  x$feature_change <- feature
  return(x)

}


# library(tidyverse)
# library(sf)
# library(stars)
#
#
# dt <- unique(x$features[, .(id, tree_new)])
#
# out <- merge(
#   x$shapefile,           # sf object
#   as.data.frame(dt),     # plain data.frame for safe merge
#   by = "id",
#   all.x = TRUE,          # left join
#   sort = FALSE
# )
#
# # rasterize based on geometry and a column named "value". Change the name of this column if necessary
# r.enn2mean<-st_rasterize(out %>% dplyr::select(tree_new, geometry))
# plot(r.enn2mean)
#
# # export as tiff
# write_stars(r.enn2mean, "inst/extdata/treeCanopy_sample.tif")
