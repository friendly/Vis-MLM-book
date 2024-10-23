#' ---
#' title: Coffee data: demonstration of measurement error
#' ---

# demonstrate effect of measurement error via data ellipses with an attempt at annimation

# remotes::install_github('gmonette/spida2')
#library("spida2")    # for coffee data 
library(car)		     # for dataEllipse, confidenceEllipse
library(colorspace)
library(RColorBrewer)

# data(coffee, package="spida2")
# coffee <- coffee[, -5]  # get old Stress2 example variable out of the way
data(coffee, package="matlib")


# Add a N(0, SD) error, but keep the mean unchanged
add_error <- function(x, factor) {
  n <- length(x)
  mean <- mean(x)
  SD <- sd(x)
  x <- x + round(rnorm(n, sd=factor*SD))
  x <- mean + as.vector(scale(x, center=TRUE, scale=FALSE))
  x
}

err <- c(0, .75, 1, 1.5)   # good for data space
#err <- c(.25, .5, .75)  # still too much
#err <- c(.2, .4, .8)    # good for beta space

cols <- c("black", "blue", "red", "green3", "yellow3")
lev <- 0.68
set.seed(12345)  # reproducability
for (i in 1:length(err)) {
  coffee$StressX <- add_error(coffee$Stress, err[i])

  with(coffee, 
       E <- dataEllipse(StressX, Heart, level=lev, 
                        col=cols[i], 
                        xlim = c(-50, 250),
                        xlab = paste("Stress +", err[i], "error"),
                        add = if(i==1) FALSE else TRUE,
                        grid=FALSE, 
                        fill=TRUE, fill.alpha = 0.2,
                        center.cex=2, 
                        pch=16, 
                        cex.lab=1.5))
  fit <- lm(Heart ~ StressX, data=coffee)
  abline(fit, col=cols[i], lwd=3)
  abline(h=mean(coffee$Heart))
  Sys.sleep(4)
}

set.seed(12345)  # reproducability
for (i in 1:length(err)) {
  coffee$StressX <- add_error(coffee$Stress, err[i])
  
  with(coffee, 
       E <- dataEllipse(Stress, Heart, level=lev, 
                        col=cols[1], 
                        xlim = c(-50, 250),
                        xlab = paste("Stress + N (0,", err[i], "sd)"),
                        grid=FALSE, 
                        fill=TRUE, fill.alpha = 0.2,
                        center.cex=2, 
                        pch=16, 
                        cex.lab=1.5))
  if (i>1) {
    with(coffee, 
         E <- dataEllipse(StressX, Heart, level=lev, 
                          add = TRUE,
                          col=cols[i], cex=1.25,
                          grid=FALSE, 
                          fill=TRUE, fill.alpha = 0.2,
                          center.cex=2, 
                          pch=16, 
                          cex.lab=1.5))
    
  }
  fit <- lm(Heart ~ StressX, data=coffee)
  abline(fit, col=cols[i], lwd=3)
  abline(h=mean(coffee$Heart))
  with(coffee,
       segments(x0=Stress,  y0=Heart,
                x1=StressX, y1=Heart, col=cols[i], lty = 2))
  Sys.sleep(2)
}


#cols <- colorspace::hcl_palettes(palette="Rocket", n=length(err))

measerr_demo <- function(x, y, 
                         err,
                         cols,
                         lev=0.68,
                         pch = 16,
                         cex = 1.2,
                         xlim, ylim,
                         xlab, ylab) {
  if(missing(xlim)) {
    rx <- range(x)
    xlim <-c(rx[1] - .2 * diff(rx), 
             rx[2] + .2 * diff(rx))
  }
  if(missing(ylim)) {
    ry <- range(y)
    ylim <-c(ry[1] - .2 * diff(ry), 
             ry[2] + .2 * diff(ry))
  }
  if(missing(xlab)) xlab <- deparse(substitute(x))
  if(missing(ylab)) ylab <- deparse(substitute(y))
  
  for(i in 1:length(err)) {
    E1 <- dataEllipse(x, y, 
                     col = "black",
                     lev = lev,
                     grid=FALSE, 
                     xlim = xlim, ylim = ylim,
                     xlab = xlab, ylab = ylab,
                     fill = TRUE, fill.alpha = 0.2, 
                     cex.lab = 1.4, 
                     pch = pch, cex = cex
                     )
    abline(lm(y ~ x), col="black", lwd=3)

    xx <- add_error(x, err[i])
    E2 <- dataEllipse(xx, y, 
                      col = cols[i],
                      lev = lev,
                      grid=FALSE, 
                      add = TRUE,
                      fill = TRUE, fill.alpha = 0.2,
                      pch = pch, cex = cex
    )
    abline(fit <- lm(y ~ xx), col=cols[i], lwd=3)
    segments(x0=x,  y0=y,
             x1=xx, y1=y, lty=2, col=cols[i])
    text(x = xlim[2] - .05*diff(xlim), 
         y = min(y) + .05 * diff(range(y)), 
         label = paste("Error factor:", err[i], "\nSlope:", round(coef(fit)[2], 2)), 
         pos=2, cex=1.2)
    Sys.sleep(1)
  }
}

source("R/coffee/measerr.R")
set.seed(12345)  # reproducibility
err <- seq(.2, 1.6, by = .2)
pal <- colorRampPalette(c("purple", "green"))
cols <- pal(length(err))
cols <- colorspace::sequential_hcl(palette="Rocket", length(err)+3)

op <- par(mar=c(4, 4, 1, 1) + 0.1)
stats <- measerr(coffee$Stress, coffee$Heart, 
             err=err, cols=cols, 
             xlim = c(-50, 250), ylim = c(0, 170),
             xlab = "Stress", ylab = "Heart")
par(op)

plot(slope ~ intercept, data = stats, pch = 16, cex=1.4, type = "b")
with(stats, text(intercept, slope, label=row.names(stats), pos=4))

library(animation)

oopt = ani.options(interval = 1)
op <- par(mar=c(4, 4, 1, 1) + 0.1)
saveGIF(measerr(coffee$Stress, coffee$Heart, 
                 err=err, cols=cols, 
                 xlim = c(-50, 250), ylim = c(0, 170),
                 xlab = "Stress", ylab = "Heart",
                 end_loop = ani.pause()),
          movie.name = "coffee-measerr-data.gif")
#          interval = 0.1, width = 580, height = 400)
par(op)
ani.options(oopt)

