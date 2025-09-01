# Bullseye plots -- https://cran.r-project.org/web/packages/bullseye/vignettes/vis_pairwise.html

#load(here::here("data", "peng.RData"))
data(peng, package="heplots")
source("R/penguin/penguin-colors.R")

library(bullseye)

#The pairwise structure has multiple association scores when each (x,y) pair appears multiple times in the pairwise structure.

scores <- pairwise_scores(peng, 
                          pair_control(nn = "pair_cor"),
                          by="species")
plot(scores) 

# doesn't work
pdata <- peng |>
  dplyr::select(-island, -year)
scores <- pairwise_scores(pdata, 
                          pair_control(nn = "pair_cor"),
                          by="species")
plot(scores) 

