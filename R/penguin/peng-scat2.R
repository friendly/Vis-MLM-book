#' ---
#' title: Penguins data, scatterplot matrix & data ellipses
#' ---

library(dplyr)
library(ggplot2)
library(car)
#library(effects)
library(heplots)
library(candisc)

load(here::here("data", "peng.RData"))

# use ggplot colors
col <- scales::hue_pal()(3)
pch <- 15:17

# basic scatterplot
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
            legend=list(coords = "bottomright"), 
            col = col, cex = 0, cex.lab = 1.5
)




scatterplotMatrix(~ bill_length + bill_depth + flipper_length + body_mass | species,
                  data = peng, col = col, legend=FALSE,
                  ellipse = list(levels = 0.68),
                  smooth = FALSE)

scatterplotMatrix(~ bill_length + bill_depth + flipper_length + body_mass | species,
                  data = peng, col = col, legend=FALSE, cex.labels = 2.5,
                  ellipse = list(levels = 0.68),
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


