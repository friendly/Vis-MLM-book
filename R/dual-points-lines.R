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
a <- c(-2, .5, 1)
b <- c( 1, -1, 0)
#plot(a,b)

op <- par(mar = c(5, 5, 1, 1) + .1)
col <- c("red", "blue", "darkgreen")
pch <- c(16, 17, 19)
plot(a, b, col = col, 
     pch = pch, cex = 2, cex.lab = 2,
     xlim = c(-3, 2), ylim = c(-2, 2),
     xlab = expression(beta[0]),
     ylab = expression(beta[1]),
     asp = 1)
par(op)

plot(0,0, type ="n",
     xlab = "x",
     ylab = "y",
     xlim = c(-1, 4), ylim = c(-3, 2),
     cex.lab = 2, asp = 1)
abline(h = 0, v = 0, col = "gray")
for (i in seq_along(a)) {
  abline(x[i], y[i], col = col[i], lwd = 2)
}
eqn <- c("y = x - 2", 
         "y = 0.5 - x",
         "y = 1")
angle <- c(45, -45, 0)
xl <- c(-0.5, 2,  1)
yl <- c(-2.2, -1.4, 1.2)
for (i in 1:3) {
text(x = xl[i], y = yl[i], 
     label = eqn[i], 
     col = col[i], 
     srt = angle[i],
     pos = 4,
     cex = 1.5)
}

