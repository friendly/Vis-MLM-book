# Iris: EDA plots

library(ggplot2)
library(dplyr)
library(tidyr)
library(patchwork)

iris.colors <- c("red", "darkgreen", "blue")
iris_long <- iris |> 
  pivot_longer(Sepal.Length:Petal.Width, 
               names_to = "variable", 
               values_to = "value") 

iris_long |>
  group_by(Species) |> 
  ggplot(aes(value, Species, fill = Species)) +
  geom_violin(alpha = 0.5, draw_quantiles = c(.25, .5, .75), width=1.3) +
  facet_wrap(~ variable, scales = 'free_x') +
  theme_bw(base_size = 14) +
  theme(legend.position = 'none') 

# flip coords
iris_long |>
  group_by(Species) |> 
  ggplot(aes(y = value, x = Species, fill = Species)) +
  geom_violin(alpha = 0.5, draw_quantiles = 0.5, width=1.2) +
  facet_wrap(~ variable) +
  theme_bw(base_size = 16) +
  theme(legend.position = 'none') +
  labs(y = "Iris value (cm.)")

last_plot() + geom_boxplot(width = .5)


# from: https://www.rpubs.com/naokoktm/iris
# histograms
h1 <- data1 %>% 
  ggplot(aes(Sepal.Length))+
  geom_histogram(aes(fill = Species), binwidth =0.2, col = "black")+
  geom_vline(aes(xintercept = mean(Sepal.Length)), linetype = "dashed", color = "black")+
  labs(x = "Sepal Length (cm)", y = "Frequency")+
  theme(legend.position = "none")

h2 <- data1 %>% 
  ggplot(aes(Sepal.Width))+
  geom_histogram(aes(fill = Species), binwidth =0.2, col = "black")+
  geom_vline(aes(xintercept = mean(Sepal.Width)), linetype = "dashed", color = "black")+
  labs(x = "Sepal.Width (cm)", y = "Frequency")+
  theme(legend.position = "none")

h3 <- data1 %>% 
  ggplot(aes(Petal.Length))+
  geom_histogram(aes(fill = Species), binwidth =0.2, col = "black")+
  geom_vline(aes(xintercept = mean(Petal.Length)), linetype = "dashed", color = "black")+
  labs(x = "Petal.Length (cm)", y = "Frequency")+
  theme(legend.position = "none")

h4 <- data1 %>% 
  ggplot(aes(Petal.Width))+
  geom_histogram(aes(fill = Species), binwidth =0.2, col = "black")+
  geom_vline(aes(xintercept = mean(Petal.Width)), linetype = "dashed", color = "black")+
  labs(x = "Petal.Width (cm)", y = "Frequency")+
  theme(legend.position = "right")

#grid.arrange(h1,h2,h3,h4, nrow=2, top = textGrob("Iris Histogram"))
h1 + h2 + h3 + h4

v1 <- data1 %>% 
  ggplot(aes(Species, Sepal.Length))+
  geom_violin(aes(fill = Species))+
  geom_boxplot(width = 0.1)+
  scale_y_continuous("Sepal Length", breaks = seq(0, 10, by = .5))+
  theme(legend.position = "none")

v2 <- data1 %>% 
  ggplot(aes(Species, Sepal.Width))+
  geom_violin(aes(fill = Species))+
  geom_boxplot(width = 0.1)+
  scale_y_continuous("Sepal Width", breaks = seq(0, 10, by = .5))+
  theme(legend.position = "none")

v3 <- data1 %>% 
  ggplot(aes(Species, Petal.Length))+
  geom_violin(aes(fill = Species))+
  geom_boxplot(width = 0.1)+
  scale_y_continuous("Petal Length", breaks = seq(0, 10, by = .5))+
  theme(legend.position = "none")

v4 <- data1 %>% 
  ggplot(aes(Species, Petal.Width))+
  geom_violin(aes(fill = Species))+
  geom_boxplot(width = 0.1)+
  scale_y_continuous("Petal Width", breaks = seq(0, 10, by = .5))+
  theme(legend.position = "right")

grid.arrange(v1,v2,v3,v4, nrow = 2, top = textGrob("Box plot of Iris species"))

