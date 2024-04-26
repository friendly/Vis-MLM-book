#' ---
#' title: Coffee data: demonstration of measurement error
#' ---

# demonstrate effect of measurement error via data ellipses with an attempt at animation

library(car)		     # for dataEllipse, confidenceEllipse
library(colorspace)
library(RColorBrewer)

data(coffee, package = "spida2")
coffee <- coffee[, -5]  # get old Stress2 example variable out of the way

#setwd("C:/Dropbox/Documents/publications/ellipses/R")
source("R/coffee/measerr.R")

set.seed(12345)  # reproducibility
err <- seq(.2, 1.6, by = .2)
cols <- colorspace::sequential_hcl(palette="Rocket", length(err)+3)

# errors in response
par(mar=c(4, 4, 1, 1) + 0.1)
stats <- measerr(coffee$Stress, coffee$Heart, 
                      err=err, 
                      add.to = "y",
                      cols=cols, 
                      xlim = c(-50, 250), ylim = c(0, 170),
                      xlab = "Stress", ylab = "Heart",
                      start_loop = print(paste("i =", i, "error = ", err[i])),
                      end_loop = readkey())



op <- par(mar=c(4, 4, 1, 1) + 0.1)
stats <- measerr(coffee$Stress, coffee$Heart, 
                      err=err, 
                      add.to = "x",
                      cols=cols, 
                      xlim = c(-50, 250), ylim = c(0, 170),
                      xlab = "Stress", ylab = "Heart",
                      end_loop = Sys.sleep(5))
par(op)

