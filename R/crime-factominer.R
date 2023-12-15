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

# Using FactoExtra
row.names(crime) <- crime$st
crime.PCA <- PCA(crime[,2:8], scale.unit=TRUE, ncp=5)

# reflect Dim 2
crime.PCA <- ggbiplot::reflect(crime.PCA, columns = 2)
#plot(crime.PCA)
plot(crime.PCA, choix = "var")

# Supplementary data
supp_data <- state.x77 |>
  as.data.frame() |>
  tibble::rownames_to_column(var = "state") |>
  select(state, Income:`Life Exp`, `HS Grad`) |>
  rename(Life_Exp = `Life Exp`,
         HS_Grad = `HS Grad`)

crime_joined <-
  dplyr::left_join(crime[, 1:8], supp_data, by = "state")
names(crime_joined)

row.names(crime_joined) <- crime$st
crime.PCA_sup <- PCA(crime_joined[,c(2:8, 9:12)], 
                     quanti.sup = 8:11,
                     scale.unit=TRUE, 
                     ncp=3, 
                     graph = FALSE)

# do this to avoid indexing columns?
# row.names(crime_joined) <- crime$st
# crime.PCA_sup <- crime_joined |>
#   select(-state) |> PCA(quanti.sup = 8:11,
#                         scale.unit=TRUE, 
#                         ncp=3, 
#                         graph = FALSE)
  

# reflect Dim 2
crime.PCA_sup <- ggbiplot::reflect(crime.PCA_sup, columns = 2)
crime.PCA_sup$quanti.sup$coord[, 2] <- -1 * crime.PCA_sup$quanti.sup$coord[, 2]

#plot(crime.PCA_sup)
plot(crime.PCA_sup, choix = "var")

# do the same plot with factoextra::fviz_pca

# get variable information
var <- get_pca_var(crime.PCA_sup)
var

names(crime.PCA_sup)
# supplemental variables
crime.PCA_sup$quanti.sup

fviz_pca_biplot(crime.PCA_sup)


#' # Add supplementary variables
coord <- data.frame(PC1 = c(-0.7, 0.9), PC2 = c(0.25, -0.07))
rownames(coord) <- c("Rank", "Points")
print(coord)
fviz_add(p, coord, color ="red", geom="arrow")

p <- fviz_pca_var(crime.PCA)
p
coord <- crime.PCA_sup$quanti.sup$coord
fviz_add(p, coord, color ="red", geom="arrow", linetype = "solid")

p <- ggbiplot()
