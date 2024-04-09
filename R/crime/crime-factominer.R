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
  rename(Life_Exp = `Life Exp`,
         HS_Grad = `HS Grad`) |> 
  dplyr::select(state, Income, Illiteracy, Life_Exp, HS_Grad)

crime_joined <-
  dplyr::left_join(crime[, 1:8], supp_data, by = "state")
names(crime_joined)

row.names(crime_joined) <- crime$st
crime.PCA_sup <- PCA(crime_joined[,c(2:8, 9:12)], 
                     quanti.sup = 8:11,
                     scale.unit=TRUE, 
                     ncp=3, 
                     graph = FALSE)

# reflect Dim 2
crime.PCA_sup <- ggbiplot::reflect(crime.PCA_sup, columns = 2)
## NB: This is now handled in ggbiplot
crime.PCA_sup$quanti.sup$coord[, 2] <- -1 * crime.PCA_sup$quanti.sup$coord[, 2]

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


#' ## Test finding supplementary variables

supp.coord <- crime.PCA_sup$quanti.sup$coord

var.coord <- crime.PCA_sup$var$coord

# do the regression directly
reg.data <- cbind(scale(supp_data[, -1]), 
                  crime.PCA_sup$ind$coord) |>
  as.data.frame()

sup.mod <- lm(cbind(Income, Illiteracy, Life_Exp, HS_Grad) ~ 0 + Dim.1 + Dim.2 + Dim.3, data = reg.data )

(coefs <- t(coef(sup.mod)))

# but, same at the correlations
cor(reg.data[, 1:4], reg.data[, 5:7]) |>
  print() -> R

R / coefs
