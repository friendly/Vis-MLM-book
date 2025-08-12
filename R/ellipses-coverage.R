#' ---
#' title: demo ellipses of varying coverage
#' ---

# For: section 11.2, HE plot construction

library(car)
library(heplots)

m1 <- c(0, 0)
A1 <- matrix(c(1, .5, .5, 2), 2, 2)

levels <- c(0.50, 0.68, 0.90)
c <- qchisq(levels, df = 2) |> round(2)
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


e1 <- ellipse(m1, A1, radius=qchisq(levels[1], 2), 
        col = "blue", fill=TRUE, fill.alpha = 0.5,
        add=FALSE, 
        xlim=c(-6, 6), ylim=c(-6, 6), 
        asp=1, grid = FALSE)
label.ellipse(e1, label = lab1, label.pos = 0.2)

e2 <- ellipse(m1, A1, radius=qchisq(levels[2], 2), 
        col="blue", fill=TRUE, fill.alpha=0.3)
label.ellipse(e2, label = lab2, label.pos = 0.15)


e3 <- ellipse(m1, A1, radius=qchisq(levels[3], 2), 
        col="blue", fill=TRUE, fill.alpha=0.1)
label.ellipse(e3, label = lab3, label.pos = 0.15)
