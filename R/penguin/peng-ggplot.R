#' ---
#' title: Penguins data, scatterplot matrix & data ellipses
#' ---

if(!require("ggdensity")) install.packages("ggdensity")
library(dplyr)
library(ggplot2)
library(car)
library(ggdensity)
library(patchwork)

data(peng, package="heplots")
#str(peng)

source("R/penguin/penguin-colors.R")

theme_set(theme_bw(base_size = 16))
#options(ggplot2.discrete.colour = peng.colors("dark")) 
theme_penguins <- list(
  scale_color_penguins(shade="dark"),
  scale_fill_penguins(shade="dark")
)

ggplot(peng, 
       aes(x = bill_length, y = bill_depth,
           color = species, shape = species, fill=species)) +
  geom_point(size=2) +
  geom_smooth(method = "lm", formula = y ~ x,
              se=FALSE, linewidth=2) +
  geom_smooth(method = "loess",  formula = y ~ x,
              linewidth = 1.5, se = FALSE, alpha=0.1) +
  stat_ellipse(geom = "polygon", level = 0.95, alpha = 0.4) +
  theme_penguins +
  theme(legend.position = "inside",
        legend.position.inside=c(0.85, 0.15))
      
# show ellipses, reg lines, no points
ggplot(peng, 
       aes(x = bill_length, y = bill_depth,
           color = species, fill=species)) +
  geom_smooth(method = "lm",  se=FALSE, linewidth=2) +
  stat_ellipse(geom = "polygon", level = 0.95, alpha = 0.2) +
  stat_ellipse(geom = "polygon", level = 0.68, alpha = 0.2) +
  stat_ellipse(geom = "polygon", level = 0.40, alpha = 0.2) +
  theme_penguins +
  theme(legend.position = "inside",
        legend.position.inside=c(0.85, 0.15))

# use bivariate contours
p1 <- ggplot(peng, 
       aes(x = bill_length, y = bill_depth,
           color = species)) +
  geom_smooth(method = "lm",  se=FALSE, linewidth=2) +
  geom_density_2d(linewidth = 1.2, bins = 8) +
  ggtitle("geom_density_2d") +
  theme(legend.position = "inside",
        legend.position.inside=c(0.85, 0.15))

p2 <- ggplot(peng, 
       aes(x = bill_length, y = bill_depth,
           color = species, fill = species)) +
  geom_smooth(method = "lm",  se=FALSE, linewidth=2) +
  geom_hdr(probs = c(0.95, 0.68, 0.4), show.legend = FALSE) +
  ggtitle("ggdensity::geom_hdr") +
  theme(legend.position = "inside",
        legend.position.inside=c(0.85, 0.15))

p1 + p2
