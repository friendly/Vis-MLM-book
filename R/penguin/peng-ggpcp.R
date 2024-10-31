#' ---
#' title: Penguin data, parallel coordinate plots
#' ---
#' 

library(ggplot2)
library(ggpcp)
library(dplyr)

#load(here::here("data", "peng.RData"))
data(peng, package="heplots")
source("R/penguin/penguin-colors.R")
cols <- peng.colors()

# change levels of sex
peng <- peng |>
  mutate(sex = factor(sex, labels = c("Female", "Male")))

# Fig 2
# peng |> 
#   pcp_select(4,3,5:6, sex, species) |>   #   var selection (sec 3.1)
#   pcp_scale(method="uniminmax") |>       #   scale values (sec 3.2)
#   pcp_arrange() |>                       #   arrange categ. data
#   ggplot(aes_pcp()) +                     # create chart layers:
#   geom_pcp_axes() +                     #   vertical lines for axes
#   geom_pcp(aes(colour = species),       #   line  segments
#            alpha = 0.8, overplot="none") +
#   geom_pcp_labels() +                    #   label categories
#   labs(x = "", y = "") +
#   theme_penguins()

# Use this for first ggpcp plot, Fig. 3-33
peng |>
  pcp_select(bill_length:body_mass, sex, species) |>
  pcp_scale(method = "uniminmax") |>
  pcp_arrange() |>
  ggplot(aes_pcp()) +
  geom_pcp_axes() +
  geom_pcp(aes(colour = species), alpha = 0.8, overplot = "none") +
  geom_pcp_labels() +
  scale_colour_manual(values = peng.colors()) +
  theme_bw(base_size = 16) +
  # scale_x_discrete(
  #   expand = expansion(add = 0.3),
  #   labels = c(
  #     "Bill Depth", "Bill Length",
  #     "Flipper Length", "Body Mass",
  #     "Sex", "Species")
  #   ) +
  labs(x = "", y = "") +
  theme(axis.title.y = element_blank(), axis.text.y = element_blank(), 
        axis.ticks.y = element_blank(), legend.position = "none")

# reorder levels to put species and islands together
peng1 <- peng |>
  mutate(species = factor(species, levels = c("Chinstrap", "Adelie", "Gentoo"))) |>
  mutate(island = factor(island, levels = c("Dream", "Torgersen", "Biscoe")))

peng1 |>
  pcp_select(species, island, bill_length:body_mass) |>
  pcp_scale() |>
  pcp_arrange(method = "from-left") |>
  ggplot(aes_pcp()) +
  geom_pcp_axes() +
  geom_pcp(aes(colour = species), alpha = 0.6, overplot = "none") +
  geom_pcp_boxes(fill = "white", alpha = 0.5) +
  geom_pcp_labels() +
  scale_colour_manual(values = peng.colors()[c(2,1,3)]) +
  theme_bw() +
  labs(x = "", y = "") +
  theme(axis.text.y = element_blank(), 
        axis.ticks.y = element_blank(),
        legend.position = "none") 
  

