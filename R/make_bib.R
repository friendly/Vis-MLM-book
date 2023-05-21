pkgs <- .to.cite <- c(
  "rgl",
  "animation",
  "nnet", 
  "car", 
  "broom", 
  "ggplot2", 
  "equatiomatic", 
  "geomtextpath")

knitr::write_bib(pkgs, file = here::here("bib", "packages.bib"))

