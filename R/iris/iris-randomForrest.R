library(randomForest)

# Set a seed for reproducibility
set.seed(123)

# Build the random forest model
# Species ~ . means predict Species using all other variables
# ntree specifies the number of trees to grow (default is 500)
# importance = TRUE calculates variable importance
rf_model <- randomForest(Species ~ ., data = iris, ntree = 500, importance = TRUE)

print(rf_model)

plot(rf_model)

# Make predictions on the iris dataset
predictions <- predict(rf_model, newdata = iris)

# Compare predictions to actual values
confusion_matrix <- table(Actual = iris$Species, Predicted = predictions)
print(confusion_matrix)

# Get variable importance
importance_scores <- importance(rf_model)
print(importance_scores)

# Visualize variable importance
varImpPlot(rf_model)
