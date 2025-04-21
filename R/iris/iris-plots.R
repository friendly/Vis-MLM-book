# iris data: scatterplot matrix
library(car)

scatterplotMatrix(~ Sepal.Length + Sepal.Width + Petal.Length + Petal.Width | Species,
  data = iris,
  col = scales::hue_pal()(3),
  pch = 15:17,
  smooth=FALSE,
  regLine = TRUE,
  ellipse=list(levels=0.68, fill.alpha=0.1),
  diagonal = FALSE,
  cex.lab = 1.5,
  legend = list(coords = "bottomleft", cex = 1.3, pt.cex = 1.2))
