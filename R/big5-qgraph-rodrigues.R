# Gabriel Rodrigues, Exhausting all arguments on qgraph
# code from https://reisrgabriel.com/blog/2021-08-21-qgraph-exhaustive/

library(psych)
library(qgraph)
library(dplyr)

# prepare data

# Data
df <- bfi[,1:25]

# Hyperparameters
# Group:
traits <- rep(c('Agreeableness',
                'Conscientiousness',
                'Extraversion',
                'Neuroticism',
                'Openness'),
              each = 5)

# Nodes:
items <- c(
  "Am indifferent to the feelings of others.",
  "Inquire about others' well-being.",
  "Know how to comfort others.",
  "Love children.",
  "Make people feel at ease.",
  "Am exacting in my work.",
  "Continue until everything is perfect.",
  "Do things according to a plan.",
  "Do things in a half-way manner.",
  "Waste my time.",
  "Don't talk a lot.",
  "Find it difficult to approach others.",
  "Know how to captivate people.",
  "Make friends easily.",
  "Take charge.",
  "Get angry easily.",
  "Get irritated easily.",
  "Have frequent mood swings.",
  "Often feel blue.",
  "Panic easily.",
  "Am full of ideas.",
  "Avoid difficult reading material.",
  "Carry the conversation to a higher level.",
  "Spend time reflecting on things.",
  "Will not probe deeply into a subject.")

# Neuroticism columns:
neuroticism <- c('N1', 'N2', 'N3', 'N4', 'N5')

network <- 
  qgraph(
    input = cor_auto(df),
    
    #' *Important additional arguments* (p. 29)
    
    layout = 'spring', # 'circle', 'groups', 'circular'
    groups = traits, # list or vector
    minimum = 0, # min value to be plotted
    #' *maximum* =, max value to scale edge widths, default is absmax pcor(x,y)
    cut = 0, # value to initiate the scaling of edge widths
    palette = 'colorblind', # 'rainbow', 'pastel', 'gray', 'R', 'ggplot2'
    theme = 'colorblind', # 'classic', 'gray', 'Hollywood', 'Borkulo', 'gimme',
    # 'TeamFortress', 'Reddit', 'Leuven', 'Fried'
    
    #' *Additional options for correlation/covariance matrices* (p. 30)
    
    graph = 'glasso', # 'cor', 'pcor'
    sampleSize = nrow(df), # sample size, when graph="glasso" or minimum="sig"
    
    #' *Output arguments* (pp. 30-31)
    width = 7 * 1.4, # width of figure
    height = 7, # height of figure
    
    #' *Graphical arguments*
    
    # Nodes (pp. 31-32)
    
    vsize = ifelse(colnames(df) == neuroticism, 7.5, 6),
    # indicates node size, can be a vector with size for each node
    # default =  8*exp(-nNodes/80)+1
    border.width = 0.5, # controls width of the border
    
    # Node labels (pp. 32-33)
    label.cex = 0.7, # scalar on label size
    label.color = 'black', # string on label colors
    label.prop = 0.9, # proportion of the width of the node that the label scales
    
    # Edges (pp. 33-34)
    negDashed = T, # should negative edges be dashed?
    
    # Edge curvature (pp. 34-35)
    # curve = NA, # single value, a vector list, weight matrix or NA (default)
    curveAll = T, # logical indicating if all edges should be curved
    curveDefault = 0.5, # default is 1
    
    # Legend (p. 35-36)
    legend.cex = 0.27, # scalar of the legend
    legend.mode = 'style2', # default is 'style1', different way to show legend
    nodeNames = items, # names for each node to plot in legend
    
    # Generical graphical arguments (p. 36)
    font = 2 # integer specifying default font for node and edge labels
  )
