#' ---
#' title: crime data - ggbiplot
#' ---

library(ggplot2)
library(ggbiplot)
library(dplyr)
library(corrplot)
library(patchwork)
library(broom)

data(crime, package = "ggbiplot")

crime |> 
  dplyr::select(where(is.numeric)) |> 
  cor() |> 
  corrplot(method = "ellipse", tl.srt = 0, tl.col = "black", mar = rep(.5, 4))

crime.pca <- 
  crime |> 
  dplyr::select(where(is.numeric)) |>
  prcomp(scale. = TRUE)

summary(crime.pca)

# information about variables
var_info <- factoextra::get_pca_var(crime.pca)

# correlations
var_info |> purrr::pluck("cor")



crime.pca <- reflect(crime.pca)

# information about variables
var_info <- factoextra::get_pca_var(crime.pca)
names(var_info)

# correlations
var_info |> purrr::pluck("cor")

var_info$cor[, 1:3] |> round(digits=2)

# contributions of dimensions to variables
var_info |> purrr::pluck("contrib")
var_info |> purrr::pluck("contrib") |> rowSums()
var_info |> purrr::pluck("contrib") |> colSums()


contrib <- var_info$contrib
cbind(contrib, Total = rowSums(contrib)) |>
  rbind(Total = c(colSums(contrib), NA)) |> round(digits=3)

quality <- var_info$cos2
rowSums(quality)
colSums(quality)

quality[, 1:3]

#biplot(crime.pca)


# default scaling: standardized components
ggbiplot(crime.pca,
         labels = crime$st ,
         circle = TRUE,
         varname.size = 4,
         varname.color = "brown") +
  theme_minimal(base_size = 14) 

ggbiplot(crime.pca,
         obs.scale = 1, var.scale = 1,
         labels = crime$st ,
         circle = TRUE,
         varname.size = 4,
         varname.color = "brown") +
  theme_minimal(base_size = 14) 

# regions as groups, with ellipses
ggbiplot(crime.pca,
         obs.scale = 1, var.scale = 1,
         groups = crime$region,
         labels = crime$st,
         labels.size = 4,
         var.factor = 1.4,
         ellipse = TRUE, 
         ellipse.prob = 0.5, ellipse.alpha = 0.1,
         circle = TRUE,
         varname.size = 4,
         varname.color = "black",
         clip = "off") +
  labs(fill = "Region", color = "Region") +
  theme_minimal(base_size = 14) +
  theme(legend.direction = 'horizontal', legend.position = 'top')

# PC1 & PC3
ggbiplot(crime.pca,
         choices = c(1,3),
         obs.scale = 1, var.scale = 1,
         groups = crime$region,
         labels = crime$st,
         labels.size = 4,
         var.factor = 2,
         ellipse = TRUE, 
         ellipse.prob = 0.5, ellipse.alpha = 0.1,
         circle = TRUE,
         varname.size = 4,
         varname.color = "black", 
         clip = "off") +
  labs(fill = "Region", color = "Region") +
  theme_minimal(base_size = 14) +
  theme(legend.direction = 'horizontal', legend.position = 'top')

