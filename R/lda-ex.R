#' ---
#' title: LDA example
#' ---

# Original from: https://medium.com/@ccqxluo/linear-discriminant-analysis-lda-and-how-to-do-it-in-r-c977507a65df

library(MASS) # where the mvrnorm function is located
library(ggplot2)

# mean vectors
mean1 <- c(1, 2)
mean2 <- c(-2, -3)

# the common covariance matrix
covariance.mat <- matrix(c(1,  0.2, 
                           0.2, 1), nrow = 2)

# for reproducibility of results
set.seed(123) 

# generate data
group1 <- mvrnorm(100, mean1, covariance.mat)
group2 <- mvrnorm(100, mean2, covariance.mat)

# generate group
group <- c(rep("group1", 100), rep("group2", 100))

# stack the two samples on top of each other into a dataframe and rename the columns x and y
df <- data.frame(rbind(group1, group2))
colnames(df) <- c("x", "y")

# plot the dataset
ggplot(data = df, aes(x, y, col = group)) + 
  geom_point() + 
  stat_ellipse(level=0.95, lwd = 1.5)
  theme(legend.position="none") + 
  ggtitle('Data From Two Bivariate Normal Populations')

lda.classifier <- lda(formula = group ~ ., data = df)


# find out prediction of the the lda classifier on the test data
predictions <- predict(lda.classifier, df)
predicted.group <- predictions$class


# this counts how many of the test data is correctly classified
sum(predicted.group == c(rep("group1", 100), rep("group2", 100)))
# in fact, this classifier is correct on every prediction, which is not surprising
# as we can see from the plot that the data is well-separated

# generate a dense grid of points and classify each of those points.
# plot the color-coded results
x <- seq(from = -5, to = 4, by = 0.1)
y <- seq(from = -5, to = 5, by = 0.1)
grid <- expand.grid(x = x, y = y)
grid.predictions <- predict(lda.classifier, grid)$class

# plots the decision boundary; we also include the training data in darker colors
ggplot() + 
  geom_point(data = grid, aes(x, y, col = grid.predictions, alpha = 0.001)) + 
  geom_point(data = df, aes(x, y, col = group)) +
  guides(alpha = "none") 


