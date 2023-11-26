library(rgl)
library(bpca)
#source("c:/R/functions/ellipse3d.axes.R")

data(iris); 

open3d()
par3d(windowRect = c(0, 0, 800, 800) + 80)
rgl.bringtotop()

col <-c("blue", "green", "red")[iris$Species]
plot3d(iris[, 1:3], type="s", 
       size=0.4, 
       col=col, cex=2, 
       box=FALSE, aspect="iso")


cov <- cov(iris[, 1:3]) 
mu <- colMeans(iris[,1:3])
shade3d(ellipse3d(cov, centre=mu, level=0.68), 
       col="gray", alpha=0.2)

axes <- heplots::ellipse3d.axes(cov, centre=mu, level=0.72, labels=TRUE, cex=1.5)

M1 <- par3d("userMatrix")

# hand rotate / zoom, then save current position
M2 <- par3d("userMatrix")

# rotate to show PC1 & PC3
M3 <- par3d("userMatrix")

# rotate to show PC2 & 3
M4 <- par3d("userMatrix")

# Make a movie: rotation to PC coordinates
interp <-par3dinterp( userMatrix=list(M1, M2), 
                      extrapolate="constant", method="linear")
movie3d(interp, duration=4, fps=8, movie="biplot3d-iris")

# View in PCA space: 

interp3 <-par3dinterp(userMatrix=list(M1, M2, M3, M4, M3, M2, M1),  
                      extrapolate="constant", method="linear" )
movie3d(interp3, duration=6, fps=8, movie="biplot3d-iris3", dir="../anim")

#

# 3d static
iris.pca <- bpca(iris[, 1:4],
                 d=1:3)

plot(bpca(iris[-5],
          d=1:3),
     var.factor=.2,
     var.color=c('blue', 'red'),
     var.cex=1,
     obj.names=FALSE,
     obj.cex=1,
     obj.col=c('red', 'green3', 'blue')[unclass(iris$Species)],
     obj.pch=c('+', '*', '-')[unclass(iris$Species)])




