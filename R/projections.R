#' ---
#' title: projections
#' ---

# idea from: Cook, Buja, Lee, Wickham, Grand Tours, Projection Pursuit, ...

vals <- c(0, 10)
x1 <- rep(vals, each = 4)
x2 <- rep(rep(vals, each = 2), length.out = 8)
x3 <- rep(vals, length.out = 8)

X <- cbind(x1, x2, x3)
X

#or, as a data frame
X <- expand.grid(x1 = vals, x2=vals, x3=vals) |> as.matrix()


# project on just x1, x2 plane

P1 <- rbind(diag(2), c(0,0))
Y1 <- X %*% P1

P2 <- matrix(c(0.71, 0.71, 0, -0.42, .42, 0.84), ncol=2)
Y2 <- X %*% P2

source("R/matrix2latex.R")

matrix2latex(X)
matrix2latex(P1)
matrix2latex(Y1)



pch <- rep(15:18, 2)
colors <- c("red", "blue", "darkgreen", "brown")
col <- rep(colors, each = 2)

data.frame(X, pch, col)

pairs(X, cex = 2, 
      pch = pch, col = col, 
      xlim = c(-1, 11), ylim = c(-1, 11))

op <- par(mar=c(4,4, 1, 1)+.5)
plot(Y1, cex = 3, 
     pch = pch, col = col,
     xlab = "Y[,1]", ylab = "Y[,2]",
     xlim = c(-1, 11), ylim = c(-1, 11))

plot(Y2, cex = 3, 
     pch = pch, col = col,
     xlab = "Y[,1]", ylab = "Y[,2]",
     xlim = c(-1, 15), ylim = c(-5, 14)
     )
par(op)

# Install and load the rgl package
if (!requireNamespace("rgl", quietly = TRUE)) {
  install.packages("rgl")
}



library(rgl)

open3d()
plot3d(X, type = "s", size = 2,  pch = pch, col = col)

# Create a function to draw a cube
draw_cube <- function(side_length) {
  # Define the vertices of the cube
  vertices <- cbind(
    c(0, 0, 0, 0, 1, 1, 1, 1),
    c(0, 0, 1, 1, 0, 0, 1, 1),
    c(0, 1, 0, 1, 0, 1, 0, 1)
  ) * side_length
  
  # Connect the vertices to form the edges of the cube
  edges <- matrix(c(
    1, 2, 3, 4, 5, 6, 7, 8,
    1, 2, 4, 3, 5, 6, 8, 7,
    1, 3, 7, 5, 2, 4, 8, 6
  ), ncol = 3, byrow = TRUE)
  
  # Open an rgl window and plot the cube
  open3d()
  points3d(vertices)
  lines3d(vertices[edges[, 1], ], vertices[edges[, 2], ])
}

# Call the function to draw the cube with side length 10
draw_cube(10)


