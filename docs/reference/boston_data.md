# Weather, land cover, and environmental covariates at grid cells

See Methods section of [Smith
(2025)](https://doi.org/10.1038/s43247-025-02462-3) for more
information, paraphrased below:

## Usage

``` r
boston_data
```

## Format

A `data.table` with the following variables:

- id:

  Numeric identifier for the weather station.

- hod:

  Hour of day (local time; 14, 15, or 16).

- doy:

  Day of year.

- index:

  Character identifier combining station ID and day of year.

- max_temp_daymet_C:

  Daymet-estimated maximum daily temperature (°C).

- minT_daymet:

  Daymet-estimated minimum daily temperature (°C).

- wind_m_s:

  Hourly wind speed from RAP reanalysis (\\m\\s^{-1}\\).

- solar_w_m2:

  Hourly surface solar irradiance from GOES (\\W m{^{-2}}\\).

- prev_day_max:

  Previous day maximum temperature (°C).

- next_day_min:

  Next day minimum temperature (°C).

- pop:

  Population metric associated with the station location.

- albedo:

  Summertime mean surface albedo (Sentinel-2).

- albedo_new:

  Updated or harmonized albedo estimate.

- tree_fraction:

  Fractional tree canopy cover within 100 m buffer.

- tree_new:

  Updated or alternative tree canopy metric.

- wtr_dist_m:

  Shortest Euclidean distance to coastline (meters).

## Source

Google Panoptic Land Cover dataset; Sentinel-2; RAP reanalysis; GOES
satellite products; Daymet gridded temperature dataset.

## Details

A data.table containing hourly summertime environmental and land-surface
covariates for grid cells in Boston. Variables include vegetation cover,
surface albedo, meteorological conditions, and proximity to water,
derived from multiple remote sensing and reanalysis products.

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

Hour of day corresponds to local time (14:00, 15:00, or 16:00). The
dataset is used as input to temperature modeling analyses; correlations
between model inputs and air temperature are provided separately. The
model does not account for other urban features such as urban geometry
or anthropogenic heat sources.
