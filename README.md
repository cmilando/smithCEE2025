A package for the functions in [Smith 2025](https://doi.org/10.1038/s43247-025-02462-3)


Smith, Ian A., Dan Li, David K. Fork, Gregory A. Wellenius, and Lucy R. Hutyra. "Integrated tree canopy expansion and cool roofs can optimize air temperature and heat exposure reductions in Boston." Communications Earth & Environment 6, no. 1 (2025): 507.

# Installing the package

```
remotes::install_github("cmilando/smithCEE2025", 
                        build_vignettes = TRUE, 
                        force = TRUE)
```

You may need to install Xquartz to get the vingettes to compile

# Running the package

See the demo vignette `boston_tree_cover`

```{r v1}
library(smithCEE2025)
vignette(package = "smithCEE2025")
vignette("boston_tree_cover")
```

