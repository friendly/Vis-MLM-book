# How to label points selectively in factoextra::fviz_pac_biplot

library(heplots)
library(dplyr)
library(ggplot2)
library(ggbiplot)
library(factoextra)

data(peng, package="heplots")

# find potential multivariate outliers
DSQ <- heplots::Mahalanobis(peng[, 3:6])
noteworthy <- order(DSQ, decreasing = TRUE)[1:3] |> print()

peng.pca <- prcomp (~ bill_length + bill_depth + flipper_length + body_mass,
                    data=peng, scale. = TRUE)

# create vector of labels, blank except for the noteworthy
lab <- 1:nrow(peng)
lab <- ifelse(lab %in% noteworthy, lab, "")

ggbiplot(peng.pca, # obs.scale = 1, var.scale = 1,
         groups = peng$species, 
         ellipse = TRUE, 
         circle = TRUE,
         #         labels = lab,
         varname.size = 5) +
  #  scale_color_discrete(name = 'Penguin Species') +
  geom_text(data = subset(peng_plot, note==TRUE),
            aes(label = id),
            nudge_y = .4, color = "black", size = 5) +
  theme_minimal() +
  theme_penguins(name = "Species") +
  theme(legend.direction = 'horizontal', legend.position = 'top') 

# last 2 dimensions
ggbiplot(peng.pca,  obs.scale = 1, var.scale = 1,
         choices = 3:4,
         groups = peng$species, 
         ellipse = TRUE, 
         circle = TRUE,
         varname.size = 5) +
  #  scale_color_discrete(name = 'Penguin Species') +
  theme_minimal() +
  theme_penguins(name = "Species") +
  theme(legend.direction = 'horizontal', legend.position = 'top') 

fviz_pca_biplot(
  peng.pca,
  axes = 3:4,
  habillage = peng$species,
  addEllipses = TRUE, ellipse.level = 0.68,
  palette = peng.colors("dark"),
  arrowsize = 1.5, col.var = "black", labelsize=4,
#  label = lab
) +
  theme(legend.position = "top")


