library(correlation)
library(see) # for plotting
#library(ggraph) # needs to be loaded
#library(here)
library(corrplot)
library(dplyr)

load(here::here("data", "crime.RData"))

crime |>
  select(where(is.numeric)) |>
  cor() |>
  corrplot(diag = FALSE, 
           method = "ellipse",
           tl.col = "black",
           tl.srt = 0,
           addCoef.col = "red",
           addCoefasPercent = TRUE)


# ordinary correlations
crime |> 
  correlation() |>
  summary()

# partial correlations
crime |> 
  correlation(partial = TRUE) |>
  summary()

crime |> 
  correlation(partial = TRUE) |>
  plot() +
  scale_edge_color_gradient2(low = "red", mid="white", high = "blue")

# filter out correlations with p > .10
crime.pcor <- crime |> correlation(partial = TRUE)
crime.pcor |>
  mutate(r = ifelse(p < .10, r, 0)) |>
  plot() +
    scale_edge_color_gradient2(low = "red", mid="white", high = "blue")


summary(crime.cor)
plot(crime.cor) +
  scale_edge_color_gradient2(low = "red", mid="white", high = "blue")

layers <- visualisation_recipe(crime.cor)
plot(layers)
