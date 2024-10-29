#' ---
#' title: network diagram of correlations & partial correlations
#' ---

library(qgraph)
library(corrplot)

#' ## Crime data
#' 
data(crime, package = "ggbiplot")

crime.cor <- crime |>
  dplyr::select(where(is.numeric)) |> 
  cor()

# PCA ordering
ord <- corrMatOrder(crime.cor, order = "AOE")
rownames(crime.cor)[ord]
crime.cor <- crime.cor[ord, ord]

# ### "association graph": network of correlations
q1 <- qgraph(crime.cor, 
       title = "Crime data:\ncorrelations", title.cex = 1.5,
       graph = "cor",
       minimum = "sig", sampleSize = nrow(crime), alpha = 0.01,
       color = grey(.9), vsize = 12,
       labels = rownames(crime.cor),
       # curveAll = TRUE, # logical indicating if all edges should be curved
       # curveDefault = 0.5, # default is 1
       posCol = "blue")

png(filename = "images/crime-cor.png", height = 540, width = 540)
plot(q1)
dev.off()

# compare with spring
q2 <- qgraph(crime.cor, 
       title = "Crime data:\ncorrelations", title.cex = 1.5,
       graph = "cor",
       minimum = "sig", sampleSize = nrow(crime), alpha = 0.01,
       color = grey(.9), vsize = 12,
       labels = rownames(crime.cor),
       layout = "spring", repulsion = 1.2,
       # curveAll = TRUE, # logical indicating if all edges should be curved
       # curveDefault = 0.5, # default is 1
       posCol = "blue")

png(filename = "images/crime-cor-spring.png", height = 540, width = 540)
plot(q2)
dev.off()


# ### "concentration graph": network of partial correlations
# Correlations between variables that cannot be explained by other variables in the network

q3 <- qgraph(crime.cor, 
       title = "Crime data:\npartial correlations", title.cex = 1.5,
       graph = "pcor",
       minimum = "sig", sampleSize = nrow(crime), alpha = 0.05,
       color = grey(.9), vsize = 14,
       labels = rownames(crime.cor),
       edge.labels = TRUE, edge.label.cex = 1.7,
       posCol = "blue")

png(filename = "images/crime-partial.png", height = 540, width = 540)
plot(q3)
dev.off()

q4 <- qgraph(crime.cor, 
       title = "Crime data:\npartial correlations", title.cex = 1.5,
       graph = "pcor",
       minimum = "sig", sampleSize = nrow(crime), alpha = 0.05,
       color = grey(.9), vsize = 14,
       labels = rownames(crime.cor),
       edge.labels = TRUE, edge.label.cex = 1.7,
       layout = "spring", repulsion = 1.2,
       posCol = "blue")

png(filename = "images/crime-partial-spring.png", height = 540, width = 540)
plot(q4)
dev.off()

png(filename = "images/crime-cor-partial-spring.png", height = 500, width = 1000)
op <- par(mfrow = c(1, 2))
plot(q2)
plot(q4)
dev.off()

# using igraph
library(igraph)
qgraph:::as.igraph.qgraph(q1) |>
  plot()


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





