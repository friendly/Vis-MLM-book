#' ## using factoextra
#' 

library(FactoMineR)
library(factoextra)

# use verson with rownames
crime2 <- read.csv(here::here("data", "crime2.csv"), row.names = 1)

crime.pca <- crime2 |>
  select(where(is.numeric)) |>
  PCA(graph = FALSE)
  
fviz_pca_biplot(crime.pca, label = c("var", "id"), 
                habillage=crime$region,
                addEllipses=TRUE, ellipse.level=0.68,
                ggtheme = theme_minimal()) 

fviz_screeplot(crime.pca, addlabels = TRUE, barfill="lightblue")