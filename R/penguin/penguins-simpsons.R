#' ---
#' title: Penguin data -- Simpsons paradox
#' ---

library(ggplot2)
library(dplyr)
library(tidyr)
library(patchwork)

# data(penguins, package = "palmerpenguins")
# 
# penguins <- penguins |>
#   drop_na()

data(peng, package = "heplots")
source("R/penguin/penguin-colors.R")
# use theme_penguins("dark)
#cols <- peng.colors("dark")

theme_set(theme_bw(base_size = 14))

labels <- labs(
  x = "Bill length (mm)",
  y = "Bill depth (mm)",
  color = "Species",
  shape = "Species",
  fill = "Species") 

plt1 <- ggplot(data = peng,
               aes(x = bill_length,
                   y = bill_depth)) +
  geom_point(size = 1.5) +
  geom_smooth(method = "lm", formula = y ~ x, 
              se = TRUE, color = "gray50") +
  stat_ellipse(level = 0.68, linewidth = 1.1) +
  ggtitle("Ignoring species") +
  labels

plt1

  
legend.position <-
  theme(legend.position = "inside",
        legend.position.inside = c(0.83, 0.16))

plt2 <- ggplot(data = peng,
               aes(x = bill_length,
                   y = bill_depth,
                   color = species,
                   shape = species,
                   fill = species)) +
  geom_point(size = 1.5,
             alpha = 0.8) +
  geom_smooth(method = "lm", formula = y ~ x, 
              se = TRUE, alpha = 0.3) +
  stat_ellipse(level = 0.68, linewidth = 1.1) +
  ggtitle("By species") +
  labels +
  theme_penguins("dark") +
  legend.position 

plt2

# center within groups, translate to grand means
means <- colMeans(peng[, 3:4])
peng.centered <- peng |>
  group_by(species) |>
  mutate(bill_length = means[1] + scale(bill_length, scale = FALSE),
         bill_depth  = means[2] + scale(bill_depth, scale = FALSE))

plt3 <- ggplot(data = peng.centered,
               aes(x = bill_length,
                   y = bill_depth,
                   color = species,
                   shape = species,
                   fill = species)) +
  geom_point(size = 1.5,
             alpha = 0.8) +
  geom_smooth(method = "lm", formula = y ~ x, 
              se = TRUE, alpha = 0.3) +
  stat_ellipse(level = 0.68, linewidth = 1.1) +
  labels +
  ggtitle("Within species") +
  theme_penguins("dark") +
  legend.position 

plt3


plt1 + plt2 + plt3

ggsave("images/peng-simpsons.png", height = 5, width = 15, dpi = 200)

