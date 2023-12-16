#' ## using factoextra
#' 

library(FactoMineR)
library(factoextra)
library(dplyr)

# use verson with rownames
crime2 <- read.csv(here::here("data", "crime2.csv"), row.names = 1)

crime.pca <- crime2 |>
  select(where(is.numeric)) |>
  PCA(graph = FALSE)
  
fviz_pca_biplot(crime.pca, label = c("var", "id"), 
                habillage=crime2$region,
                addEllipses=TRUE, ellipse.level=0.68,
                ggtheme = theme_minimal()) 

fviz_screeplot(crime.pca, addlabels = TRUE, barfill="lightblue")


data(iris)
res.pca <- prcomp(iris[, -5],  scale = TRUE)
fviz_pca_ind(res.pca, label="none", habillage=iris$Species,
             addEllipses=TRUE, ellipse.level=0.95, palette = "Dark2")

# Biplot of individuals and variables
# ++++++++++++++++++++++++++
# Keep only the labels for variables
# Change the color by groups, add ellipses
fviz_pca_biplot(res.pca, label = "var", 
                habillage=iris$Species,
                addEllipses=TRUE, ellipse.level=0.95,
                ggtheme = theme_minimal())
last_plot() +
  theme(legend.position = "bottom")

