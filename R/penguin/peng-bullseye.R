# Bullseye plots -- https://cran.r-project.org/web/packages/bullseye/vignettes/vis_pairwise.html

#load(here::here("data", "peng.RData"))
data(peng, package="heplots")
source("R/penguin/penguin-colors.R")

library(bullseye)

# iris

irisc <- pairwise_scores(iris, by = "Species") 
irisc
plot(irisc)

#The pairwise structure has multiple association scores when each (x,y) pair appears multiple times in the pairwise structure.

pdata <- peng |>
  dplyr::select(-island, -year, -sex)
scores <- pairwise_scores(pdata, 
#                          pair_control(nn = "pair_cor"),
                          by="species")
scores

plot(scores) 


# doesn't work
pdata <- peng |>
  dplyr::select(-island, -year)
scores <- pairwise_scores(pdata, 
                          pair_control(nn = "pair_cor"),
                          by="species")
plot(scores) 

