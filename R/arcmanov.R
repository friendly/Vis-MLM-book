library(heplots)
library(dplyr)

means <- tibble::tribble(
  ~group, ~y1, ~y2,
  1,  8,  10,
  2, 10,   5,
  3, 12,  14,
  4, 17,  20,
  5, 18,  11,
  6, 20,  16,
  7, 25,  20,
  8, 27,  26,
)
ng <- nrow(means)

means$r <- round(runif(ng, min =0.4, max =0.9), 0.1)

means <- means |>
  mutate(r = round(runif(1, min =0.4, max =0.9), 0.1),
         sd1 = runif(1.5, 2.5))


