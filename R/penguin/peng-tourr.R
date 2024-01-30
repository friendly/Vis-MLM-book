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
        display = display_xy(col = peng$species,
                             palette = "Roma",
                             cex = 1.5))

# how to get the right colors & legend?

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

# from: https://raw.githubusercontent.com/dicook/vISEC2020/master/skills_showcase/runthis.R

# Checking important variables
animate_xy(peng_scaled, 
           col=col, 
           axes="off", 
           fps=15)

# Guided tour 
animate_xy(peng_scaled, 
           grand_tour(),
           axes = "bottomleft", col=col)

animate_faces(peng_scaled, col = col)



animate_xy(peng_scaled, 
           guided_tour(lda_pp(penguins$species)),
           axes = "bottomleft", col=col)
best_proj <- matrix(c(0.940, 0.058, -0.253, 0.767, 
                      -0.083, -0.393, -0.211, -0.504), ncol=2,
                    byrow=TRUE)

# Local tour
animate_xy(peng_scaled[,3:6], 
           local_tour(start=best_proj, 0.9),
           axes = "bottomleft", col=col)


