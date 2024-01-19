# library(dplyr)
# library(tidyr)
# library(ggplot2)
library(tourr)

load(here::here("data", "peng.RData"))
source("R/penguin/penguin-colors.R")

peng_scaled <- scale(peng[,3:6])

animate(peng_scaled,
        tour_path = guided_tour(holes()),
        display = display_xy(col = peng$species))
