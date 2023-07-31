# classification trees
# from: https://jkunst.com/blog/posts/2023-07-10-my-favorite-ggplot2-packages-with-examples/

#' ggparty tries to stick as closely as possible to ggplot2’s grammar of graphics. The basic building blocks to a ggparty plot are:
#'  ggparty() replaces the usual ggplot(). Takes a object of class 'party' instead of a 'data.frame'.
#' 
#' * geom_edge() draws the edges between the nodes
#' * geom_edge_label() labels the edges with the corresponding split breaks
#' * geom_node_label() labels the nodes with the split variable, node info or anything else. The shorthand versions of this geom geom_node_splitvar() and geom_node_info() have the correct defaults to write the split variables in the inner nodes resp. the info in the terminal nodes.
#' * geom_node_plot() creates a custom ggplot at the location of the node


load("data/peng.RData")
library(partykit) # ctree
library(ggparty)

penguinct <- ctree(
  species ~ bill_length + bill_depth + flipper_length + body_mass + sex,
  data = peng
)

#' ## bars, showing proportion of each species
autoplot(penguinct)

#' ## scatterplots of bill_depth vs. bill_length
ggparty(penguinct) +
  geom_edge(color = "gray80") +
  geom_edge_label(color = "gray50", size = 4) +
  geom_node_label(
    aes(label = splitvar),
    color = "gray30",
    label.col = NA, # no box
    size = 4,
    label.padding = unit(0.5, "lines"),
    ids = "inner"
  ) +
  geom_node_plot(
    gglist = list(
      geom_point(
        aes(x = bill_length, y = bill_depth, color = species),
        size = 1, alpha = 0.5
      ),
#      scale_color_viridis_d(end = 0.9),
      guides(color = guide_legend(override.aes = list(size = 5))), 
      theme_minimal(),
      theme(axis.text = element_text(size = 7)),
      labs(x = NULL, y = NULL)
    ),
    scales = "fixed",
    id = "terminal"
  ) +
  geom_node_label(
    aes(label = sprintf("Node %s (n = %s)", id, nodesize)),
    ids = "terminal",
    size = 3,
    label.col = NA, # no box
    nudge_y = 0.01
  )


