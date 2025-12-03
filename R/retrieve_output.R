#' Retrieve output
#'
#' @param city_name the name of a city, converts to lowercase
#' @param clip optional, a shapefile to clip the output to
#'
#' @return
#' @export
#'
#' @examples
retrieve_output <- function(city_name = 'boston') {

  # -------------------------------
  # Validation block
  # city_name = tolower(city_name)
  # data("valid_city_names")
  stopifnot(city_name %in% valid_city_names)

  # give back an S3 object
  cat(paste0(" city: ", city_name, "\n"))

  # -------------------------------
  # NOTE TO CHAD: right now this assumes that
  # all the data are saved in the hexgrid file, which
  # might not be a terrible thing just good to know

  # in the future this will be something we do like this
  # *****
  # shp <- geojsonsf::geojson_sf(paste0("geoJSON/",city_name,".geojson"))
  # *****
  cat(" ... load shapefile\n")
  # data("boston_shp")
  shp <- boston_shp

  # -------------------------------
  # ok now if its clipped, get the subset
  # probably need other validation steps here
  # if(!is.na(clip)) {
  #   stopifnot(inherits(clip, "sf"))
  #   stopifnot(st_crs(shp) == st_crs(boston_clip))
  #   shp <- shp |>
  #     st_make_valid() |>
  #     st_intersection(clip)
  #   if(nrow(shp) == 0) {
  #     stop("Clip has no intersection with city boundaries")
  #   }
  # }

  # -------------------------------
  # Features
  # again, do this differently in the future
  # *****
  # shp_features <- readRDS(paste0("hex/", city_name,"_hex.RDS"))
  # *****
  cat(" ... load data\n")
  # data("boston_data")
  shp_features <- boston_data
  setDT(shp_features)
  stopifnot('id' %in% colnames(shp_features))


  # -------------------------------
  # Coefficients
  # again, this will be a dataset input
  # but now we can calculate them directly
  # city_coef <- readRDS(paste0("coefficients/", city_name, "_coef.RDS"))
  cat(" ... load coefficients\n")
  # data("station_data")
  fit <- lm(temp_obs_C ~ tree_fraction + albedo + wind_m_s + wtr_dist_m +
              solar_w_m2 + max_temp_daymet_C + hod + I(hod^2),
            data = station_data)

  city_coef <- coef(fit)
  city_vcov <- vcov(fit)

  # and make the feature basis
  cols <- c('tree_fraction', 'albedo', 'wind_m_s', 'wtr_dist_m',
              'solar_w_m2', 'max_temp_daymet_C', 'hod')
  feature_basis <- list()
  for(cc in cols) {
    feature_basis[[cc]] <- range(station_data[, cc])
  }


  # -------------------------------
  # Prepare the city-model object
  x <- list(
    city_name          = city_name,
    shapefile          = shp,            # sf object
    features           = shp_features,   # data.frame
    feature_basis      = feature_basis,  # named list
    coefficients       = city_coef,      # named numeric
    vcov               = city_vcov
  )
  class(x) <- "cityModel"
  x

}


