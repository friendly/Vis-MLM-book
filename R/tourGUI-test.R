#install.packages("RGtk2") # orphaned
# failed to install
install.packages("https://cran.r-project.org/src/contrib/Archive/RGtk2/RGtk2_2.20.36.3.tar.gz")
# failed to install
remotes::install_github("cran/RGtk2")

#install.packages("gWidgets")
install.packages("https://cran.r-project.org/src/contrib/Archive/gWidgets/gWidgets_0.0-54.2.tar.gz", type="source")

remotes::install_github("ggobi/tourr-gui")

library(tourrGui)


