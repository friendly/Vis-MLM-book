data(iris)
library(heplots)
library(dplyr)
library(tidyr)

leveneTests(iris[,1:4], iris[, "Species"])

# Multivariate levene test
irisDevs <- abs(colDevs(iris[, 1:4], iris[, "Species"], median))
dev.mod <- lm(irisDevs ~ iris$Species)
Anova(dev.mod)

# boxplots
iris_long <- iris |>
  pivot_longer(Sepal.Length:Petal.Width, 
               names_to = "variable", 
               values_to = "value") 
iris_long |>
  ggplot(aes(value, Species, fill = Species)) +
  geom_boxplot() +
  facet_wrap(~ variable, scales = 'free_x') +
  theme_bw(base_size = 14) +
  theme(legend.position = 'none') 

# box plots of deviations
dev_long <- data.frame(Species = iris$Species, irisDevs) |> 
  pivot_longer(Sepal.Length:Petal.Width, 
               names_to = "variable", 
               values_to = "value") 

dev_long |>
  group_by(Species) |> 
  ggplot(aes(value, Species, fill = Species)) +
  #  geom_vline(xintercept = 0, color = "red") +
  geom_boxplot() +
  facet_wrap(~ variable, scales = 'free_x') +
  xlab("| median deviation |") +
  theme_bw(base_size = 14) +
  theme(legend.position = 'none') 

