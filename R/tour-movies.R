library(tourr)

render(flea[, 1:6], grand_tour(d = 2), display_xy(), frames = 20,
  "pdf", "figures/movie-xy.pdf", width = 4, height = 4)

render(flea[, 1:6], grand_tour(d = 3), display_depth(), frames = 20,
  "pdf", "figures/movie-depth.pdf", width = 4, height = 4)

render(flea[, 1:6], grand_tour(d = 4), display_pcp(), frames = 20,
  "pdf", "figures/movie-pcp.pdf", width = 4, height = 4)


render(flea[, 1:6], grand_tour(d = 1), display_dist("ash"), frames = 1,
  "pdf", "figures/1d-ash.pdf", width = 4, height = 3)
render(flea[, 1:6], grand_tour(d = 1), display_dist("density"), frames = 1,
  "pdf", "figures/1d-dens.pdf", width = 4, height = 3)
render(flea[, 1:6], grand_tour(d = 1), display_dist("hist"), frames = 1,
  "pdf", "figures/1d-hist.pdf", width = 4, height = 3)
  
