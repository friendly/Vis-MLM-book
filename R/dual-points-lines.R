# dual points & lines

library(matlib)

intersections <- function(A, b) {
  neq <- nrow(A)
  res <- matrix(NA, nrow=neq*(neq - 1)/2, ncol=2)
  colnames(res) <- c("x", "y")
  k <- 0
  for (i in 1:(neq - 1)) {
    for (j in (i + 1):neq) {
      k <- k + 1
      x <- try(solve(A[c(i, j), ], b[c(i, j)]), silent=TRUE)
      if (!inherits(x, "try-error")) res[k, ] <- x
    }
  }
  res
}

A <- matrix(c( 1, 2, 0,
              -1, 2, 1), 3, 2) |>
  print()


b <- c(2, 1, 1)

eqn <- showEqn(A, b, vars = c("x", "y"), simplify = TRUE)

plotEqn(A, b, vars = c("x", "y"))

pts <- intersections(A,b) |> print()

# doesn't work
plotEqn(A, b, vars = c("x", "y"),
        labels = c("y = x - 2",
                   "y = 1/2 - x",
                   "y = 1"))

a <- c(-2, .5, 1)
b <- c( 1, -1, 0)
# plot lines in data space
x <- a
y <- b
op <- par(mar = c(5, 5, 1, 1) + .1,
          mfrow = c(1, 2))
plot(0,0, type ="n",
     xlab = "x",
     ylab = "y",
     xlim = c(-1, 4), ylim = c(-3, 2),
     cex.lab = 2, asp = 1)
abline(h = 0, v = 0, col = "gray")
for (i in seq_along(a)) {
  abline(x[i], y[i], col = col[i], lwd = 2)
}
#points(pts, pch = 16)

# simplify equations
eqn <- c("y = x - 2", 
         "y = 0.5 - x",
         "y = 1")
angle <- c(45, -45, 0)
xl <- c(-0.5, 2,  1)
yl <- c(-2.0, -1.2, 1.)
pos <- c(4, 4, 3)
for (i in 1:3) {
  text(x = xl[i], y = yl[i], 
       label = eqn[i], 
       col = col[i], 
       srt = angle[i],
       pos = pos[i],
       cex = 1.5)
}

# plot points in beta space
op <- par(mar = c(5, 5, 1, 1) + .1)
col <- c("red", "blue", "darkgreen")
pch <- c(16, 17, 19)
plot(a, b, col = col, 
     pch = pch, cex = 2, cex.lab = 2,
     xlim = c(-3, 2), ylim = c(-2, 2),
     xlab = expression(beta[0]),
     ylab = expression(beta[1]),
     asp = 1)
text(a, b, label = paste0("(", a, ",", b, ")"), col = col, pos = 1)
par(op)


# try with workers data 
data(workers, package = "matlib")   
head(workers)

vars <- c("Experience", "Income")
plot(workers[, vars],
     pch = 16, cex = 1.5,
     cex.lab = 1.5)

workers.mod <- lm(Income ~ Experience, data = workers)
X <- model.matrix(workers.mod)
y <- workers[, "Experience"]

# show each equation as a line
# labels = rownames(X) doesn't work
plotEqn(X, y,
        vars = c(expression(beta[0]), expression(beta[1])),
        ylim = c(0.8, 1.3))

