#'@export
#' print.cityModel
#'
#' @param x a cityModel object
#' @param ... other arguments passed to print
#'
#' @return
#' @export
#'
#' @examples
print.cityModel <- function(x, ...) {
  cat("<cityModel>\n")
  cat("  city name:   ", x$city_name, "\n", sep = " ")
  cat("  shapefile:   ", nrow(x$shapefile), "grid cells; geometry:",
      paste(unique(sf::st_geometry_type(x$shapefile)), collapse = ", "), "\n", sep = " ")
  cat("  features:    ", nrow(x$features), "rows x", ncol(x$features), "cols\n")
  cat("  coefficients:", length(x$coefficients), "\n\t",
      paste(names(x$coefficients), collapse = ", "),"\n")
  invisible(x)
}
