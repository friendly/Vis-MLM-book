library(dplyr)
library(tidyr)
library(ggplot2)


load(here::here("data", "peng.RData"))
source("R/penguin/penguin-colors.R")

peng_long <- peng |> 
  pivot_longer(bill_length:body_mass, 
               names_to = "characteristic", 
               values_to = "value") 

peng_long |>
  group_by(species) |> 
  ggplot(aes(value, species, fill = species)) +
  geom_boxplot() +
  facet_wrap(~characteristic, scales = 'free_x') +
  theme(legend.position = 'none') +
  theme_penguins()
