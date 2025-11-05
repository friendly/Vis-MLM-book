#' ---
#' title: Penguin data discriminant boundaries using candisc
#' ---

library(MASS)
library(ggplot2)
library(patchwork)
library(candisc)
#library(marginaleffects)   # for datagrid

data(peng, package="heplots")
source(here::here("R/penguin/penguin-colors.R"))

peng.lda <- lda(species ~ bill_length + bill_depth + flipper_length + body_mass, 
                data = peng)

means <- peng |>
  group_by(species) |>
  summarise(across(c(bill_length, bill_depth), \(x) mean(x, na.rm = TRUE) ))

plot_discrim(peng.lda, bill_depth ~ bill_length,
             data = peng) +
    theme_penguins() 

