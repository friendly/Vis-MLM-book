
library(MASS)
library(ggpubr)
library(dplyr)

data(Diabetes, package="heplots")

mds <- Diabetes |>
  dplyr::select(where(is.numeric)) |>
  dist() |>          
  isoMDS() |>
  purrr::pluck("points") |>
  as_tibble()
colnames(mds) <- c("Dim1", "Dim2")
mds <- bind_cols(mds, group = Diabetes$group)

# Plot MDS
ggscatter(mds, x = "Dim1", y = "Dim2", 
          color = "group",
          shape = "group",
          size = 2,
          ellipse = TRUE,
          ellipse.type = "t")

