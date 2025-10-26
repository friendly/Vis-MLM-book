# LDA, QDA & MDA example
# from: https://github.com/ramhiser/tech-reports/blob/master/mixture-discrim-analysis/mixture-discriminant-analysis.Rnw
# 
library(MASS)
library(mvtnorm)
library(mda)
library(ggplot2)

set.seed(42)
n <- 500

# Randomly sample data
x11 <- rmvnorm(n = n, mean = c(-4, -4))
x12 <- rmvnorm(n = n, mean = c(0, 4))
x13 <- rmvnorm(n = n, mean = c(4, -4))

x21 <- rmvnorm(n = n, mean = c(-4, 4))
x22 <- rmvnorm(n = n, mean = c(4, 4))
x23 <- rmvnorm(n = n, mean = c(0, 0))

x31 <- rmvnorm(n = n, mean = c(-4, 0))
x32 <- rmvnorm(n = n, mean = c(0, -4))
x33 <- rmvnorm(n = n, mean = c(4, 0))

x <- rbind(x11, x12, x13, x21, x22, x23, x31, x32, x33)
train_data <- data.frame(x, group = gl(3, 3 * n))

# Trains classifiers
lda_out <- lda(group ~ ., data = train_data)
qda_out <- qda(group ~ ., data = train_data)
mda_out <- mda(group ~ ., data = train_data)

# Generates test data that will be used to generate the decision boundaries via
# contours
contour_data <- expand.grid(X1 = seq(-8, 8, length = 300),
                            X2 = seq(-8, 8, length = 300))

# Classifies the test data
lda_predict <- data.frame(contour_data,
                          group = as.numeric(predict(lda_out, contour_data)$class))
qda_predict <- data.frame(contour_data,
                          group = as.numeric(predict(qda_out, contour_data)$class))
mda_predict <- data.frame(contour_data,
                          group = as.numeric(predict(mda_out, contour_data)))

# predict method for mda uses type = class, variates, posterior
mda_class <- predict(mda_out, contour_data, type = "class")
mda_scores <- predict(mda_out, contour_data, type = "variates")


p <- ggplot(train_data, aes(x = X1, y = X2, color = group)) + geom_point()

p + stat_contour(aes(x = X1, y = X2, z = group), data = lda_predict) + 
  ggtitle("LDA Decision Boundaries")

p + stat_contour(aes(x = X1, y = X2, z = group), data = qda_predict) + 
  ggtitle("QDA Decision Boundaries")

p + stat_contour(aes(x = X1, y = X2, z = group), data = mda_predict) + 
  ggtitle("MDA Decision Boundaries")

