library(rgl)
library(bpca)

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
       size=0.6, 
       col=col, cex=2, 
       box=FALSE)

cov <- cov(peng[, 1:3]) 
mu <- colMeans(peng[,1:3])
shade3d(ellipse3d(cov, centre=mu, level=0.68), 
        col="gray", alpha=0.2)

axes <- heplots::ellipse3d.axes(cov, centre=mu, level=0.8, labels=TRUE, cex=1.5, lwd = 3)


