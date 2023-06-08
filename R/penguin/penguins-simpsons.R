#' ---
#' title: Penguin data -- Simpsons paradox
#' ---

library(ggplot2)
library(dplyr)
library(tidyr)

data(penguins, package = "palmerpenguins")

penguins <- penguins |>
  drop_na()


plt1 <- ggplot(data = penguins,
                aes(x = bill_length_mm,
                    y = bill_depth_mm)) +
  geom_point() +
  geom_smooth(method = "lm", formula = y ~ x, 
              se = TRUE, color = "gray50") +
  stat_ellipse(level = 0.68, linewidth = 1.1) +
  scale_color_manual(values = c("darkorange","purple","cyan4")) +
  labs(title = "Penguin bill dimensions: Ignoring species",
#       subtitle = "Ignoring species",
       x = "Bill length (mm)",
       y = "Bill depth (mm)") +
  theme(plot.title.position = "plot",
        plot.caption = element_text(hjust = 0, face= "italic"),
        plot.caption.position = "plot") 

plt1

plt2 <- ggplot(data = penguins,
                       aes(x = bill_length_mm,
                           y = bill_depth_mm,
                           group = species)) +
  geom_point(aes(color = species, 
                 shape = species),
             size = 3,
             alpha = 0.8) +
  geom_smooth(method = "lm", formula = y ~ x, 
              se = TRUE, aes(color = species)) +
  stat_ellipse(level = 0.68, linewidth = 1.1) +
  scale_color_manual(values = c("darkorange","purple","cyan4")) +
  labs(title = "Penguin bill dimensions: By species",
 #      subtitle = "By species ",
       x = "Bill length (mm)",
       y = "Bill depth (mm)",
       color = "Penguin species",
       shape = "Penguin species") +
  theme(legend.position = c(0.85, 0.15),
        plot.title.position = "plot",
        plot.caption = element_text(hjust = 0, face= "italic"),
        plot.caption.position = "plot")

plt2

