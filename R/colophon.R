#' ---
#' title: make colophon
#' ---

source("R/common.R")
library(dplyr)

packages <- read_pkgs()
pkg_info <- sessioninfo:::package_info(packages, dependencies = FALSE) 
# clean up unwanted
pkg_info$source <- sub(" \\(R.*\\)", "", pkg_info$source)
#pkg_info <- pkg_info[,-2]

pkg_info

# for a LaTeX version
library(xtable)

print(xtable(pkg_info), include.rownames=FALSE, floating=FALSE)

pkg_info |>
  select(package, ondiskversion, date, source)

