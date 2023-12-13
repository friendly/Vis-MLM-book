#' ---
#' title: crime data - biplot2d3d
#' ---

library(biplot2d3d)
library(ggplot2)
library(ggbiplot)
library(dplyr)

data(crime, package = "ggbiplot")

crime.pca <- 
  crime |> 
  dplyr::select(where(is.numeric)) |>
  prcomp(scale. = TRUE)

# Default plot using Species as the group factor
biplot_2d(crime.pca, groups = crime$region)

# Use the typical visualization,
# placing scores and loadings around the same origin
biplot_2d(crime.pca, groups = crime$region,
          detach_arrows = FALSE)

biplot_2d(crime.pca, groups = crime$region,
          group_color = NULL,
          point_pch = c(1, 3, 2),
          group_star_cex = 0,
          group_ellipse_cex = 0,
          group_label_cex = 0,
          show_group_legend = T,
          group_legend_title = "Region")

# Try 3D ----------------------------

pca <- princomp(iris[, 1:4])

# Default plot using Species as the groups
biplot_3d(pca, groups = iris$Species)

# Plot groups as ellipsoids, make group label invisible and
# add a groups legend with no title.
# Customize the covariance arrows default setting.
biplot_3d(pca,
          groups = iris$Species,
          group_representation = "ellipsoids",
          ellipsoid_label_alpha = 0,
          show_group_legend = TRUE,
          group_legend_title = "",
          arrow_center_pos = c(.5, 0, .5),
          arrow_body_length = 1,
          arrow_body_width = 2,
          view_theta = 0,
          view_zoom = 0.9)

# Default plot using Species as the groups
biplot_3d(crime.pca, groups = crime$region)

# Plot groups as ellipsoids, make group label invisible and
# add a groups legend with no title.
# Customize the covariance arrows default setting.
biplot_3d(crime.pca, groups = crime$region,
          group_representation = "ellipsoids",
          ellipsoid_label_alpha = 1,
          show_group_legend = TRUE,
          group_legend_title = "",
          show_arrows = TRUE,
          arrow_color = "black",
          arrow_center_pos = c(0.5, 0.5, 0.5),
          arrow_body_length = 2,
          arrow_body_width = 2,
          view_theta = 0,
          view_zoom = 0.9)

