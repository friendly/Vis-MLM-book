library(corrplot)
library(corrgram)
library(dplyr)

# vignette: https://cran.r-project.org/web/packages/corrplot/vignettes/corrplot-intro.html

data("mtcars")
M <- cor(mtcars)

M |>
  corrplot.mixed(
    order = "original",
    lower = "ellipse",
    upper = "pie",
    tl.col = "black",
    title = "Dataset variable order"
  )
    
M |>
  corrplot.mixed(
    order = "AOE",
    lower = "ellipse",
    upper = "pie",
    tl.col = "black",
    title = "PCA variable order",
    mar = c(0,0,2,0)
  )

corrplot.mixed(M, lower = 'shade', upper = 'pie', order = 'hclust')
