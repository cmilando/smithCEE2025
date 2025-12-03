#'@export
#' head.cityModel
#'
#' @param x a cityModel object
#' @param ... other arguments passed to plot
#'
#' @return
#' @export
#'
#' @examples
head.cityModel <- function(x, ...) {

  print(head(x$features))

}
