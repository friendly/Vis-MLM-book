library("qgraph")
library(dplyr)

data(big5)
data(big5groups)

big5groups |> as.data.frame() |> head()


big5Graph <-
qgraph(cor(big5),
       title = "Big 5\ncorrelations", 
       title.cex = 1.5,
       minimum=0.25,cut=0.4,
       vsize=2,
       groups=big5groups,
       legend=TRUE,
       borders=FALSE,
       posCol = "blue")


# groups are ignored with "spring" layout
qgraph(big5Graph, layout = "spring")

# --------------

# subsett of items for a simpler display
items <- 20
big5_sub <- big5[, 1:(5 * items)]
big5groups_sub <- big5groups |> 
  as.data.frame() |>
  slice(1:items) |>
  as.list() 

qgraph(cor(big5_sub),
       title = "Big 5\ncorrelations", 
       title.cex = 1.5,
       minimum=0.2, 
       cut=0.4,
       vsize=2,
       groups=big5groups_sub,
       legend=TRUE,
       borders=FALSE,
       posCol = "blue",
       layoutScale = c(1.05,1.05))



