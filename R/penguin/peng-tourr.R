# library(dplyr)
# library(tidyr)
# library(ggplot2)
library(tourr)

#setwd("C:/R/Projects/Vis-MLM-book")
load(here::here("data", "peng.RData"))
source("R/penguin/penguin-colors.R")

peng_scaled <- scale(peng[,3:6])

col <- peng.colors()[peng$species]
animate(peng_scaled,
        tour_path = guided_tour(holes()),
        display = display_xy(col = col,
                             cex = 1.5,
                             edges.width = 2))

animate(peng_scaled, 
        guided_tour(lda_pp(peng$species)),
        display = display_xy(col = col,
                             cex = 1.5,
                             edges.width = 2))

render_gif(peng_scaled, 
        guided_tour(lda_pp(peng$species)),
        display = display_xy(col = col,
                             cex = 1.5,
                             edges.width = 2),
        gif_file = "images/peng-tourr-lda.gif",
        loop = 3)



# try:
devtools::install_github("uschiLaa/galahr")
library(galahr)
## launching the app with the default dataset
launchApp()
