#' ---
#' title: crime data - biplot with supplementary variables
#' ---

library(ggplot2)
library(ggbiplot)
library(dplyr)
library(tidyr)
#library(corrplot)
library(patchwork)
library(broom)
library(FactoMineR)
library(factoextra)

data(crime, package = "ggbiplot")

supp_data <- state.x77 |>
  as.data.frame() |>
  tibble::rownames_to_column(var = "state") |>
  select(state, Income:`Life Exp`, `HS Grad`) |>
  rename(Life_Exp = `Life Exp`,
         HS_Grad = `HS Grad`)

crime_joined <-
dplyr::left_join(crime, supp_data, by = "state")


row.names(crime) <- crime$st
crime_pca <- PCA(crime[,2:8], scale.unit=TRUE, ncp=5)
plot(crime_pca)

# only need to reflect Dim 2 here ?
# No -- supplementary variables are not reflected

crime_pca <- ggbiplot::reflect(crime_pca, columns = 2)
#plot(crime_pca)
plot(crime_pca, choix = "var")



#dimdesc(crime_pca, axes = 1:2)

row.names(crime_joined) <- crime$st
crime_pca_supp <- PCA(crime_joined[,c(2:8, 11:14)], 
                      quanti.sup = 8:11,
                      scale.unit=TRUE, ncp=5, graph = TRUE)
#crime_pca_supp <- ggbiplot::reflect(crime_pca_supp, columns = 2)
plot(crime_pca_supp)
plot(crime_pca_supp, choix = "var")


# get variable information
var <- get_pca_var(crime_pca_supp)
var

names(crime_pca_supp)
# supplemental variables
crime_pca_supp$quanti.sup


p1 <- fviz_contrib(crime_pca, choice = "var", axes = 1,
                   fill = "lightgreen", color = "black")
p2 <- fviz_contrib(crime_pca, choice = "var", axes = 2,
                   fill = "lightgreen", color = "black")
p1 + p2


fviz_pca_biplot(crime_pca_supp)


#' # Add supplementary variables
coord <- data.frame(PC1 = c(-0.7, 0.9), PC2 = c(0.25, -0.07))
rownames(coord) <- c("Rank", "Points")
print(coord)
fviz_add(p, coord, color ="red", geom="arrow")




