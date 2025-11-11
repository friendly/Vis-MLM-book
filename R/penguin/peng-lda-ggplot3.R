#' ---
#' title: Penguin data discriminant boundaries using candisc
#' ---

library(MASS)
library(ggplot2)
library(patchwork)
library(candisc)
library(dplyr)
#library(marginaleffects)   # for datagrid

data(peng, package="heplots")
source(here::here("R/penguin/penguin-colors.R"))

legend_inside <- function(position) {
  theme(legend.position = "inside",
        legend.position.inside = position)
}

peng.lda <- lda(species ~ bill_length + bill_depth + flipper_length + body_mass, 
                data = peng)

means <- peng |>
  group_by(species) |>
  summarise(across(c(bill_length, bill_depth), \(x) mean(x, na.rm = TRUE) ))

plot_discrim(peng.lda, bill_depth ~ bill_length,
             pt.size = 2) +
  stat_ellipse(aes(color=species), level = 0.68, linewidth = 1.2) +
  geom_label(data=means, aes(label = species, color = species),
             size =5) +
  theme_penguins() 

# bill_length & body_mass
# 
means <- peng |>
  group_by(species) |>
  summarise(across(c(bill_length, body_mass), mean))

plot_discrim(peng.lda, body_mass ~ bill_length,
             ellipse = TRUE,
#             data = peng,
             pt.size = 2) +
  # stat_ellipse(aes(color=species), level = 0.68, 
  #              linewidth = 1.2) +
  geom_label(data=means, aes(label = species, color = species),
             size =5) +
  theme_penguins() +
  theme_minimal(base_size = 16) +
  theme(legend.position = "none")


# ---- Do the same for qda() ----------
peng.qda <- qda(species ~ bill_length + bill_depth + flipper_length + body_mass, 
                data = peng)

means <- peng |>
  group_by(species) |>
  summarise(across(c(bill_length, bill_depth), \(x) mean(x, na.rm = TRUE) ))

plot_discrim(peng.qda, bill_depth ~ bill_length,
             ellipse = TRUE,
             pt.size = 2) +
#  stat_ellipse(aes(color=species), level = 0.68, linewidth = 1.2) +
  geom_label(data=means, aes(label = species, color = species),
             size =5) +
  theme_penguins() 

means <- peng |>
  group_by(species) |>
  summarise(across(c(bill_length, body_mass), mean))

plot_discrim(peng.qda, body_mass ~ bill_length,
             ellipse = TRUE,
             pt.size = 2) +
  geom_label(data=means, aes(label = species, color = species),
             size =5) +
  theme_penguins() 

