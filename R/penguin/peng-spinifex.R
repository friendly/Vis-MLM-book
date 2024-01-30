#' ---
#' title: spinfex - penguins
#' ---
# from: https://nspyrison.github.io/spinifex/articles/getting_started_with_spinifex.html

library("tourr")
library("spinifex")
library("ggplot2")
library("dplyr")

load(here::here("data", "peng.RData"))
source("R/penguin/penguin-colors.R")
peng_scaled <- scale(peng[,3:6])

dat_std <- peng_scaled
colnames(dat_std) <- c("blen", "bdep", "flen", "bmass")
bas_pca <- basis_pca(dat_std)
clas    <- peng$species

ggtour(basis_array = bas_pca, data = dat_std) +
  proto_basis(line_size = 1, text_size = 6)

view_manip_space(basis = bas_pca, manip_var = 1,
                 basis_label = colnames(dat_std),
                 line_size = 1, text_size = 6)

# Save a tour path
mt_path <- manual_tour(basis = bas_pca, manip_var = 3)

## Compose the display
my_ggtour <- ggtour(basis_array = mt_path, data = dat_std, angle = .2) +
  ## Angle is the distance between (geodesically) interpolated frames
  proto_default(aes_args = list(color = clas, shape = clas))

## Animate
animate_gganimate(ggtour = my_ggtour, fps = 6,
                  height = 3, width = 4.5, units = "in", res = 150)
## Or as a plotly html widget
#animate_plotly(ggt, fps = 6)


