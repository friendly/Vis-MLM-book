# outlier detection
library(heplots)
library(dplyr)
library(ggplot2)

data(peng, package="heplots")
source(here::here("R", "penguin", "penguin-colors.R"))

clr <- peng.colors("dark")
pch <- c(19, 17, 15)   # ggplot defaults for a factor

out <- cqplot(peng[, 3:6], 
   id.n = 3,
   col = clr[peng$species],
   pch = pch[peng$species],
   ref.col = "grey",
   what = "Penguin numeric variables",
   cex.lab = 1.25)

# extreme cases
cbind(id=rownames(out), 
      peng[rownames(out), c(1,3:6)])

DSQ <- Mahalanobis(peng[, 3:6])
noteworthy <- order(DSQ, decreasing = TRUE)[1:3] |> print()

peng |> subset(rownames(peng) %in% noteworthy)

peng |>
  tibble::rownames_to_column(var = "id") |> 
  select(id, species, bill_length:body_mass) |>
  mutate(across(bill_length:body_mass, c(scale))) |>
  filter(id %in% noteworthy)

peng |>
  tibble::rownames_to_column(var = "id") |> 
  mutate(
    z_BL = c(scale(bill_length)),
    z_BD = c(scale(bill_depth)),
    z_FL = c(scale(flipper_length)),
    z_BM = c(scale(body_mass))
  ) |>
  filter(id %in% noteworthy) |>
  select(id, species, sex, z_BL:z_BM) 


peng |>
   tibble::rownames_to_column(var = "id") |> 
   mutate(across(bill_length:body_mass, scale)) |>
   filter(id %in% noteworthy)  



peng_plot <- peng |>
  tibble::rownames_to_column(var = "id") |> 
  mutate(note = id %in% noteworthy)

ggplot(peng_plot, 
       aes(x = bill_length, y = bill_depth,
           color = species, shape = species, fill=species)) +
  geom_point(aes(size=note), show.legend = FALSE) +
  scale_size_manual(values = c(1.5, 4)) +
  geom_text(data = subset(peng_plot, note==TRUE),
            aes(label = id),
            nudge_y = .4, color = "black", size = 5) +
  geom_smooth(method = "lm", formula = y ~ x,
              se=FALSE, linewidth=2) +
  stat_ellipse(geom = "polygon", level = 0.95, alpha = 0.1) +
  theme_penguins() +
  theme_bw(base_size = 14) +
  theme(legend.position = "inside",
        legend.position.inside=c(0.85, 0.15))


ggplot(iris, aes(x=Petal.Width, y=Petal.Length, fill=Sepal.Width)) +
  stat_density2d(geom="polygon", aes(fill = factor(..level..)))

# From Cara Tompson

# |- Exceptions ----
p_exceptions <- peng |>
  tibble::rownames_to_column(var = "id") |>
  filter(bill_length == 48.7 & flipper_length == 222 |
           bill_length == 46.9 & flipper_length == 192 |
           bill_length == 58.0 & flipper_length == 181 |
           bill_length == 44.1 & flipper_length == 210) |>
  arrange(bill_length) |>
  mutate(nickname = c( "The BFG", "Tinkerbell", "Average Joes", "Cyrano")) |>
  print()

         