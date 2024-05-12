#' ---
#' title: Penguin data -- Simpsons paradox
#' ---

library(ggplot2)
library(dplyr)
library(tidyr)

# data(penguins, package = "palmerpenguins")
# 
# penguins <- penguins |>
#   drop_na()

data(peng, package = "heplots")

plt1 <- ggplot(data = peng,
                aes(x = bill_length,
                    y = bill_depth)) +
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

plt2 <- ggplot(data = peng,
               aes(x = bill_length,
                   y = bill_depth,
                   color = species,
                   shape = species,
                   fill = species,
                   group = species)) +
  geom_point(size = 2,
             alpha = 0.8) +
  geom_smooth(method = "lm", formula = y ~ x, 
              se = TRUE, alpha = 0.3,
#              aes(fill = species)
              ) +
  stat_ellipse(level = 0.68, linewidth = 1.1) +
  scale_color_manual(values = c("darkorange","purple","cyan4")) +
  scale_fill_manual(values = c("darkorange","purple","cyan4")) +
  labs(title = "Penguin bill dimensions: By species",
       x = "Bill length (mm)",
       y = "Bill depth (mm)",
       color = "Penguin species",
       shape = "Penguin species",
       fill = "Penguin species") +
  theme(legend.position = "inside",
        legend.position.inside = c(0.85, 0.15),
#        plot.title.position = "plot",
        plot.caption = element_text(hjust = 0, face= "italic"),
        plot.caption.position = "plot")

plt2

# center within groups

peng.centered <- peng |>
  group_by(species) |>
  mutate(bill_length = scale(bill_length, scale = FALSE),
         bill_depth  = scale(bill_depth, scale = FALSE))

plt3 <- ggplot(data = peng.centered,
               aes(x = bill_length,
                   y = bill_depth,
                   color = species,
                   shape = species,
                   fill = species,
                   group = species)) +
  geom_point(size = 2,
             alpha = 0.8) +
  geom_smooth(method = "lm", formula = y ~ x, 
              se = FALSE) +
  stat_ellipse(level = 0.68, linewidth = 1.1) +
  scale_color_manual(values = c("darkorange","purple","cyan4")) 
  scale_fill_manual(values = c("darkorange","purple","cyan4")) 
  
plt3
