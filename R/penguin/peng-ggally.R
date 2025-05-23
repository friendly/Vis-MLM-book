#' ---
#' title: Penguin data, GGally ggpairs
#' ---
#' 

library(ggplot2)
library(GGally)

data(peng, package="heplots")
source("R/penguin/penguin-colors.R")

# use penguin colors
col <- peng.colors("medium")
pch <- 15:17
theme_set(theme_bw(base_size = 14))

# basic plot Fig 3.31

ggpairs(peng, columns=c(3:6, 7),
        aes(color=species, alpha=0.5),
        progress = FALSE) +
  theme_penguins() +
  theme(axis.text.x = element_text(angle = -45))



# use ggally_ functions
ggpairs(peng, columns=c(3:6, 7),
        aes(color=species, alpha=0.5),
        lower = list(continuous = "smooth"),
        upper = list(continuous = "smooth"),
        diag  = list(continuous = "boxDiag"),
        progress = FALSE) +
  theme_penguins()


# use panel functions

# my_panel <- function(data, mapping, ...){
#   p <- ggplot(data = data, mapping = mapping) + 
#     geom_point() + 
#     geom_smooth(method=loess, formula = y ~ x, 
#                 fill="red", color="red", ...) +
#     geom_smooth(method=lm, formula = y ~ x, 
#                 fill="blue", color="blue", ...)
#   p
# }

my_panel <- function(data, mapping, ...){
  p <- ggplot(data = data, mapping = mapping) + 
    geom_point() + 
    geom_smooth(method=lm, formula = y ~ x, se = FALSE, ...) +
    geom_smooth(method=loess, formula = y ~ x, se = FALSE, ...)
  p
}



ggpairs(peng, columns=3:6,
  mapping = aes(color=species, alpha=0.2),
  lower = list(continuous = my_panel),
  upper = list(continuous = my_panel),
  progress = FALSE) +
  theme_penguins()


# only regression line & data ellipse
my_panel1 <- function(data, mapping, ...){
  p <- ggplot(data = data, mapping = mapping) + 
     geom_smooth(method=lm, formula = y ~ x, se = FALSE, ...) +
     stat_ellipse(geom = "polygon", level = 0.68, ...)
  p
}

ggpairs(peng, columns=3:6,
        mapping = aes(color=species, fill = species, alpha=0.2),
        lower = list(continuous = my_panel1),
        upper = list(continuous = my_panel1),
        progress = FALSE) +
  theme_penguins() +
  theme(panel.grid.major = element_blank(), 
        panel.grid.minor = element_blank())

# show catgegorical variables Fig 3.7
ggpairs(peng, columns=c(3:6, 1, 2, 7),
        mapping = aes(color=species, fill = species, alpha=0.2),
        lower = list(continuous = my_panel1),
        upper = list(continuous = my_panel1),
        progress = FALSE) +
  theme_penguins() +
  theme(panel.grid.major = element_blank(), 
        panel.grid.minor = element_blank()) +
  theme(axis.text.x = element_text(angle = -45))



# make a general panel function, with elements optional
gg_panel <- function(data, mapping, ..., 
                      points = FALSE, 
                      lm = TRUE, 
                      loess = FALSE,
                      ellipse = TRUE){

  pts <- if(points) geom_point else NULL
  lml <- if(lm) geom_smooth(method=lm, formula = y ~ x, se = FALSE, ...) else NULL
  sml <- if(loess) geom_smooth(method=loess, formula = y ~ x, se = FALSE, ...) else NULL
  ell <- if(ellipse) stat_ellipse() else NULL
  
  p <- ggplot(data = data, mapping = mapping) + 
    pts + 
    lml +
    sml +
    ell
  p
}

ggpairs(peng, columns=3:6,
        mapping = aes(color=species, alpha=0.2),
        lower = list(continuous = wrap(gg_panel)),
        upper = list(continuous = wrap(gg_panel)),
        progress = FALSE) 




