#' ---
#' title: Variable ordering based on PCA & corrplot
#' ---

library(ggplot2)
library(ggbiplot)
library(dplyr)
library(corrplot)

data(mtcars)

mtcars.pca <- prcomp(mtcars, scale. = TRUE)
ggbiplot(mtcars.pca,
         circle = TRUE,
         point.size = 2.5,
         varname.size = 4,
         varname.color = "brown") +
  theme_minimal(base_size = 14) 

R <- cor(mtcars)

# show numerically
print(floor(100*R))

corrplot(R, 
         method = 'ellipse',
         title = "Dataset variable order",
         tl.srt = 0, tl.col = "black", tl.pos = 'd',
         mar = c(0,0,1,0))

corrplot(R, 
         method = 'ellipse', 
         order = "AOE",
         title = "PCA variable order",
         tl.srt = 0, tl.col = "black", tl.pos = 'd',
         mar = c(0,0,1,0)) |>
  corrRect(c(1, 6, 7, 11))

corrplot(R, method = 'ellipse', order = 'AOE', type = 'upper')


