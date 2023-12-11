#' ---
#' title: crime data - biplot with supplementary variables
#' ---

library(ggplot2)
library(ggbiplot)
library(dplyr)
library(tidyr)
library(corrplot)
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


crime_pca <- PCA(crime[,2:8], scale.unit=TRUE, ncp=5)
plot(crime_pca)

# reflect the axes?

crime_pca <- ggbiplot::reflect(crime_pca)
plot(crime_pca)


#dimdesc(crime_pca, axes = 1:2)

crime_pca_supp <- PCA(crime_joined[,c(2:8, 11:14)], 
                      quanti.sup = 8:11,
                      scale.unit=TRUE, ncp=5, graph = TRUE)
plot(crime_pca_supp)


# get variable information
var <- get_pca_var(crime_pca_supp)
var

var$cor




