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
expand.grid(x1 = vals, x2=vals, x3=vals)


# project on just x1, x2 plane

P1 <- rbind(diag(2), c(0,0))
Y1 <- X %*% P1

P2 <- matrix(c(0.71, 0.71, 0, -0.42, .42, 0.84), ncol=2)
Y2 <- X %*% P2

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
