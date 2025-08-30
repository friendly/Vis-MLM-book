# biplotEZ example, from https://github.com/MuViSU/biplotEZ/blob/main/vignettes/Biplots_in_3D.Rmd

library(biplotEZ)
library(rgl)
library(dplyr)

data(peng, package = "heplots")

source(here::here("R", "penguin", "penguin-colors.R"))
col <- peng.colors("dark")

peng |>
  select(species, bill_length:body_mass) |>
  biplot(scaled = TRUE) |> 
  PCA(group.aes = peng$species, 
      dim.biplot = 3
      ) |>
  axes(col="black") |> 
  ellipses(kappa = 3,opacity = 0.5, col = col) |> 
  plot()


# In a document, use:

chunck <- "
```{r echo=FALSE}
my.plot <- scene3d()
rglwidget(my.plot)
```
"
