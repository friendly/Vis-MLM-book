#' ---
#' title: network diagram of correlations & partial correlations
#' ---

library(qgraph)

#' ## Crime data
#' 
data(crime, package = "ggbiplot")

crime.cor <- crime |>
  dplyr::select(where(is.numeric)) |> 
  cor()

# ### "association graph": network of correlations
qgraph(crime.cor, 
       title = "Crime data, correlations", title.cex = 1.25,
       graph = "cor",
       minimum = "sig", sampleSize = nrow(crime), alpha = 0.01,
       color = grey(.9), vsize = 12,
       labels = rownames(crime.cor),
       posCol = "blue")


# ### "concentration graph": network of partial correlations
# Correlations between variables that cannot be explained by other variables in the network

qgraph(crime.cor, 
       title = "Crime data, partial correlations", title.cex = 1.25,
       graph = "pcor",
       minimum = "sig", sampleSize = nrow(crime), alpha = 0.01,
       color = grey(.9), vsize = 14,
       labels = rownames(crime.cor),
       edge.labels = TRUE, edge.label.cex = 1.7,
       posCol = "blue")


#' ### variable ordering: reorder variables by PC1 & PC2 angles
library(seriation)

ord <- seriate(crime.cor, method = "PCA_angle")
# what's the order ?
permute(crime.cor, ord) |> rownames()

qgraph(permute(crime.cor, ord), 
       title = "Crime data, correlations", title.cex = 1.25,
       graph = "cor",
       minimum = "sig", sampleSize = nrow(crime), alpha = 0.01,
       color = grey(.9), vsize = 12,
       labels = rownames(permute(crime.cor, ord)),
       edge.labels = TRUE, edge.label.cex = 1.3,
       posCol = "blue")

#' to understand the partial correlations, make scatterplots of the residuals from the
#' models where each x_i, x_j are predicted by all others. I've never seen such a plot,
#' but could be done by modifying AVplot
#' 



#' ## `mtcars` data
#' Try the same things for the mtcars data
data(mtcars)

cars.cor <- cor(mtcars)

qgraph(cars.cor, 
       graph = "cor",
       minimum = "sig", sampleSize = nrow(mtcars),
       color = grey(.9), vsize = 12,
       labels = names(mtcars),
#       edge.labels = TRUE, edge.label.cex = 1.3,
       posCol = "blue")

qgraph(cars.cor, 
       graph = "pcor",
       minimum = "sig", sampleSize = nrow(mtcars),
       color = grey(.9), vsize = 12,
       labels = names(mtcars),
       edge.labels = TRUE, edge.label.cex = 1.3,
       posCol = "blue")





