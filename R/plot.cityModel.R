#'@export
#' plot.cityModel
#'
#' @param x a cityModel object
#' @param feature a column in the cityModel object to plot
#' @param ... other arguments passed to plot
#'
#' @return
#' @export
#'
#' @examples
plot.cityModel <- function(x, feature = NA,
                           hod = NA,
                           doy = NA,...) {


  # Validation
  if(is.na(feature)) {
    cat(" > No feature selected, plotting cell id ...\n")
    feature = 'id'
  }
  stopifnot(feature %in% colnames(x$features))
  stopifnot(inherits(x$shapefile, "sf"))

  stopifnot(all(c('hod', 'doy') %in% colnames(x$features)))
  if(is.na(hod)) hod = x$features$hod[1]
  if(is.na(doy)) doy = x$features$doy[1]

  # subset
  if(!is.na(hod) & !is.na(doy)) {

    rr <- which(x$features$hod == hod & x$features$doy == doy)
    x$features <- x$features[rr, ]
    # NB: check that you actually put things in that are there
  }

  # join
  if(feature == 'id') {
    dt <- x$features[, .(id)]
  } else {
    dt <- x$features[, .(id, value = get(feature))]
    data.table::setnames(dt, "value", feature)
  }

  # check if there is more than one observation
  # check for duplicates
  dup_cells <- dt[, .N, by = id][N > 1]

  if (nrow(dup_cells) > 0) {
    message("More than one observation per id found: ", nrow(dup_cells))
    print(dup_cells)
    stop()
  } else {
  }

  # Base-R left join with sf (keeps geometry intact)
  out <- merge(
    x$shapefile,           # sf object
    as.data.frame(dt),     # plain data.frame for safe merge
    by = "id",
    all.x = TRUE,          # left join
    sort = FALSE
  )

  stopifnot(nrow(out) == nrow(x$shapefile))

  if(feature == 'id') {
    ggplot(out) +
      geom_sf(data = x$shapefile, linewidth = 1) +
      geom_sf(fill = 'pink', color = 'white')
  } else {
    ggplot(out) +
      geom_sf(data = x$shapefile, linewidth = 1) +
      geom_sf(aes(fill = !!as.symbol(feature)),
              color = NA, ...)
  }

}
