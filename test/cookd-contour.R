# Define a grid of points
x <- seq(-10, 10, length.out = 100)
y <- seq(-10, 10, length.out = 100)
# Create a matrix of z values
z <- outer(x, y, function(x, y) { sin(sqrt(x^2 + y^2)) })
# Plot the contour

#contour(x, y, z, main = "Basic Contour Plot", xlab = "X-axis", ylab = "Y-axis")

filled.contour(x, y, z, color.palette = terrain.colors,
               plot.title = title(main = "Filled Contour Plot", xlab = "X-axis", 
                                  ylab = "Y-axis"))


cook <- function(hat, e, p) {
  g <- hat / (1 - hat)
  g * e/(p+1)
}

p <- 2
hat <- seq(0.02, 0.30, 0.02)
resid <- seq(-2, 2, 0.10)
#cookd <- outer(hat, resid, cook(hat, resid, p))
cookd <- outer(hat, resid, function(hat, resid) {(hat/(1-hat)) * resid^2 / (p+1)})

col2rgb()
pal <- colorRampPalette(c("lightyellow", "darkorange"))
filled.contour(hat, resid, cookd, 
               color.palette = pal,
               xlab = "Hat value",
               ylab = "Studentized residual")

