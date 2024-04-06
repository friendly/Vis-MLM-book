#' ---
#' title: Diabetes data, 3D plots
#' ---

data(Diabetes, package="heplots")
library(car)
library(rgl)

M <- matrix(
  c(0.6053, -0.2585, 0.7529, 0,
         0,  0.9458, 0.3247, 0,
    -0.796, -0.1966, 0.5725, 0,
         0,       0,      0, 1), nrow = 4, ncol=4
)

par3d(cex = 1.3,
      zoom = 0.71068,
      userMatrix = M,
      windowRect = c(34, 57, 602, 619))

cols <- c("darkgreen", "blue", "red")
scatter3d(sspg ~ instest + glutest, data=Diabetes,
          groups = Diabetes$group,
          ellipsoid = TRUE,
          surface = FALSE,
          col = cols,
          surface.col = cols)

um <- rgl::par3d("userMatrix")
dput(um)
# structure(c(0.605292320251465, -0.258487820625305, 0.752864718437195, 
#             0, 0, 0.94580602645874, 0.324732095003128, 0, -0.79600328207016, 
#             -0.196557849645615, 0.572489142417908, 0, 0, 0, 0, 1), dim = c(4L, 4L))
zoom<-par3d()$zoom
M <-par3d()$userMatrix
windowRect<-par3d()$windowRect
#[1]  34  57 602 619

view3d(userMatrix = M, zoom = zoom)

snapshot3d(filename = "images/diabetes-3d.png")

# another view
M1 <- par3d()$userMatrix
zoom1 <- par3d()$zoom

# > dput(round(M1, 4))
# structure(c(-0.8939, 0.2055, -0.3983, 0, 0, 0.8887, 0.4586, 0, 
#             0.4482, 0.4099, -0.7944, 0, 0, 0, 0, 1), dim = c(4L, 4L))
# > zoom1
# [1] 0.8638377

snapshot3d(filename = "images/diabetes-3d-1.png")



