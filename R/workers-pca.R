#' ---
#' title: Workers data - pca
#' ---
#' 

library(car)
#library(spida2)  # note: labs() conflicts with ggplot2
library(heplots)
library(matlib)

#load(here::here("data", "workers.RData"))
#data(workers, package = "matlib")    # doesn't have Name variable
str(workers)

vars <- c("Experience", "Income")
plot(workers[, vars],
     pch = 16, cex = 1.5,
     cex.lab = 1.5)
text(workers[, vars], 
     labels = workers$Name,
     col = ifelse(workers$Gender == "Female", "red", "blue"),
     pos = 3, xpd = TRUE)

workers.pca <- prcomp(workers[, vars]) |> print()    

# standardized (scaled) solution
prcomp(workers[, vars], scale = TRUE)

# covariance matrix & mean
mu <- colMeans(workers[, vars]) |> print()
S <- cov(workers[, vars]) |> print()

# eigenvalues and eigenvectors
S.eig <- eigen(S)
Lambda <- S.eig$values |> print()
V <- S.eig$vectors |> print()

#total variances of the variables = sum of eigenvalues
sum(diag(S))
sum(Lambda)

# proportion of variance of each PC
100 * Lambda / sum(Lambda)

# calculate principal components
as.matrix(workers[, vars]) %*% V

# prcomp() returns these as `x`, but centered
as.matrix(workers[, vars]) %*% V |> scale(center = TRUE, scale = FALSE)
workers.pca$x

op <- options(digits = 5)
rownames(S) <- colnames(S) <- c("Exp", "Inc")
Eqn("\\mathbf{S} & = \\mathbf{V} \\phantom{00000000000000} 
     \\mathbf{\\Lambda} \\phantom{00000000000000}  
     \\mathbf{V}^\\top", Eqn_newline(),
    latexMatrix(S), "& =", 
    latexMatrix(V), "  ", diag(Lambda), "  ", latexMatrix(V, transpose=TRUE),
    align = TRUE)
options(op)

radius <- sqrt(2 * qf(0.68, 2, nrow(workers)-1 ))

# calculate conjugate axes for PCA factorization
# 'conjugate axis: The line passing through the center of the ellipse and perpendicular to the major axis
pca.fac <- function(x) {
  xx <- svd(x)
  ret <- t(xx$v) * sqrt(pmax( xx$d,0))
  ret
}


op <- par(mar = c(4, 4, 0, 0) + 0.1)
dataEllipse(Income ~ Experience, data=workers,
            pch = 16, cex = 1.5, 
            center.pch = "+", center.cex = 2,
            cex.lab = 1.5,
            levels = 0.68,
            grid = FALSE,
            xlim = c(-10, 40),
            ylim = c(10, 80),
            asp = 1)
abline(h = mu[2], v = mu[1], lty = 2, col = "grey")
ellipse.axes(S, mu, 
             radius = radius,
             labels = TRUE,
             col = "red", lwd = 2,
#             label.ends = c(2, 3),
             cex = 1.8)
lines(spida2::ellplus(mu, S, radius = radius,
              box = TRUE, fac = pca.fac),
      col = "darkgreen",
      lwd = 2, lty="longdash")
par(op)

op <- par(mar = c(4, 4, 0, 0) + 0.1)
plot(Income ~ Experience, data=workers,
     pch = 16, cex = 2,
     xlim = c(-10, 40),
     ylim = c(20, 80),
     asp = 1)


ell.lines <- spida2::dellplus(workers$Experience, workers$Income,
     radius = sqrt(qchisq(0.68, 2)),
     ellipse = FALSE,
     box=TRUE
    )
str(ell.lines)
#lines(ell.lines)

S <- cov(workers[, 3:2])
mu <- colMeans(workers[, 3:2])

lines(spida2::ellplus(mu, S, 
              radius = sqrt(qchisq(0.68, 2))
      ))
par(op)


lines(spida2::ellplus(mu, shape = S,
               radius = radius,  #sqrt(qchisq(0.68, 2)),
               box=TRUE, diameters=TRUE, fac=pca.fac), col = 'red')


     
