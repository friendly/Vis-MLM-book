library(cassowaryr)
library(dplyr)

data("datasaurus_dozen", package = "datasauRus")
datasaurus_dozen |>
  group_by(dataset) |>
  summarise(calc_scags(x, y, 
                       scags=c("clumpy2", "monotonic", "convex", "stringy")))
