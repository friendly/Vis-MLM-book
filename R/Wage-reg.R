# example from https://x.com/yuzaR___/status/1816496618134204694

library(tidyverse)
library(performance)
library(ggeffects)

theme_set(theme_test())

data(Wages, package = "ISRL2")

Wages.mod <- lm(wage ~ age + year + jobclass + education, data = Wages)

# check model assumptions
check_model(Wages.mod)

# visualize predictions
ggeffects(Wages.mod) |>
  plot() |>
  sjplot::plot_grid()

# display contrasts in a table
gtsummary::tbl_regressions(Wages.mod,
                           add_pairwise_contrasts = TRUE)

equatiomatic::extract_eq(Wages.mod)


