library(ggplot2)
library(ggbiplot)

data(NeuroCog, package="heplots")
str(NeuroCog)

NC.pca <- NeuroCog |>
  select(Speed:ProbSolv) |>
  prcomp(scale. = TRUE)
  
NC.pca <- reflect(NC.pca, columns = 2)
ggbiplot(NC.pca, obs.scale = 1, var.scale = 1,
    groups = NeuroCog$Dx, point.size=2,
    varname.size = 6, 
    varname.color = "black",  #scales::muted("black"),
    var.factor = 1.3,
    ellipse = TRUE, ellipse.linewidth = 1.2, ellipse.alpha = 0.1,
    circle = TRUE,
    clip = "off") +
  labs(fill = "Dx", color = "Dx") +
  theme_minimal(base_size = 14) +
  theme(legend.direction = 'horizontal', legend.position = 'top')

