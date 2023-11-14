library(dplyr)
library(ggplot2)
library(car)

load(here("data", "crime.RData"))


scatterplotMatrix(crime[, 2:8],
    ellipse = list(levels = 0.68),
#    regLine = list(lwd=3),
#    diagonal = list(method = "boxplot"),
    smooth = FALSE,
    plot.points = FALSE)
