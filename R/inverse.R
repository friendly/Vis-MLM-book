#' ---
#' title: ellipses and inverses
#' ---
#' 
# demonstrate orthogonality of ellipses for S and S^{-1}

m <- c(0,0)
S <- matrix(c(1, .5, .5, 1), 2, 2)
S2 <- 2*S
Sinv <- solve(S)
Sinv2 <- solve(S2)


png(file="images/inverse.png", width=7, height=7, res=200, units="in")

op <- par(mar=c(3, 3, 1, 1) + 0.1)
# draw ellipses for 
E11 <- ellipse(m, S, radius=1, asp=1, add=FALSE,
               xlim=c(-2,2), ylim=c(-2,2), 
               col = "blue",
               fill=TRUE, fill.alpha = 0.25)
E12 <- ellipse(m, S2, radius=1, 
               col = "blue",
               fill=TRUE, fill.alpha=0.1)
heplots::label.ellipse(E11, "S", "blue", cex=1.3)
heplots::label.ellipse(E12, "2S", "blue", cex=1.5)

r <- 1.4
lines(matrix(c(-r, r, -r, r), 2, 2), col="black", lwd = 2, lty = 2)
lines(matrix(c(-r, r, r, -r), 2, 2), col="black", lwd = 2, lty = 2)

E21 <- ellipse(m, Sinv, radius=1, col="red", 
               fill = TRUE, fill.alpha = 0.25)
E22 <- ellipse(m, Sinv2, radius=1, col="red", 
               fill=TRUE, fill.alpha=0.1)


heplots::label.ellipse(E21, expression(S^-1), "red", cex=1.5, 
                       label.pos = "top")
heplots::label.ellipse(E22, expression((2 * S)^-1), "red", cex=1.3, 
                       label.pos = "top")
par(op)

dev.off()

