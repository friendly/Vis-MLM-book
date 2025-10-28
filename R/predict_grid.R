# generalize discriminant prediction over a grid of (x,y) value
# 
library(marginaleffects)
data(peng, package = "heplots")
source(here::here("R/penguin/penguin-colors.R"))
source(here::here("R/predict_discrim.R"))


seq.range <- function(ngrid = 80, expand = 0.01) {
  function(x) {
    limits <- scales::expand_range(min(x), max(x), mul = expand)
    seq(from = limits[1], to = limits[2], length.out = ngrid)
  }
}


grid <- datagrid(bill_length = seq.range(20), 
                 bill_depth = seq.range(20), newdata = peng)

predict_grid <- function(object, 
                         x, y, 
                         data, 
                         ngrid = 80, 
                         expand = 0.1,
                         ...) {
  x <- substitute(x)
  y <- substitute(y)
  grid <- marginaleffects::datagrid(x = seq.range(ngrid),
                                    y = seq.range(ngrid),
                                    newdata = data)
  predict_discrim(object, newdata = grid, ...)
}

# test
peng.lda <- lda(species ~ bill_length + bill_depth + flipper_length + body_mass, 
                data = peng)

pred1 <- predict_grid(peng.lda, 
                      bill_length, bill_depth,
                      data = peng)

