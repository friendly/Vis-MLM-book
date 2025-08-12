#' ---
#' title: demo ellipses of varying coverage
#' ---

# For: \S 3.2 Data ellipse

library(car)
library(heplots)

ybar <- c(0, 0)
S <- matrix(c(1, .5, .5, 2), 2, 2)
rownames(S) <- colnames(S) <- c("y1", "y2")
S

cov2cor(S)

levels <- c(0.50, 0.68, 0.95)
c <- qchisq(levels, df = 2) |> round(2) |> print()
# 
# labels <- expression(paste0("c =", chi^2, "(", levels, ") ==", c))
# labels <- bquote(paste("c =", chi^2, "(", .(levels), ") =", .(c)))

# lab <- c(
#   bquote(paste("c =", chi^2, "(", .(levels[1]), ") =", .(c[1]))),
#   bquote(paste("c =", chi^2, "(", .(levels[2]), ") =", .(c[2]))),
#   bquote(paste("c =", chi^2, "(", .(levels[3]), ") =", .(c[3])))
# )

lab1 <- bquote(paste("c =", chi[2]^2, "(", .(levels[1]), ") =", .(c[1])))
lab2 <- bquote(paste("c =", chi[2]^2, "(", .(levels[2]), ") =", .(c[2])))
lab3 <- bquote(paste("c =", chi[2]^2, "(", .(levels[3]), ") =", .(c[3])))

op <- par(mar = c(5, 5, 1, 1) + 0.1)
e1 <- ellipse(ybar, S, radius=qchisq(levels[1], 2), 
        col = "blue", fill=TRUE, fill.alpha = 0.5,
        add=FALSE, 
        xlim=c(-8, 8), ylim=c(-9.5, 9.5), 
        asp=1, grid = FALSE,
        xlab = expression(y[1]), 
        ylab = expression(y[2]),
        cex.lab = 1.5)
label.ellipse(e1, label = lab1, label.pos = "S",
              cex = 1.2)

e2 <- ellipse(ybar, S, radius=qchisq(levels[2], 2), 
        col="blue", fill=TRUE, fill.alpha=0.3)
label.ellipse(e2, label = lab2, label.pos = "N",
              cex = 1.2)

e3 <- ellipse(ybar, S, radius=qchisq(levels[3], 2), 
        col="blue", fill=TRUE, fill.alpha=0.1)
label.ellipse(e3, label = lab3, label.pos = "N",
              cex = 1.2)
par(op)