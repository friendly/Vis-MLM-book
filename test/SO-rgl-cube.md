# How to use other point shapes in rgl?

I'm trying to illustrate the idea of projections using points on a cube, shown with `rgl` and what that
looks like in various 2D projections. 

My goal is to use different colors and shapes to distinguish the points, both in 2D plots and 3D,
but I can't figure out how to plot the points in `rgl` using other than  spheres.
My current figure looks like this:
C:\R\Projects\Vis-MLM-book\images\proj-combined.png


I generate the points on a 10^3 cube and two projections as:

```
vals <- c(0, 10)
X <- expand.grid(x1 = vals, x2=vals, x3=vals) |> as.matrix()

# project on just x1, x2 plane
P1 <- rbind(diag(2), c(0,0))
Y1 <- X %*% P1
# oblique projection
P2 <- matrix(c(0.71, 0.71, 0, -0.42, .42, 0.84), ncol=2)
Y2 <- X %*% P2
```

The 2D plots use 4 different colors and 4 `pch` shapes (square, circle, triangle, diamond)

```
pch <- rep(15:18, 2)
colors <- c("red", "blue", "darkgreen", "brown")
col <- rep(colors, each = 2)

plot(Y1, cex = 3, 
     pch = pch, col = col,
     xlab = "Y[,1]", ylab = "Y[,2]",
     xlim = c(-1, 11), ylim = c(-1, 11))

plot(Y2, cex = 3, 
     pch = pch, col = col,
     xlab = "Y[,1]", ylab = "Y[,2]",
     xlim = c(-1, 15), ylim = c(-5, 14)
     )
```

Here's what I tried using `rgl`. Obviously, `pch` has no effect using `type = "s"`.
What I'd like are the shapes: cube, sphere, pyramid, diamond (or anything else)

```
library(rgl)
open3d()
plot3d(X, type = "s", size = 2,  pch = pch, col = col)
```



