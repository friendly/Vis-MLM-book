# test outliers display with geom_bagplot


remotes::install_github("corybrunson/gggda@outliers")
library(ggplot2)
library(dplyr)
library(heplots)
library(gggda)

source(here::here("R", "penguin", "penguin-colors.R"))

data(peng, package = "heplots")
ggplot(tibble::rownames_to_column(peng, var = "ID"), 
       aes(x = bill_length, y = bill_depth,
           color = species, shape = species, fill=species)) +
  geom_smooth(method = "lm", formula = y ~ x,
              se=FALSE, linewidth=2) +
  geom_bagplot(aes(label = ID),
               bag.alpha = 0.5, outlier.size = 5,
               outlier_labels = TRUE, outlier_points = TRUE,
               text.color = "black", vjust = 1.5, hjust = -0.5,
               coef = 2.5,
               show.legend = FALSE) +
  theme_bw(base_size = 14) +
  theme(legend.position = "inside",
        legend.position.inside = c(0.85, 0.15)) 


