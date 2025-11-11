# partreee - partition tree package
#http://grantmcdermott.com/parttree/

install.packages("partree")
library(parttree)  # This package
library(rpart)     # For fitting decisions trees
library(rpart.plot)

# install.packages("palmerpenguins")
# data("penguins", package = "palmerpenguins")
data(peng, package = "heplots")

tree = rpart(species ~ flipper_length + bill_length + bill_depth + body_mass, data = peng)
tree

plot(tree)

ptree = parttree(tree)
plot(ptree)

plot(ptree, pch = 16, palette = "classic", alpha = 0.75, grid = TRUE)

# Continuous predictions
#In addition to discrete classification problems, parttree also supports regression trees with continuous independent variables.

tree_cont = rpart(body_mass ~ flipper_length + bill_length, data = peng)

tree_cont |>
  parttree() |>
  plot(pch = 16, palette = "viridis")
  
# Alongside the rpart model objects that we have been working with thus far, parttree also supports decision trees created by the partykit package. 
#Here we see how the latter?s ctree (conditional inference tree) algorithm yields a slightly more sophisticated partitioning that the former?s default.

library(partykit)
ctree(species ~ flipper_length + bill_length, data = peng) |>
  parttree() |>
  plot(pch = 16, palette = "classic", alpha = 0.5)


# Try classification tree

# Build the classification tree model
tree_model <- rpart(species ~ bill_length + bill_depth + flipper_length + body_mass, # + island + sex,
                    data = peng,
                    method = "class")
tree_model

# Plot the decision tree
rpart.plot(tree_model,
           main = "Classification Tree for Penguin Species",
           type = 2,  # type 2 plots the split labels in the branches
           extra = 101, # extra 101 adds the percentage of observations and the predicted class
           fallen.leaves = TRUE, # aligns the leaf nodes at the bottom
           box.palette = "BuGn", # adds color
           branch.lty = 3, # makes branch lines dotted
           shadow.col = "gray", # adds shadow to boxes
           cex = 0.8) # adjusts text size

tree_2d <- rpart(species ~ flipper_length + bill_length,
                 data = peng,
                 method = "class")

ggplot(data = peng, aes(x = flipper_length, y = bill_length, color = species)) +
  geom_point() +
  geom_parttree(data = tree_2d, aes(fill = species), alpha = 0.2) +
  labs(title = "Decision Tree Partitions Overlayed on Penguin Data")


