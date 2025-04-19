# https://github.com/drjohnrussell/30DayChartChallenge/blob/main/2025/Challenge17.R
library(tidyverse)
library(ggalluvial)

penguinsdata <- penguins |> 
  group_by(species, island, year, sex) |> 
  summarise(Freq = n()) |> 
  ungroup() |> 
  drop_na()

penguinsdata |>
  ggplot(aes(axis1 = species, axis2 = sex, 
             axis3=year, axis4=island, y = Freq)) +
  geom_alluvium(aes(fill = species)) +
  geom_stratum() +
  geom_text(stat = "stratum", aes(label = after_stat(stratum))) +
  scale_x_discrete(limits = c("Species", "Sex", "Year","Island"), expand = c(.2, .05)) +
  theme_minimal() +
  labs(title="Palmer Penguins",
       subtitle = "The Newest Base R Dataset!",
       y="Number of penguins")
  
