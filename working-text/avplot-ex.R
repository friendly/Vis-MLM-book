# notes on AVplots

# Added variable plots (also known as partial regression plots) are used in regression analysis to visualize the relationship between a predictor variable and the response variable, while accounting for the effects of other predictors in the model. They help in:
#   
# Assessing the marginal effect of a predictor
# Identifying non-linear relationships
# Detecting influential observations or outliers
# Checking for heteroscedasticity
# 
# How do influential observations show up in an added variable plot? Give an example
# 
# Influential observations in added variable plots typically appear as points that are far from the main cluster of data points and/or have a substantial impact on the regression line. These points can be identified by their position and their potential to change the slope of the fitted line if removed.
# Here's an example to illustrate how influential observations appear in an added variable plot:

# Load required libraries
library(car)
library(ggplot2)

# Create sample dataset with an influential observation
set.seed(123)
n <- 50
x1 <- rnorm(n)
x2 <- rnorm(n)
y <- 2 * x1 + 0.5 * x2 + rnorm(n)

# Add an influential observation
x1[n+1] <- 4
x2[n+1] <- 4
y[n+1] <- 15

data <- data.frame(y, x1, x2)

# Fit multiple linear regression model
model <- lm(y ~ x1 + x2, data = data)

# Create added variable plot for x1
avPlot(model, "x1", ellipse = TRUE)

# Create a custom added variable plot using ggplot2 for better visualization
av_data <- data.frame(
  x = resid(lm(x1 ~ x2, data = data)),
  y = resid(lm(y ~ x2, data = data)),
  hat <- hatvalues(model)
)

ggplot(av_data, aes(x, y)) +
  geom_point() +
  geom_smooth(method = "lm", se = FALSE) +
  labs(title = "Added Variable Plot for x1",
       x = "x1 | others",
       y = "y | others") +
  theme_minimal() +
  geom_point(data = av_data[51,], color = "red", size = 3)

influencePlot(model)

# In this example:
# 
# We create a dataset with 50 observations and add one influential point.
# We fit a multiple linear regression model.
# We create an added variable plot using the avPlot function from the car package.
# We also create a custom added variable plot using ggplot2 for better visualization.
# 
# The influential observation will appear as follows in the added variable plot:
# 
# Position: It will be located far from the main cluster of points, often in the upper right or lower left corner of the plot.
# Impact on regression line: The regression line (usually shown in blue) will be noticeably pulled towards this point.
# Leverage: The point will have high leverage, meaning it has an unusual value for the predictor variable (x1 in this case).
# Outlier in y-direction: The point may also be an outlier in terms of its y-value, deviating significantly from the pattern established by other points.
# 
# In the custom ggplot, the influential point is highlighted in red for easy identification.
# Influential points in added variable plots are important to identify because:
# 
# They can disproportionately affect the regression coefficients.
# They may indicate data entry errors or unusual cases that warrant further investigation.
# They can help in assessing the robustness of your regression model.
# 
# When you spot influential observations in an added variable plot, it's crucial to investigate why they exist and consider their impact on your analysis. 
# You might need to re-examine these data points, consider transformations, or use robust regression techniques depending on the nature of the influence and the goals of your analysis. 
# 
 
