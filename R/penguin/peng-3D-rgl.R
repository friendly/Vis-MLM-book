library(rgl)
library(bpca)
library(heplots)

data(peng, package="heplots")


# just keep bill dimensions and body_mass
peng <- peng[, c(3,4,6, 1)]
names(peng)

shapes <- c(15, 17, 18)
source("R/penguin/penguin-colors.R")
colors <- peng.colors("dark")

open3d()
par3d(windowRect = c(0, 0, 800, 800) + 80)
rgl.bringtotop()

col <- colors[peng$species]
plot3d(peng[, 1:3], type="s", 
       size=0.9, 
       col=col, cex=2, 
       box=FALSE)

# single ellipse & PCA axes
cov <- cov(peng[, 1:3]) 
mu <- colMeans(peng[,1:3])
shade3d(ellipse3d(cov, centre=mu, level=0.68), 
        col="gray", alpha=0.2)

axes <- ellipse3d.axes(cov, centre=mu, 
                       level=0.9, labels=TRUE, 
                       label.ends = 1:6,
                        cex=1.8, lwd = 3)

# one ellipse for each

open3d()
par3d(windowRect = c(0, 0, 800, 800) + 80)
rgl.bringtotop()

col <- colors[peng$species]
par3d(cex.lab = 2)
plot3d(peng[, 1:3], type="s", 
       size=0.9, 
       col=col, cex=2, cex.lab = 2,
       box=FALSE)

for(sp in levels(peng$species)) {
  pdata <- peng |>
    filter(species == sp)
  cov <- cov(pdata[, 1:3]) 
  mu <- colMeans(pdata[, 1:3])
  shade3d(ellipse3d(cov, centre=mu, level=0.68), 
          col=colors[sp], alpha=0.2)
}

# manipulate the plot, then save desired static view for reproducibility
zoom<-par3d()$zoom
userMatrix<-par3d()$userMatrix
windowRect<-par3d()$windowRect

dput(userMatrix)
structure(c(0.970815122127533, 0.0255952924489975, -0.238459393382072, 
0, -0.239064514636993, 0.182608127593994, -0.95367830991745, 
0, 0.0191349126398563, 0.982852518558502, 0.183397591114044, 
0, 0, 0, 0, 1), dim = c(4L, 4L))

zoom
1

par3d(userMatrix =
  structure(c(0.970815122127533, 0.0255952924489975, -0.238459393382072, 
              0, -0.239064514636993, 0.182608127593994, -0.95367830991745, 
              0, 0.0191349126398563, 0.982852518558502, 0.183397591114044, 
              0, 0, 0, 0, 1), dim = c(4L, 4L))
)

snapshot3d(filename = "images/peng-3D-ellipses.png")

play3d( spin3d( axis = c(0, 0, 1), rpm = 10), duration = 10 )


# Save like gif
movie3d(
  movie="images/peng-3D-spin", 
  spin3d( axis = c(0, 0, 1), rpm = 7),
  duration = 5, fps = 5,
  dir = ".",
  type = "gif", 
  clean = TRUE)
