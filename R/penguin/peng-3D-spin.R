# from: https://r-graph-gallery.com/3-r-animated-cube.html
library( rgl )
library(magick)

# Let's use the penguin dataset
data(peng, package = "heplots")
source(here::here("R", "penguin", "penguin-colors.R"))

colors <-peng.colors("dark")
peng$color <- colors[ as.numeric( as.factor(peng$species) ) ]

# Static chart
plot3d( peng[,"bill_length"], iris[,"bill_depth"], iris[,"body_mass"],
        xlab = "Bill length",
        ylab = "Bill depth",
        zlab = "body_mass",
        col = iris$color, type = "s", radius = .1 )

# manipulate the plot, then save desired static view for reproducibility
zoom<-par3d()$zoom
userMatrix<-par3d()$userMatrix
windowRect<-par3d()$windowRect
