# from: https://github.com/jmbuhr/dataintro
library(tidyverse)
library(palmerpenguins)

penguins %>%
  filter(complete.cases(.)) %>% 
  ggplot(aes(flipper_length_mm, bill_length_mm,
                     color = species,
                     shape = sex)) +
  geom_point(size = 2.5) +
  geom_smooth(aes(group = species), method = "lm", se = FALSE,
              show.legend = FALSE) +
  labs(x = "Flipper length [mm]",
       y = "Bill length [mm]",
       title = "Penguins!",
       subtitle = "The 3 penguin species can be differentiated by their flipper- and bill-lengths.",
       caption = "Datasource:\nHorst AM, Hill AP, Gorman KB (2020). palmerpenguins:\nPalmer Archipelago (Antarctica) penguin data.\nR package version 0.1.0. https://allisonhorst.github.io/palmerpenguins/",
       color = "Species",
       shape = "Sex") +
  theme_minimal() +
  scale_color_brewer(type = "qual") +
  theme(plot.caption = element_text(hjust = 0))
