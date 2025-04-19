# from https://github.com/drjohnrussell/30DayChartChallenge/blob/main/2025/Challenge13.R

library(tidyverse)
library(HistData)
library(plotly)

data("Pollen")

res <- cor(Pollen)
round(res,2)

plot_ly(Pollen, x = ~ridge, y = ~nub, z = ~crack)  |> 
  add_markers(color = ~weight, size=2) |> 
  layout(title="David Coleman's Synthetic Pollen Dataset")|>
  config(displayModeBar=FALSE)