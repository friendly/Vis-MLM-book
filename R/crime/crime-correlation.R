library(correlation)
library(see) # for plotting
#library(ggraph) # needs to be loaded
#library(here)
library(corrplot)
library(corrgram)
library(dplyr)

data(crime, package="ggbiplot")

crime.cor <- crime |>
  dplyr::select(where(is.numeric)) |> 
  cor()

# similar to Fig 3.24
corrgram(crime.cor, 
         lower.panel = panel.ellipse,
         upper.panel = panel.ellipse,
         diag.panel = panel.density)

# show representation of ellipse and correlation value

crime.cor <- crime |>
  dplyr::select(where(is.numeric)) |> 
  cor()
corrplot(crime.cor,
  diag = FALSE, 
  method = "ellipse",
  tl.col = "black",
  tl.srt = 0,
  addCoef.col = "black",
  addCoefasPercent = TRUE)

# use correlation ordering ("AOE")
corrplot(crime.cor,
   diag = FALSE, 
   order = "AOE",
   method = "ellipse",
   tl.col = "black",
   tl.srt = 0,
   addCoef.col = "black",
   addCoefasPercent = TRUE)


corrplot.mixed(crime.cor,
   lower = "ellipse",
   upper = "pie",
   tl.col = "black",
   tl.srt = 0,
   tl.cex = 1.25,
   addCoef.col = "black",
   addCoefasPercent = TRUE)

corrplot.mixed(crime.cor,
  order = "AOE",          #"FPC",
  lower = "ellipse",
  upper = "ellipse",
  tl.col = "black",
  tl.srt = 0,
  tl.cex = 1.25,
  addCoef.col = "black",
  addCoefasPercent = TRUE)

ord <- corrMatOrder(crime.cor, order = "AOE")
rownames(crime.cor)[ord]

library(seriation)

ord <- seriate(crime.cor, method = "PCA_angle")
# what's the order ?
permute(crime.cor, ord) |> rownames()




#' ## Correlation package

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
