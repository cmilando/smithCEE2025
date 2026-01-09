#' Weather, land cover, and environmental covariates at grid cells
#'
#' See Methods section of \href{https://doi.org/10.1038/s43247-025-02462-3}{Smith (2025)}
#' for more information, paraphrased below:
#'
#' A data.table containing hourly summertime environmental and land-surface
#' covariates for grid cells in Boston. Variables include
#' vegetation cover, surface albedo, meteorological conditions, and proximity
#' to water, derived from multiple remote sensing and reanalysis products.
#'
#' Tree canopy cover represents the 100 m buffered fractional tree canopy
#' cover at each weather station, derived from the Google Panoptic land cover
#' dataset. Surface albedo is calculated within a 100 m buffer using Sentinel-2
#' imagery and the Bonafoni and Sekertekin narrow-to-broadband algorithm, based on
#' cloud-free summertime mean composites from 2021–2022. Wind speed is obtained
#' from the 13 km hourly Rapid Refresh (RAP) reanalysis, while surface solar
#' irradiance is sourced from the 0.05° hourly Geostationary Operational
#' Environmental Satellite (GOES) product. Distance to water represents the
#' shortest Euclidean distance between each station and the coastline. Maximum
#' daily temperature is estimated using the 1 km Daymet gridded dataset.
#'
#' Hour of day corresponds to local time (14:00, 15:00, or 16:00). The dataset is
#' used as input to temperature modeling analyses; correlations between model
#' inputs and air temperature are provided separately. The model does not account
#' for other urban features such as urban geometry or anthropogenic heat sources.
#'
#' @format
#' A \code{data.table} with the following variables:
#' \describe{
#'   \item{id}{Numeric identifier for the weather station.}
#'   \item{hod}{Hour of day (local time; 14, 15, or 16).}
#'   \item{doy}{Day of year.}
#'   \item{index}{Character identifier combining station ID and day of year.}
#'   \item{max_temp_daymet_C}{Daymet-estimated maximum daily temperature (°C).}
#'   \item{minT_daymet}{Daymet-estimated minimum daily temperature (°C).}
#'   \item{wind_m_s}{Hourly wind speed from RAP reanalysis (\eqn{m\,s^{-1}}).}
#'   \item{solar_w_m2}{Hourly surface solar irradiance from GOES (\eqn{W m{^{-2}}}).}
#'   \item{prev_day_max}{Previous day maximum temperature (°C).}
#'   \item{next_day_min}{Next day minimum temperature (°C).}
#'   \item{pop}{Population metric associated with the station location.}
#'   \item{albedo}{Summertime mean surface albedo (Sentinel-2).}
#'   \item{albedo_new}{Updated or harmonized albedo estimate.}
#'   \item{tree_fraction}{Fractional tree canopy cover within 100 m buffer.}
#'   \item{tree_new}{Updated or alternative tree canopy metric.}
#'   \item{wtr_dist_m}{Shortest Euclidean distance to coastline (meters).}
#' }
#'
#' @source
#' Google Panoptic Land Cover dataset; Sentinel-2; RAP reanalysis; GOES satellite
#' products; Daymet gridded temperature dataset.
#'
#' @keywords datasets
"boston_data"

#' Valid city identifiers for the spatial analysis domain
#'
#' A character vector listing the valid city identifiers used in the spatial
#' analysis and modeling workflow. These identifiers are used to subset data,
#' define spatial domains, and ensure consistency across model inputs and
#' validation datasets.
#'
#' @format
#' A character vector of city names.
#'
#' @details
#' City names are provided in lowercase and correspond to predefined spatial
#' domains used in the analysis.
#'
#' @examples
#' valid_city_names
#'
#' @keywords datasets
"valid_city_names"


