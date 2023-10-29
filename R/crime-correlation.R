library(correlation)
library(see) # for plotting
#library(ggraph) # needs to be loaded
library(here)
library(corrplot)
library(dplyr)

load(here("data", "crime.RData"))

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
  plot()

crime.cor <- crime |> correlation()
summary(crime.cor)
plot(crime.cor) 
plot(crime.cor,
     show_data = "tile",
     scale_fill = list(
       high = "blue",
       low = "red"
     ))

layers <- visualisation_recipe(crime.cor)
plot(layers)
