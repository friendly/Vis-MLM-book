#' ---
#' title: Penguins data, scatterplot matrix & data ellipses

library(dplyr)
library(ggplot2)
library(car)
library(effects)
library(heplots)
library(candisc)

#load(here::here("data", "peng.RData"))
data(peng, package = "heplots")
source("R/penguin/penguin-colors.R")

# use ggplot colors
#col <- scales::hue_pal()(3)
pch <- 15:17

col <- peng.colors("medium")
# basic scatterplot
op <- par(mar = c(5, 4, 0, 0) + .1)
scatterplot(bill_length ~ body_mass | species, data=peng,
            smooth=FALSE, regLine=FALSE, 
            grid=FALSE,
            legend=list(coords = "bottomright"), 
            col = col, pch = pch, cex.lab = 1.5
)	

# add annotations
scatterplot(bill_length ~ body_mass | species, data=peng,
            smooth=FALSE, regLine=TRUE, 
            ellipse=list(levels=0.68), 
            grid=FALSE,
            legend=list(coords = "bottomright"), 
            col = col, pch = pch, cex.lab = 1.5
)

# remove points
scatterplot(bill_length ~ body_mass | species, data=peng,
            smooth=FALSE, regLine=TRUE, 
            ellipse=list(levels=0.68), 
            grid=FALSE, 
            legend=list(coords = "bottomright"), pch=pch,
            col = col, cex = 0, cex.lab = 1.5
)
par(op)




scatterplotMatrix(~ bill_length + bill_depth + flipper_length + body_mass | species,
  data = peng, col = col, legend=FALSE,
  ellipse = list(levels = 0.68),
  smooth = FALSE)

# Fig 2.23
scatterplotMatrix(~ bill_length + bill_depth + flipper_length + body_mass | species,
  data = peng, 
  col = peng.colors("medium"), 
  legend=FALSE,
  ellipse = list(levels = c(0.68, 0.95), 
                 fill.alpha = 0.1),
  regLine = list(lwd=3),
  diagonal = list(method = "boxplot"),
  smooth = FALSE,
  plot.points = FALSE)

covEllipses(peng[3:6], peng$species, 
            variables=1:4, 
            col = col,
            fill=c(rep(FALSE,3), TRUE), 
            fill.alpha=.1)

covEllipses(peng[3:6], peng$species, 
            variables=1:4, pooled=FALSE,
            col = col,
            fill=TRUE, 
            fill.alpha=.1)
