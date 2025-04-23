# iris data -- length vs width

library(tidyr)
library(car)
data(iris)

irisLW <- iris %>%
  pivot_longer(cols = -Species, names_sep = "\\.", names_to = c("Part", ".value")) |>
  mutate(Part = factor(Part))

# A tibble: 300 x 4
# Species Part  Length Width
# <fct>   <chr>  <dbl> <dbl>
#   1 setosa  Sepal    5.1   3.5
# 2 setosa  Petal    1.4   0.2
# 3 setosa  Sepal    4.9   3  
# 4 setosa  Petal    1.4   0.2

dataEllipse(Length ~ Width | Species, data=irisLW,
            levels = 0.68)

dataEllipse(Length ~ Width | Part, data=irisLW,
            levels = 0.68)

