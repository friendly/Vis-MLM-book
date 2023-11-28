#' ---
#' title: crime data - ggbiplot
#' ---

library(ggplot2)
library(ggbiplot)
library(dplyr)
library(corrplot)
library(patchwork)

data(crime)

crime |> 
  dplyr::select(where(is.numeric)) |> 
  cor() |> 
  corrplot(method = "ellipse", tl.srt = 0, tl.col = "black", mar = rep(.5, 4))

crime.pca <- 
  crime |> 
  dplyr::select(where(is.numeric)) |>
  prcomp(scale. = TRUE)

summary(crime,pca)

# show the eigenvalue decomposition
(crime.eig <- crime.pca |> 
  broom::tidy(matrix = "eigenvalues"))

# add fitted line for smallest eigenvalues
p1 <- ggscreeplot(crime.pca) +
  stat_smooth(data = crime.eig |> filter(PC>=4), 
              aes(x=PC, y=percent), method = "lm", 
              se = FALSE,
              fullrange = TRUE) +
  theme_bw(base_line_size = 14)

p2 <- ggscreeplot(crime.pca, type = "cev") +
  geom_hline(yintercept = c(0.8, 0.9), color = "blue") +
  theme_bw(base_size = 14)

p1 + p2



#biplot(crime.pca)

# reflect dims 1:2
# crime.pca$rotation[,1:2] <- -1 * crime.pca$rotation[,1:2]
# crime.pca$x[,1:2] <- -1 * crime.pca$x[,1:2]

crime.pca <- reflect(crime.pca)

biplot(crime.pca)


# default scaling: standardized components
ggbiplot(crime.pca,
         labels = crime$st ,
         circle = TRUE,
         varname.size = 4,
         varname.color = "red") +
  theme_minimal(base_size = 14) 

ggbiplot(crime.pca,
         obs.scale = 1, var.scale = 1,
         labels = crime$st ,
         circle = TRUE,
         varname.size = 4,
         varname.color = "red") +
  theme_minimal(base_size = 14) 

# regions as groups, with ellipses
ggbiplot(crime.pca,
         groups = crime$region,
         labels = crime$st,
         labels.size = 4,
         var.factor = 1.4,
         ellipse = TRUE, ellipse.level = 0.5, ellipse.alpha = 0.1,
         circle = TRUE,
         varname.size = 4,
         varname.color = "black") +
  labs(fill = "Region", color = "Region") +
  theme_minimal(base_size = 14) +
  theme(legend.direction = 'horizontal', legend.position = 'top')


