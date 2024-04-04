library(ggplot2)
library(ggbiplot)
library(dplyr)

data(Diabetes, package="heplots")

diab.pca <- 
  Diabetes |> 
  dplyr::select(where(is.numeric)) |>
  prcomp(scale. = TRUE)

plt <- ggbiplot(diab.pca,
     obs.scale = 1, var.scale = 1,
     groups = Diabetes$group,
     var.factor = 1.4,
     ellipse = TRUE, 
     ellipse.prob = 0.5, ellipse.alpha = 0.1,
     circle = TRUE,
     varname.size = 4) +
  labs(fill = "Group", color = "Group") +
  theme_minimal(base_size = 14) +
  theme(legend.position = "none")

# label ellipses directly

scores <- data.frame(diab.pca$x[, 1:2], group = Diabetes$group)
centroids <- scores |>
  group_by(group) |>
  summarize(PC1 = mean(PC1),
            PC2 = mean(PC2))

plt + geom_label(data = centroids, 
                 aes(x = PC1, y = PC2, 
                     label=group, color = group),
                 nudge_y = 0.2)


# What about 3D?
library(biplot2d3d)
# only works with princomp()
diab.princomp <- 
  Diabetes |> 
  dplyr::select(where(is.numeric)) |>
  princomp(cor = TRUE)


biplot_3d(diab.princomp,
          groups = Diabetes$group,
          detach_arrows = FALSE,
          show_fitAnalysis = FALSE,
          group_representation = "ellipsoid",
          group_legend_title = "Group")
# Error in if (nrow(loadings) > 0) { : argument is of length zero

library(compositions)
biplot3D(diab.princomp)



