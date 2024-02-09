#' ---
#' title: problems with matlib::vectors
#' ---
#' 
vals <- c(0, 10)
X <- expand.grid(x1 = vals, x2=vals, x3=vals) |> as.matrix()

# project on just x1, x2 plane
P1 <- rbind(diag(2), c(0,0))
Y1 <- X %*% P1

# oblique projection
P2 <- matrix(c(0.71, 0.71, 0, -0.42, .42, 0.84), ncol=2)
Y2 <- X %*% P2

# draw X vectors in Y space
xlim <- ylim <- c(-1.1, 1.1)
axes.x <- c(-1, 1, NA, 0, 0)
axes.y <- c(0, 0, NA, -1, 1)
labs <- c(expression(x[1]), expression(x[2]), expression(x[3]))

op <- par(mar=c(4, 5, 1, 1)+.1)
plot(xlim, ylim, type = "n", asp=1,
     xlab = expression(y[1]), ylab = expression(y[2]),
     cex.lab = 1.8)
plotrix::draw.circle(0, 0, 1, 
                     col = adjustcolor("skyblue", alpha = 0.2))
lines(axes.x, axes.y, col = "grey")
matlib::vectors(P1, labels = labs, cex.lab = 1.8, lwd = 3)

plot(xlim, ylim, type = "n", asp=1,
     xlab = expression(y[1]), ylab = expression(y[2]),
     cex.lab = 1.8)
plotrix::draw.circle(0, 0, 1, 
                     col = adjustcolor("skyblue", alpha = 0.2))
lines(axes.x, axes.y, col = "grey")
matlib::vectors(P2, labels = labs, cex.lab = 1.8, lwd = 3)
par(op)
