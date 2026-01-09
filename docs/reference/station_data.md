# Hourly weather station air temperature observations (JJA 2021–2022)

See Methods section of [Smith
(2025)](https://doi.org/10.1038/s43247-025-02462-3) for more
information, paraphrased below:

## Usage

``` r
station_data
```

## Format

A `data.table` with the following variables:

- station_name:

  Station identifier and name as reported by the data source.

- lat:

  Latitude of the weather station (decimal degrees).

- lon:

  Longitude of the weather station (decimal degrees).

- temp_obs_C:

  Observed hourly air temperature (°C). May be `NA` if unavailable.

- doy:

  Day of year.

- hod:

  Hour of day (local time).

- year:

  Calendar year of observation (2021 or 2022).

- wind_m_s:

  Hourly wind speed from RAP reanalysis (\\m\\s^{-1}\\).

- solar_w_m2:

  Hourly surface solar irradiance from GOES (\\W m{^{-2}}\\).

- max_temp_daymet_C:

  Daymet-estimated maximum daily temperature (°C).

- wtr_dist_m:

  Shortest Euclidean distance to coastline (meters).

- albedo:

  Summertime mean surface albedo within a 100 m buffer.

- tree_fraction:

  Fractional tree canopy cover within a 100 m buffer.

- source:

  Data source identifier (`"madis"` or `"wu"`).

## Source

Meteorological Assimilation Data Ingest System (MADIS); Weather
Underground network; Daymet gridded temperature dataset; ancillary
remote sensing and reanalysis products.RAP reanalysis; GOES satellite
products; Daymet gridded temperature dataset.

## Details

A data.table containing hourly near-surface air temperature observations
and associated environmental covariates from weather stations used for
training and validation of a summertime air temperature regression
model. The dataset combines observations from the Meteorological
Assimilation Data Ingest System (MADIS) and the Weather Underground
network for June, July, and August (JJA) of 2021 and 2022.

MADIS observations were used to train the regression model. Hourly data
were first filtered using MADIS quality control (QC) flags to retain
verified observations. Stations were then filtered by observation
completeness, requiring a minimum of 80 and 2022. Stations with greater
than 5 buffer were excluded. The remaining 139 MADIS stations with valid
hourly air temperature time series were buffered by 100 m to quantify
proximate land cover composition and surface albedo.

Observational air temperature data from the Weather Underground network
were used to validate the regression model. For each of the five cities
in the spatial domain, hourly observations were acquired for all Weather
Underground stations within a 5 km buffer of the city boundary. The same
quality control procedures were applied, resulting in a total of 153
Weather Underground stations.

The 100 m buffer size used for land surface characterization was
selected based on the estimated spatial scale of urban tree canopy
cooling effects (approximately 90 m), with an additional 10 m included
to account for uncertainty in reported station coordinates.

Tree canopy cover represents the 100 m buffered fractional tree canopy
cover at each weather station, derived from the Google Panoptic land
cover dataset. Surface albedo is calculated within a 100 m buffer using
Sentinel-2 imagery and the Bonafoni and Sekertekin narrow-to-broadband
algorithm, based on cloud-free summertime mean composites from
2021–2022. Wind speed is obtained from the 13 km hourly Rapid Refresh
(RAP) reanalysis, while surface solar irradiance is sourced from the
0.05° hourly Geostationary Operational Environmental Satellite (GOES)
product. Distance to water represents the shortest Euclidean distance
between each station and the coastline. Maximum daily temperature is
estimated using the 1 km Daymet gridded dataset.
