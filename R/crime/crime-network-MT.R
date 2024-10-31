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

## Developing a Network Graph
# Pick a threshold below which correlations are removed. Compare with 'minimum'.
crime.cor_qthreshold <- qgraph(crime.cor,
                               threshold = .3,
                               labels = rownames(crime.cor))

# Insert a lot of notes regarding what Node strength, closeness, betweenness,
# and Expected Influence mean. Chapter 3 of Network Psychometrics with R is great for this.
centralityPlot(crime.cor_qthreshold, scale = "raw0", include = c("All"))

# The centrality plot seems to suggest that robbery, rape and burglary are
# particularly well connected to the other variables in the graph. Let's see
# what the spring layout gives us.
#
# First let's save the centrality information from the thresholded graph
crime.cor_cent <- centrality(crime.cor_qthreshold)
# Since some of the betweenness measures are 0, we'll exponentiate the values to
# induce both non-zero vsizes and spread out the values; then, we'll also
# linearly translate all the vsizes for readability.
crime.cor_spring <- qgraph(
  crime.cor_qthreshold,
  threshold = .3,
  layout = "spring",
  vsize = exp(crime.cor_cent$Betweenness)+5,
  repulsion = 1.2 # Repulsion value for the spring layout.
)

# Another widely used network package that has its own features that we can take
# advantage of is from igraph. Importantly, we may interface from qgraph to
# igraph, which expands our options.
library(igraph)
qgraph:::as.igraph.qgraph(crime.cor_spring) |>
  plot()


# Admittedly, there's a degree of arbitrariness to all this manual wrangling.
# More automated and statistically justified methods arise from exploratory
# graph analysis and examining the network of partial correlations. 

library(EGAnet)

EGA(data = crime[,sapply(crime, is.numeric)], model = "glasso")
bootEGA(crime[,sapply(crime, is.numeric)], seed = 123)


# At least in terms of marginal correlations, there's also a lot of options
# opened up by using library(correlation) and library(hetcor). 
#
# In the literature, popular and important arguments against the general network
# approach centers around its combination of seeming arbitrariness in how the
# methods are applied, questionable replicability of the results, questionable
# validity and interpretation of the associated centrality measures, and a
# mismatch between network theories and network methods. We don't tackle these
# issues here, but rather see network methods as an important part of one's
# toolkit. However, it's worth mentioning that much of the critiques of network
# methods are not uniquely applicable to network methods, but in fact extend
# easily to even the casual use multiple linear regressions and hence ANOVA.
# Therefore, although these critiques become readily apparent through network
# analysis, in understanding the critique, we should also be more reflective on
# how traditional multiple linear regression and ANOVAs should be applied.
# Lastly, there is a deep connection between network constructs, network
# methods, and other popular social science quantitative methods, including
# factor analysis and item response theory.


# ### "concentration graph": network of partial correlations
# Correlations between variables that cannot be explained by other variables in the network
# MT Comment: I'd prefer to say that it's the correlation after controlling for
# all other variables in the network
qgraph(crime.cor, 
       title = "Crime data, partial correlations", title.cex = 1.25,
       graph = "pcor",
       minimum = "sig", sampleSize = nrow(crime), alpha = 0.01,
       color = grey(.9), vsize = 14,
       labels = rownames(crime.cor),
       edge.labels = TRUE, edge.label.cex = 1.7,
       posCol = "blue")

## Once again we examine the centrality measures and refine the graph
crime.pcor <- qgraph(crime.cor, graph = "pcor", labels = rownames(crime.cor))

centralityPlot(crime.pcor, scale = "raw0", include = c("All"))
# The centrality plot is quite different this time around and gives us a lot of options. The two most interesting seem to be the Betweenness and the Expected Influence plot

# We save the centrality information for later
crime.pcor_cent <- centrality(crime.pcor)

crime.pcor_Betweenness<- qgraph(
  crime.cor,
  graph = "pcor",
  labels = rownames(crime.cor),
  layout = "spring",
  vsize = exp(crime.pcor_cent$Betweenness - 8) + 8,
  repulsion = 1.2,
  negDashed = TRUE
)

crime.pcor_ExpectedInfluence <- qgraph(
  crime.cor,
  graph = "pcor",
  labels = rownames(crime.cor),
  layout = "spring",
  vsize = exp(crime.pcor_cent$OutExpectedInfluence) + 5,
  repulsion = 1.2,
  negDashed = TRUE
)



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





