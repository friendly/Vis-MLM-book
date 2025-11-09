# Load the rpart package and others
library(rpart)
library(rpart.plot)
library(parttree)

# Load a sample dataset (e.g., iris dataset)
data(iris)

# Build a classification tree
# The formula specifies the target variable (Species) and the predictor variables (all others, indicated by .)
# The method = "class" argument specifies that it's a classification tree
iris.tree <- rpart(Species ~ ., data = iris, method = "class")

# Print the tree structure
print(iris.tree)

rpart.rules(iris.tree)

# Plot the tree (requires rpart.plot or partykit for more advanced visualizations)
# install.packages("rpart.plot") if you don't have it

library(rpart.plot)

iris.colors <- c(setosa = "red", versicolor = "darkgreen", virginica = "blue")
iris.colors <- colorspace::adjust_transparency(iris.colors, alpha = 0.3)

rpart.plot(iris.tree)

# Assign colors based on Species (predicted class)
# Assuming 'setosa', 'versicolor', 'virginica' are the classes
node_colors <- ifelse(iris.tree$frame$yval == 1, iris.colors[1], # Setosa
                      ifelse(iris.tree$frame$yval == 2, iris.colors[2], iris.colors[3])) # Versicolor, Virginica

rpart.plot(iris.tree, box.col = node_colors)

prp(iris.tree, extra = 1, box.col = node_colors)

# Make predictions on new data (e.g., the original data for demonstration)
predictions <- predict(iris.tree, newdata = iris, type = "class")

# Evaluate the model (e.g., confusion matrix)
confusion_matrix <- table(Actual = iris$Species, Predicted = predictions)
print(confusion_matrix)

#' ## Visualize in data space
#' 

ggplot(data = iris, aes(x = Petal.Length, y = Petal.Width, color = Species)) +
  geom_point() + # Plot the original data points
  geom_parttree(data = iris.tree, aes(fill = Species), alpha = 0.3) + # Add decision boundaries
  labs(title = "rpart Classification Tree in Data Space",
       x = "Petal Length", y = "Petal Width") +
  theme_minimal()

# try labeling means using `stat_means`
source("R/util/geom_means.R")

last_plot() + 
  stat_means(geom = "label", aes(label = Species), fontface = "bold") +
  theme(legend.position = "none")


