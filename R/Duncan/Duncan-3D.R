#' ---
#' title: Duncan data, 3D plots
#' ---


library(car)
library(matlib)
library(rgl)

data(Duncan, package = "carData")

# 3D data plots
# -------------

#scatter3d(prestige ~ income + education, data=Duncan, id=list(n=3))

# Make a 3D plot of the Duncan data, with a fitted regression plane.
# 
op <- par3d(cex = 1.2,   # can't pass this to scatter3d
            windowRect = c(0, 0, 800, 800) + 80)
scatter3d(prestige ~ income + education, data=Duncan, 
          id=list(n=3),
          grid = TRUE, grid.lines = 10,
          cex = 2)
box3d()   # better to have just the side walls and the bottom

show2d({
  par(mar=c(0,0,0,0))
  dataEllipse(income ~ education, data=Duncan, 
    plot.points = TRUE, add = FALSE,
    levels = 0.68,
    label.cex = 2,
    center.pch = "",
    col = "blue",
    fill = TRUE, fill.alpha = 0.2,
    xlab = "", ylab= "", yaxt = "n", xaxt = "n")
  points(x=Duncan$education,
         y=Duncan$income,
         cex = 4)
  }, 
  face = "y-")

zoom<-par3d()$zoom
userMatrix<-par3d()$userMatrix
windowRect<-par3d()$windowRect

dput(userMatrix)
structure(c(0.408386796712875, 0.0131282666698098, -0.912714540958405, 
0, 0, 0.999896585941315, 0.0143822720274329, 0, 0.912808954715729, 
-0.00587353017181158, 0.408344566822052, 0, 0, 0, 0, 1), dim = c(4L, 
4L))
zoom
1

par3d(userMatrix =
structure(c(0.408386796712875, 0.0131282666698098, -0.912714540958405, 
0, 0, 0.999896585941315, 0.0143822720274329, 0, 0.912808954715729, 
-0.00587353017181158, 0.408344566822052, 0, 0, 0, 0, 1), dim = c(4L, 
4L)))

snapshot3d(filename = "images/Duncan-3D-ellipses.png")


# spin around the Y axis
play3d(spin3d(axis = c(0,1,0), rpm = 5),
       duration = 5)

par3d(op)


movie3d(
  movie="images/Duncan-3D-spin", 
  spin3d( axis = c(0, 1, 0), rpm = 4),
  duration = 5, fps = 5,
  dir = ".",
  type = "gif", 
  clean = TRUE)


# Plot in vector space
# -- why can't I control this better?
# --------------------
plot(regvec3d(prestige ~ income + education, data=Duncan),
     col = c("black", "red", "blue", "brown", "green"),
     col.plane = scales::alpha("grey"), .20)

plot(regvec3d(prestige ~ income + education, data=Duncan, abbreviate=3))


plot(regvec3d(prestige ~ income + education, data=Duncan, abbreviate=1), 
     show.plane=FALSE, grid=TRUE, show.marginal=TRUE)

plot(regvec3d(prestige ~ income + education + type, data=Duncan)) # residualizes for type

#Here's a nice example of Simpson's paradox:

plot(regvec3d(SATM ~ pay + percent, data=car::States, 
              abbreviate=2, scale=TRUE), 
     show.marginal=TRUE)

