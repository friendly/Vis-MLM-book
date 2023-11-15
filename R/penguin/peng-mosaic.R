#' ---
#' title: Penguins data, mosaic plots
#' ---

load(here::here("data", "peng.RData"))
source("R/penguin-colors.R")

library(vcdExtra)

# change levels of sex
peng <- peng |>
  mutate(sex = factor(sex, labels = c("Female", "Male")))

peng.table <- xtabs(~ species + sex + island, data = peng)

ftable(peng.table)

pairs(peng.table, shade = TRUE)
