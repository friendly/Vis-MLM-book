
library(MASS)
library(ggpubr)
library(dplyr)

data(Diabetes, package="heplots")

mds <- Diabetes |>
  dplyr::select(where(is.numeric)) |>
  dist() |>          
  isoMDS() |>
  purrr::pluck("points") 

colnames(mds) <- c("Dim1", "Dim2")
mds <- bind_cols(mds, group = Diabetes$group)
mds |> sample_n(6)

# Plot MDS solution
cols <- scales::hue_pal()(3) |> rev()
mplot <-
ggscatter(mds, x = "Dim1", y = "Dim2", 
          color = "group",
          shape = "group",
          palette = cols,
          size = 2,
          ellipse = TRUE,
          ellipse.level = 0.5,
          ellipse.type = "t") +
  geom_hline(yintercept = 0, color = "gray") +
  geom_vline(xintercept = 0, color = "gray") 
  
mplot

# project variables into this space

vectors <- cor(Diabetes[, 1:5], mds[, 1:2])
scale_fac <- 500
mplot + 
  coord_fixed() +
  geom_segment(data=vectors,
               aes(x=0, xend=scale_fac*Dim1, y=0, yend=scale_fac*Dim2),
               arrow = arrow(length = unit(0.2, "cm"), type = "closed"),
               linewidth = 1.1) +
  geom_text(data = vectors,
            aes(x = 1.15*scale_fac*Dim1, y = 1.07*scale_fac*Dim2, 
                label=row.names(vectors)),
            nudge_x = 4,
            size = 4) +
  theme(legend.position = "inside",
        legend.position.inside = c(.8, .8))

  