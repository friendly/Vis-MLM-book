#' ---
#' title: Workers data - pca
#' ---
#' 

library(car)
library(spida2)
library(heplots)

load(here::here("data", "workers.RData"))
str(workers)

# covariance matrix & mean
S <- cov(workers[, 3:2])
mu <- colMeans(workers[, 3:2])
radius <- sqrt(2 * qf(0.68, 2, nrow(workers)-1 ))

op <- par(mar = c(4, 4, 0, 0) + 0.1)
dataEllipse(Income ~ Experience, data=workers,
            pch = 16, cex = 1.5, 
            center.pch = "+", center.cex = 2,
            cex.lab = 1.5,
            levels = 0.68,
            grid = FALSE,
            xlim = c(-10, 40),
            ylim = c(20, 80),
            asp = 1)
abline(h = mu[2], v = mu[1], lty = 2, col = "grey")
ellipse.axes(S, mu, 
             radius = radius,
             labels = TRUE,
             col = "red", lwd = 2)
par(op)

plot(Income ~ Experience, data=workers,
     pch = 16, cex = 2,
     asp = 1)


ell.lines <- dellplus(workers$Experience, workers$Income,
     radius = sqrt(qchisq(0.68, 2)),
     ellipse = FALSE,
     box=TRUE
    )
str(ell.lines)
lines(ell.lines)

S <- cov(workers[, 3:2])
mu <- colMeans(workers[, 3:2])

lines(ellplus(mu, S))

# show conjugate axes for PCA factorization
pca.fac <- function(x) {
  xx <- svd(x)
  ret <- t(xx$v) * sqrt(pmax( xx$d,0))
  ret
}

lines( ellplus(mu, shape = S, box=TRUE, diameters=TRUE, fac=pca.fac), col = 'red')

      