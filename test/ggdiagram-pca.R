# from https://wjschne.github.io/ggdiagram/articles/causalpaths.html

library(ggplot2)
library(ggdiagram)
library(tibble)
library(dplyr)
library(purrr)
library(ggarrow)

ggdiagram(font_family = my_font) +
  # observed variables
  {o <- ob_ellipse(m1 = 10, a = .6, color = NA) |>
    ob_array(5, sep = .2, fill = class_color(my_fills[2])@lighten(seq(.6, .9, length.out = 5)))} +
  # principal components
  {pc <- ob_circle(fill = my_fills[c(1,3)], color = NA) |> 
    place(o[c(2, 4)], "above", 2)} +
  # direct effects from o to pc
  map(
    unbind(pc), \(pci) {
      connect(from = o@north, 
              to = pci, 
              color = pci@fill,
              resect = 2)@geom()
    }
  ) +
  # covariances among observed variables
  map(1:4, \(i) {
    offset <- c(-1.5, -.5, .5, 1.5) * .11
    ob_covariance(
      x = o[seq(i + 1, 5)]@south + 
        ob_point(offset[seq(1, 5 - i)], 0),
      y = o[i]@south + 
        ob_point(-offset[seq(1, 5 - i)], 0),
      bend = 45,
      looseness = 1.4,
      linewidth = .5, 
      arrowhead_length = 6,
      color = my_fills[2]
    )@geom()
  }) + 
  # Labels
  ob_label("Formative<br>Indicators", size = 16, fill = NA) |> 
  place(o@bounding_box@east, sep = .8) + 
  ob_label("Principal<br>Components", size = 24, fill = NA) |> 
  place(pc@bounding_box@east, sep = 1.3) +
  # Invisible point to prevent label from clipping
  ob_point(o@bounding_box@east@x + 1.2, 1, color = "white")
