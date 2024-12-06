library(dplyr)
library(tidyr)
library(ggplot2)


#load(here::here("data", "peng.RData"))
data(peng, package="heplots")
source("R/penguin/penguin-colors.R")

peng_long <- peng |> 
  pivot_longer(bill_length:body_mass, 
               names_to = "variable", 
               values_to = "value") 

peng_long |>
  group_by(species) |> 
  ggplot(aes(value, species, fill = species)) +
  geom_boxplot() +
  facet_wrap(~ variable, scales = 'free_x') +
  theme_penguins() +
  theme_bw(base_size = 14) +
  theme(legend.position = 'none') 
