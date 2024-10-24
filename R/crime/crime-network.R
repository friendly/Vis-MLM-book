#' ---
#' title: network diagram of correlations & partial correlations
#' ---

library(qgraph)

#' ## Crime data
#' 
data(crime, package = "ggbiplot")

corrmat <- crime |>
  dplyr::select(where(is.numeric)) |> 
  cor()

# ### "association graph": network of correlations
qgraph(corrmat, 
       title = "Crime data, correlations", title.cex = 1.25,
       graph = "cor",
       minimum = "sig", sampleSize = nrow(crime),
       color = grey(.9), vsize = 12,
       labels = rownames(corrmat),
       posCol = "blue")


# ### "concentration graph": network of partial correlations
# Correlations between variables that cannot be explained by other variables in the network

qgraph(corrmat, 
       title = "Crime data, partial correlations", title.cex = 1.25,
       graph = "pcor",
       minimum = "sig", sampleSize = nrow(crime),
       color = grey(.9), vsize = 14,
       labels = rownames(corrmat),
       edge.labels = TRUE, edge.label.cex = 1.7,
       posCol = "blue")


#' ### variable ordering: reorder variables by PC1 & PC2 angles
library(seriation)

ord <- seriate(corrmat, method = "PCA_angle")
# what's the order ?
permute(corrmat, ord) |> rownames()

qgraph(permute(corrmat, ord), 
       title = "Crime data, correlations", title.cex = 1.25,
       graph = "cor",
       minimum = "sig", sampleSize = nrow(crime),
       color = grey(.9), vsize = 12,
       labels = rownames(permute(corrmat, ord)),
       edge.labels = TRUE, edge.label.cex = 1.3,
       posCol = "blue")





#' `mtcars` data
data(mtcars)

corrmat <- cor(mtcars)

qgraph(corrmat, 
       graph = "cor",
       minimum = "sig", sampleSize = nrow(mtcars),
       color = grey(.9), vsize = 12,
       labels = names(mtcars),
       posCol = "blue")

qgraph(corrmat, 
       graph = "pcor",
       minimum = "sig", sampleSize = nrow(mtcars),
       color = grey(.9), vsize = 12,
       labels = names(mtcars),
       posCol = "blue")

# same, for crime data




