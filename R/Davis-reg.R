#' ---
#' title: Davis data
#' ---
#'


library(ggplot2) 
library(tidyverse)
data(Davis, package="carData")


Davis |>
  drop_na() |> 
  ggplot(Davis, aes(x = weight, y = repwt, color = sex, shape=sex)) +
    geom_point(size = 2) +
    geom_smooth(method = "lm", formula = y~x, se = FALSE) +
    labs(x = "Measured weight (kg)", y = "Reported weight (kg)") +
    theme_bw(base_size = 14) +
    theme(legend.position = c(.8, .8))

Davis |>
  drop_na() |> 
  ggplot(Davis, aes(y = weight, x = repwt, color = sex, shape=sex)) +
    geom_point(size = 2) +
    labs(y = "Measured weight (kg)", x = "Reported weight (kg)") +
    geom_smooth(method = "lm", formula = y~x, se = FALSE) +
    theme_bw(base_size = 14) +
    theme(legend.position = c(.8, .8))


