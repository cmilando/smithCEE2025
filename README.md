A package for the functions in [Smith 2025](https://doi.org/10.1038/s43247-025-02462-3)


Smith, Ian A., Dan Li, David K. Fork, Gregory A. Wellenius, and Lucy R. Hutyra. "Integrated tree canopy expansion and cool roofs can optimize air temperature and heat exposure reductions in Boston." Communications Earth & Environment 6, no. 1 (2025): 507.

# Installing the package

```
remotes::install_github("cmilando/smithCEE2025", 
                        build_vignettes = TRUE, 
                        force = TRUE)
```

# Running the package

```{r v1}
library(smithCEE2025)
vignette(package = "smithCEE2025")
vignette("boston_tree_cover")
```

In case the vignette above doesn't build for some reason ...

In this vignette, we demonstrate how to use the package to investigate the impact of changes in tree-cover on air temperature.

## Load the data
```{r setup}
library(smithCEE2025)
```

Load the data
```{r load_data}
bos <- retrieve_output()
```

Look at the object
```{r examine}
bos
```

And look specifically at each part: the features
```{r examine2}
head(bos)
```

the shapefile
```{r}
head(bos$shapefile)
```

and the coefficients.
```{r}
print(bos$coefficients)
```

You can plot several ways: just by cell id
```{r plot_base, fig.height=5, fig.width=5}
plot(bos)
```

Or by a specific feature
```{r plot_base2, fig.height=5, fig.width=5}
plot(bos, feature = 'tree_fraction')

```

And you can zoom in on a specific day
```{r plot_base3, fig.height=5, fig.width=5}
plot(bos, feature = 'max_temp_daymet_C', hod = 14, doy = 153)
```

## Load a raster file and make changes

First convert your .tif to a raster object. Note in this example we've already
clipped it to the Boston extent, but the code doesn't assume that it is clipped.
```{r read_tif}
image_path <- system.file("extdata", 
                          "treeCanopy_sample.tif", 
                          package = "smithCEE2025")
tree_raster <- rast(image_path)
```

Tree canopy in particular should be represented as a proportion and not percent for consistency with data used in model fit
```{r plot_raster, fig.height=5, fig.width=5}
plot(tree_raster)

tree_raster <- tree_raster/100
plot(tree_raster)
```

Now, pass this in and see the difference it makes for air temperature.
this will add `air_temp_baseline` and `air_temp_modified` as a result of the changes that were made.
```{r feature_change}
new_bos <- what_if(bos, 'tree_fraction', tree_raster)

```

And now look at the change it made
```{r plot_output1, fig.height=5, fig.width=5}
plot(new_bos, "air_temp_baseline", hod = 14, doy = 153)
plot(new_bos, "air_temp_modified", hod = 14, doy = 153)
```

Slightly cooler - nice! But a little hard to see ...

If you want to do your own calculations and plot, here's how
```{r calc, fig.height=5, fig.width=5}

  # say diff is new - old
  new_bos$features$air_temp_diff <- 
    new_bos$features$air_temp_modified - 
    new_bos$features$air_temp_baseline

  # and percent diff
  new_bos$features$air_temp_pdiff <- 
    new_bos$features$air_temp_diff / 
    new_bos$features$air_temp_baseline * 100
  
  # and then plot
  plot(new_bos, "air_temp_pdiff", hod = 14, doy = 153)
```

Now its easier to see where the differences are for a specific day
