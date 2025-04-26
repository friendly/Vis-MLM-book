# from: https://r-graph-gallery.com/3-r-animated-cube.html
library( rgl )
library(magick)

# Let's use the iris dataset

# This is ugly
colors <- c("royalblue1", "darkcyan", "oldlace")
iris_colors <-c("blue", "darkgreen", "brown4")
iris$color <- iris_colors[ as.numeric( as.factor(iris$Species) ) ]

# Static chart
plot3d( iris[,1], iris[,2], iris[,3],
        xlab = "Sepal length",
        ylab = "Sepal width",
        zlab = "Petal length",
        col = iris$color, type = "s", radius = .1 )

# manipulate the plot, then save desired static view for reproducibility
zoom<-par3d()$zoom
userMatrix<-par3d()$userMatrix
windowRect<-par3d()$windowRect

dput(userMatrix)
# structure(c(0.444798916578293, 0.112694330513477, -0.888512134552002, 
#             0, -0.891067445278168, 0.155696094036102, -0.426330387592316, 
#             0, 0.0902928337454796, 0.981355786323547, 0.169671669602394, 
#             0, 0, 0, 0, 1), dim = c(4L, 4L))

zoom
#[1] 0.952381

userMatrix

windowRect
#[1] 138  31 897 823

# We can indicate the axis and the rotation velocity
play3d( spin3d( axis = c(0, 0, 1), rpm = 20), duration = 10 )

# Save like gif
movie3d(
  movie="R/iris/iris-3D-spin", 
  spin3d( axis = c(0, 0, 1), rpm = 7),
  duration = 10, 
  dir = ".",
  type = "gif", 
  clean = TRUE)
