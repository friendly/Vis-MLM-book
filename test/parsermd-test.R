# parse the source text of a .qmd document and get back an easy reference to each element.
# see: https://rundel.github.io/parsermd/articles/parsermd.html


remotes::install_github("rundel/parsermd")
library(parsermd)

parse_qmd("index.qmd") |>
  as_tibble() |>
  as_ast()

parse_qmd("03-multivariate_plots.qmd") |>
  as_tibble() |>
  as_ast()

qmd3 <- parse_qmd("03-multivariate_plots.qmd")

rmd_select(qmd3, has_heading())
