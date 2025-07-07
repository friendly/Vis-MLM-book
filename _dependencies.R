# Created using renv::dependencies() --------------------------------------
library(renv)
library(rmarkdown)
library(pak)
library(dplyr)
options(renv.config.pak.enabled = TRUE)

x <- renv::dependencies()

# Manual Checking of Particular Libraries ---------------------------------

# I'm going to ignore these,  as they may require a higher version of R and other things
# "anthropic"
# "elmer"

"spida2"
"spida"
"p3d"
"biplot2d3d"
"ggord"
"galahr"
install.packages("p3d", repos = "http://R-Forge.R-project.org")
pak::pak(c(
  'gmonette/spida2',
  'gmonette/spida',
  'Andros-Spica/biplot2d3d',
  'uschiLaa/galahr',
  'fawda123/ggord', #,
  'url::https://friendly.r-universe.dev/src/contrib/matlib_1.0.1.tar.gz'
  # 'url::https://cran.r-project.org/src/contrib/Archive/gWidgets/gWidgets_0.0-54.2.tar.gz'
))

# I will assume that tourrGui is no longer necessary
# install.packages("https://cran.r-project.org/src/contrib/Archive/RGtk2/RGtk2_2.20.36.3.tar.gz", type="source")
# pak::pak("ggobi/tourr-gui")
# "tourrGui"

# Automated Installation of Libraries -------------------------------------

Packages <- x |>
  dplyr::filter(
    !(Package %in%
      c(
        "anthropic",
        "elmer",
        "tourrGui",
        "spida2",
        "spida",
        "p3d",
        "biplot2d3d",
        "ggord",
        "galahr",
        'matlib'
      ))
  ) |>
  dplyr::select(Package)

Packages <- unique(Packages)$Package


pak::pak(c(Packages, "fs", "mclust", "flextable"))

# `fs` appears in `fix-pkg-cites.R`
# `mclust` appears in `09-hotelling.qmd`