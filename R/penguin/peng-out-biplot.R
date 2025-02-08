#' ---
#' title: Penguin data - biplots for outlier detection
#' ---

library(heplots)
library(dplyr)
library(ggplot2)
# library(ggbiplot)
library(factoextra)

data(peng, package="heplots")

# find potential multivariate outliers
DSQ <- heplots::Mahalanobis(peng[, 3:6])
noteworthy <- order(DSQ, decreasing = TRUE)[1:3] |> print()

peng.pca <- prcomp(~ bill_length + bill_depth + flipper_length + body_mass,
                   data=peng, scale. = TRUE)
summary(peng.pca)

source("R/penguin/penguin-colors.R")
# create vector of labels, blank except for the noteworthy
lab <- 1:nrow(peng)
lab <- ifelse(lab %in% noteworthy, lab, "")

ggbiplot(peng.pca, # obs.scale = 1, var.scale = 1,
         choices = 3:4,
         groups = peng$species, 
         ellipse = TRUE, ellipse.alpha = 0.1,
         circle = TRUE,
         var.factor = 2.5,
         geom.ind = c("point", "text"),
         point.size = 2,
         labels = lab, labels.size = 6,
         varname.size = 5,
         clip = "off") +
  theme_minimal(base_size = 14) +
  theme_penguins("dark") +
  #  theme_penguins(name = "Species") +
  theme(legend.direction = 'horizontal', legend.position = 'top') 

# first two dims
ggbiplot(peng.pca, # obs.scale = 1, var.scale = 1,
         choices = 1:2,
         groups = peng$species, 
         ellipse = TRUE, ellipse.alpha = 0.1,
         circle = TRUE,
         var.factor = 1,
         geom.ind = c("point", "text"),
         point.size = 1,
         labels = lab, labels.size = 6,
         varname.size = 5,
         clip = "off") +
  theme_minimal(base_size = 14) +
  theme_penguins("dark") +
  scale_shape_discrete() +
  theme(legend.direction = 'horizontal', legend.position = 'top') 
