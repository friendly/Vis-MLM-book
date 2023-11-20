#' ---
#' title: panel functions with pairs()
#' ---
#' 
# This example from: https://raw.githubusercontent.com/yihui/knitr-examples/master/056-huge-plot.Rmd

# generate some random data
dat = matrix(runif(100000), ncol=5)
dat[, 3] = -.2 * dat[, 1] + .8 * dat[, 2] # to make the plot less boring

# show naive pairs plot
pairs(dat)


# But scatter plots with such a large number of points are usually difficult to read (basically you can see nothing), so we'd better use some alternative ways to visualize them. For example, we can use 2D density estimates and draw contour plots, or just plot the LOWESS curve.

# define a panel function to plot contours
dens2d = function(x, y, ...) {
  res = MASS::kde2d(x, y)
  with(res, contour(x, y, z, add = TRUE))
}

pairs(dat, 
      lower.panel = dens2d, 
      upper.panel = function(x, y, ...) {lines(lowess(y ~ x), col = 'red')
})
