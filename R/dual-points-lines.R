# dual points & lines

library(matlib)

A <- matrix(c( 1, 2, 0,
              -1, 2, 1), 3, 2) |>
  print()


b <- c(2, 1, 1)

eqn <- showEqn(A, b, vars = c("x", "y"), simplify = TRUE)

plotEqn(A, b, vars = c("x", "y"))

# doesn't work
plotEqn(A, b, vars = c("x", "y"),
        labels = c("y = x - 2",
                   "y = 1/2 - x",
                   "y = 1"))

# as lines
x <- c(-2, .5, 1)
y <- c( 1, -1, 0)
#plot(a,b)

col <- 1:3
plot(x, y, col = col, pch = 16:18, cex = 1.5,
     xlim = c(-2, 4), ylim = c(-3, 2),)

plot(0,0, type ="n",
     xlab = expression(beta[0]),
     ylab = expression(beta[1]),
     xlim = c(-1, 4), ylim = c(-3, 2),
     cex.lab = 2)
for (i in seq_along(a)) {
  abline(x[i], y[i], col = col[i], lwd = 2)
}


