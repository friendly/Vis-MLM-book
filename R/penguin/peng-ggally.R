#' ---
#' title: Penguin data, GGally ggpairs
#' ---
#' 

library(ggplot2)
library(GGally)

load(here::here("data", "peng.RData"))
str(peng)

theme_set(theme_bw(base_size = 16))

# basic plot
ggpairs(peng, columns=3:6,
        aes(color=species, alpha=0.5))


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
  progress = FALSE) 

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
  theme(panel.grid.major = element_blank(), 
        panel.grid.minor = element_blank())



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




