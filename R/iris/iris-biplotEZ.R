# biplotEZ example, from https://github.com/MuViSU/biplotEZ/blob/main/vignettes/Biplots_in_3D.Rmd

library(biplotEZ)
library(rgl)

biplot(iris) |> 
  PCA(group.aes = iris$Species,dim.biplot = 3) |>
  axes(col="black") |> 
  plot()

# Ellipses are added to a 3D biplot using the ellipses() function which works in the same way as a 2D biplot.
biplot(iris) |> 
  PCA(group.aes = iris[,5],dim.biplot = 3) |> 
  axes(col="black") |> 
  ellipses(kappa = 3,opacity = 0.5) |> 
  plot()