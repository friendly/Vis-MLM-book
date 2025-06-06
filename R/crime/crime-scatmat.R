library(dplyr)
library(ggplot2)
library(car)

data(crime, package="ggbiplot")


# scatterplotMatrix(crime[, 2:8],
#     ellipse = list(levels = 0.68, fill=FALSE),
# #    regLine = list(lwd=3),
# #    diagonal = list(method = "boxplot"),
#     smooth = FALSE,
#     plot.points = FALSE)

crime |>
  select(where(is.numeric)) |>
  scatterplotMatrix(
    plot.points = FALSE,
    ellipse = list(levels = 0.68, fill=FALSE),
    smooth = list(spread = FALSE, 
                  lwd.smooth=2, lty.smooth = 1, col.smooth = "red"),
    cex.labels = 2)

# suppress axis tick marks & labels
crime |>
  select(where(is.numeric)) |>
  scatterplotMatrix(
    plot.points = FALSE,
    ellipse = list(levels = 0.68, fill=FALSE),
    smooth = list(spread = FALSE, 
                  lwd.smooth=2, lty.smooth = 1, col.smooth = "red"),
    cex.labels = 2,
    xaxt = "n", yaxt = "n")

