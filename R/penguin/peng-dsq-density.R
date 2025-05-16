library(heplots)
library(dplyr)
library(ggplot2)

data(peng, package="heplots")
source(here::here("R", "penguin", "penguin-colors.R"))

DSQ <- Mahalanobis(peng[, 3:6])
noteworthy <- order(DSQ, decreasing = TRUE)[1:3] |> print()

# contour plot
library(ggdensity)
peng_plot <- peng |>
  tibble::rownames_to_column(var = "id") |> 
  mutate(note = id %in% noteworthy,
         DSQ = DSQ)

ggplot(peng_plot, 
       aes(x = bill_length, y = bill_depth,
           #           color = species, shape = species, 
           fill = DSQ)) +
  stat_density2d(geom="polygon", aes(fill = after_stat(level))) +
  geom_point(aes(size=note), show.legend = FALSE) +
  scale_size_manual(values = c(1.5, 4)) +
  geom_text(data = subset(peng_plot, note==TRUE),
            aes(label = id),
            nudge_y = .4, color = "black", size = 5) +
  #  scale_color_penguins() +
  theme_bw(base_size = 14) 
# theme(legend.position = "inside",
#       legend.position.inside=c(0.85, 0.15))


library(akima)

interpdf <-interp2xyz(
  interp(x=peng_plot$bill_length, 
         y=peng_plot$bill_depth, 
         z=peng_plot$DSQ, duplicate="mean"), 
  data.frame=TRUE)

interpdf |>
  as_tibble() |>
  ggplot(aes(x = x, y = y, z = z, fill = z)) + 
  geom_tile() + 
  geom_contour(color = "white", alpha = 0.05) + 
  scale_fill_distiller(palette="Spectral", na.value="white") + 
  theme_bw()