#' Hourly weather station air temperature observations (JJA 2021–2022)
#'
#' See Methods section of \href{https://doi.org/10.1038/s43247-025-02462-3}{Smith (2025)}
#' for more information, paraphrased below:
#'
#' A data.table containing hourly near-surface air temperature observations and
#' associated environmental covariates from weather stations used for training
#' and validation of a summertime air temperature regression model. The dataset
#' combines observations from the Meteorological Assimilation Data Ingest System
#' (MADIS) and the Weather Underground network for June, July, and August (JJA)
#' of 2021 and 2022.
#'
#' MADIS observations were used to train the regression model. Hourly data were
#' first filtered using MADIS quality control (QC) flags to retain verified
#' observations. Stations were then filtered by observation completeness,
#' requiring a minimum of 80% of possible JJA hourly observations in both 2021
#' and 2022. Stations with greater than 5% surface water cover within a 100 m
#' buffer were excluded. The remaining 139 MADIS stations with valid hourly air
#' temperature time series were buffered by 100 m to quantify proximate land
#' cover composition and surface albedo.
#'
#' Observational air temperature data from the Weather Underground network were
#' used to validate the regression model. For each of the five cities in the
#' spatial domain, hourly observations were acquired for all Weather Underground
#' stations within a 5 km buffer of the city boundary. The same quality control
#' procedures were applied, resulting in a total of 153 Weather Underground
#' stations.
#'
#' The 100 m buffer size used for land surface characterization was selected
#' based on the estimated spatial scale of urban tree canopy cooling effects
#' (approximately 90 m), with an additional 10 m included to account for
#' uncertainty in reported station coordinates.
#'
#' Tree canopy cover represents the 100 m buffered fractional tree canopy
#' cover at each weather station, derived from the Google Panoptic land cover
#' dataset. Surface albedo is calculated within a 100 m buffer using Sentinel-2
#' imagery and the Bonafoni and Sekertekin narrow-to-broadband algorithm, based on
#' cloud-free summertime mean composites from 2021–2022. Wind speed is obtained
#' from the 13 km hourly Rapid Refresh (RAP) reanalysis, while surface solar
#' irradiance is sourced from the 0.05° hourly Geostationary Operational
#' Environmental Satellite (GOES) product. Distance to water represents the
#' shortest Euclidean distance between each station and the coastline. Maximum
#' daily temperature is estimated using the 1 km Daymet gridded dataset.
#'
#' @format
#' A \code{data.table} with the following variables:
#' \describe{
#'   \item{station_name}{Station identifier and name as reported by the data source.}
#'   \item{lat}{Latitude of the weather station (decimal degrees).}
#'   \item{lon}{Longitude of the weather station (decimal degrees).}
#'   \item{temp_obs_C}{Observed hourly air temperature (°C). May be \code{NA} if unavailable.}
#'   \item{doy}{Day of year.}
#'   \item{hod}{Hour of day (local time).}
#'   \item{year}{Calendar year of observation (2021 or 2022).}
#'   \item{wind_m_s}{Hourly wind speed from RAP reanalysis (\eqn{m\,s^{-1}}).}
#'   \item{solar_w_m2}{Hourly surface solar irradiance from GOES (\eqn{W m{^{-2}}}).}
#'   \item{max_temp_daymet_C}{Daymet-estimated maximum daily temperature (°C).}
#'   \item{wtr_dist_m}{Shortest Euclidean distance to coastline (meters).}
#'   \item{albedo}{Summertime mean surface albedo within a 100 m buffer.}
#'   \item{tree_fraction}{Fractional tree canopy cover within a 100 m buffer.}
#'   \item{source}{Data source identifier (\code{"madis"} or \code{"wu"}).}
#' }
#'
#' @source
#' Meteorological Assimilation Data Ingest System (MADIS); Weather Underground
#' network; Daymet gridded temperature dataset; ancillary remote sensing and
#' reanalysis products.RAP reanalysis; GOES satellite products;
#' Daymet gridded temperature dataset.
#'
#' @keywords datasets
"station_data"


#' Shapefile of Boston grid cells
#'
#' Polygons and ids that correspond to `boston_data` ids
#'
#' @format tbd.
#' \describe{
#' \item{id}{Numeric, id for each gridcell}
#' \item{geometry}{Geometry, spatial geometry for each polygon grid cell}
#' }
#'
#'
"boston_shp"
