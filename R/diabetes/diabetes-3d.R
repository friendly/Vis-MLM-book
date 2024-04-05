#' ---
#' title: Diabetes data, 3D plots
#' ---

data(Diabetes, package="heplots")
library(car)
library(rgl)

scatter3d(sspg ~ instest + glutest, data=Diabetes,
          groups = Diabetes$group,
          ellipsoid = TRUE,
          surface = FALSE,
          col = c("darkgreen", "blue", "red"),
          surface.col = c("darkgreen", "blue", "red"))

um <- rgl::par3d("userMatrix")
dput(um)
# structure(c(0.605292320251465, -0.258487820625305, 0.752864718437195, 
#             0, 0, 0.94580602645874, 0.324732095003128, 0, -0.79600328207016, 
#             -0.196557849645615, 0.572489142417908, 0, 0, 0, 0, 1), dim = c(4L, 4L))
zoom<-par3d()$zoom
userMatrix<-par3d()$userMatrix
windowRect<-par3d()$windowRect

rgl::snapshot3d(filename = "images/diabetes-3d.png")
