#' ---
#' title: penguin colors
#' ---

# Create consistent sets of colors for penguins examples
# These specific colors are taken from https://github.com/srvanderplas/ggpcp-paper/blob/main/index.R

peng.colors <- function(shade=c("medium", "light", "dark")) {
  
  shade = match.arg(shade)
  #             light      medium     dark
  oranges <- c("#FDBF6F", "#F89D38", "#F37A00")  # Adelie
  purples <- c("#CAB2D6", "#9A78B8", "#6A3D9A")  # Chinstrap
  greens <-  c("#B2DF8A", "#73C05B", "#33a02c")  # Gentoo
  
  cols.vec <- c(oranges, purples, greens)
  cols.mat <- 
    matrix(cols.vec, 3, 3, 
           byrow = TRUE,
           dimnames = list(species = c("Adelie", "Chinstrap", "Gentoo"),
                           shade = c("light", "medium", "dark")))
  # get shaded colors
  cols.mat[, shade ]
}

peng.colors("light")
peng.colors("medium")

scale_fill_penguins <- function(shade=c("medium", "light", "dark"), ...){
  shade = match.arg(shade)
  ggplot2::discrete_scale("fill","penguins",
                          scales:::manual_pal(values = peng.colors(shade)), ...)
}

scale_fill_penguins()

scale_colour_penguins <- function(shade=c("medium", "light", "dark"), ...){
  shade = match.arg(shade)
  ggplot2::discrete_scale("colour","penguins",
                          scales:::manual_pal(values = peng.colors(shade)), ...)
}
scale_color_penguins <- scale_colour_penguins


if(FALSE){
#             light      medium     dark
oranges <- c("#FDBF6F", "#F89D38", "#F37A00")  # Adelie
purples <- c("#CAB2D6", "#9A78B8", "#6A3D9A")  # Chinstrap
greens <-  c("#B2DF8A", "#73C05B", "#33a02c")  # Gentoo

cols.vec <- c(oranges, purples, greens)


(cols.mat <- 
  matrix(cols.mat, 3, 3, 
       byrow = TRUE,
       dimnames = list(species = c("Adelie", "Chinstrap", "Gentoo"),
                       shade = c("light", "medium", "dark")))
)

# get medium colors
cols.med <- cols.mat["medium",]

# https://stackoverflow.com/questions/25726276/visualize-a-list-of-colors-palette-in-r
library(scales)
show_col(cols.vec)
show_col(cols.mat)


# translate into color names
library(plotrix)
get_color_name <- function(color_hex) {
  out = vector(length = length(color_hex))
  
  for(i in seq_along(color_hex)) {
    out[i] <- color.id(color_hex[i])[1]
  }
  out
  
}

col.names <- get_color_name(cols.vec)
col.names <- matrix(col.names, 3, 3, 
                    byrow = TRUE)
dimnames(col.names) <-
  list(species = c("Adelie", "Chinstrap", "Gentoo"),
       shade = c("light", "medium", "dark"))
col.names
col.names[, "medium"]
}


