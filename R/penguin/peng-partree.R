# partreee - partition tree package
# http://grantmcdermott.com/parttree/

install.packages("partree")
library(parttree)  # This package
library(rpart)     # For fitting decisions trees

# install.packages("palmerpenguins")
# data("penguins", package = "palmerpenguins")
data(peng, package = "heplots")

tree = rpart(species ~ flipper_length + bill_length + bill_depth + body_mass, data = peng)
tree

ptree = parttree(tree)
plot(ptree)

plot(ptree, pch = 16, palette = "classic", alpha = 0.75, grid = TRUE)

# Continuous predictions
#In addition to discrete classification problems, parttree also supports regression trees with continuous independent variables.

tree_cont = rpart(body_mass_g ~ flipper_length_mm + bill_length_mm, data = penguins)

tree_cont |>
  parttree() |>
  plot(pch = 16, palette = "viridis")
  
# Alongside the rpart model objects that we have been working with thus far, parttree also supports decision trees created by the partykit package. 
#Here we see how the latter?s ctree (conditional inference tree) algorithm yields a slightly more sophisticated partitioning that the former?s default.

library(partykit)
ctree(species ~ flipper_length_mm + bill_length_mm, data = penguins) |>
  parttree() |>
  plot(pch = 16, palette = "classic", alpha = 0.5)
 