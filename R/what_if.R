#' Title
#'
#' @param x
#' @param feature
#' @param raster
#'
#' @return
#' @export
#'
#' @examples
what_if <- function(x, feature, raster) {


  # grid_sp$svi <- exact_extract(svi, grid_sp, fun = 'mean')

  # --------------------------------------
  stopifnot(inherits(x, "cityModel"))

  stopifnot('timestamp' %in% colnames(x$features))
  warning('confirm timestamp format')
  x$features <- subset(x$features, timestamp == timestamp)


  xcoef <- as.matrix(x$coefficients$coef)
  xvcov <- as.matrix(x$coefficients$vcov)  # you can do mvnorm later to get eCI

  # --------------------------------------



  # --------------------------------------
  # Now, updated predicted values
  dim(as.matrix(x$features))
  dim(as.matrix(xcoef))
  warning('hard-coded matrix variable names')
  feat_names <- c("tree2" ,         "albedo" ,        "wtr_dist" ,
                  "RAP_wind_speed", "solar_goes" ,    "maxT_daymet" ,   "lat" ,
                  "soil_moisture",  "Hour")
  X_mat <- subset(x$features, select = feat_names)
  X_mat$`I(Hour^2)` <- X_mat$Hour^2
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
  oo$type = 'modified'
  head(oo)

  plot_df <- data.frame(type = 'baseline', air_temp = x$features$air_temp)
  med_line <- median(plot_df$air_temp, na.rm = T)
  plot_df <- rbind(plot_df, oo[, c('type', 'air_temp')])

  warning('hard-coded air_temperature axis')
  ggplot(plot_df) +
    geom_vline(xintercept = med_line - 20, linetype = '11', color = 'grey') +
    geom_boxplot(aes(x = air_temp - 20,
                     y = type,
                     fill = type), alpha = 0.75,
                 show.legend = F, width = 0.35) +
    xlab(expression(Air~Temperature)) +
    ylab(NULL) +
    theme_classic2()

}
