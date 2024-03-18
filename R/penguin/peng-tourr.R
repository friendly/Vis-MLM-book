# library(dplyr)
# library(tidyr)
# library(ggplot2)
library(tourr)

#setwd("C:/R/Projects/Vis-MLM-book")
#load(here::here("data", "peng.RData"))
data(peng, package = "heplots")
source("R/penguin/penguin-colors.R")

peng_scaled <- scale(peng[,3:6])
colnames(peng_scaled) <- c("BL", "BD", "FL", "BM")

# illustrating tour dimensions and display methods
animate(peng_scaled, grand_tour(d = 2), display_xy())
animate(peng_scaled, grand_tour(d = 3), display_depth())
animate(peng_scaled, grand_tour(d = 4), display_pcp())


# find all display methods
grep("display", lsf.str("package:tourr"), value = TRUE)
# all guided methods
grep("guided", lsf.str("package:tourr"), value = TRUE)

# examples of guided tours
animate(peng_scaled, guided_tour(holes()))        # optimize finding gaps
animate(peng_scaled, guided_tour(lda_pp(group)))  # optimize separation of groups
animate(peng_scaled, guided_anomaly_tour())       # optimize finding outliers


# animate(peng_scaled,
#         tour_path = guided_tour(holes()),
#         display = display_xy(col = peng$species,
#                              palette = peng.colors("dark"),
#                              cex = 1.5))

# how to get the right colors & legend?
#col <- peng.colors()[peng$species] 
pch <- c(15, 16, 17)[peng$species] 
cex = 1.2

#' ## Grand tour
# |- Grand tour ---
set.seed(1234)
animate(peng_scaled,
        tour_path = grand_tour(d=2),
        display_xy(col = peng$species,
                   palette = peng.colors("dark"),
                   pch = pch, cex = cex,
                   axis.col = "black", 
                   axis.text.col = "black", 
                   axis.lwd = 1.5))
set.seed(1234)
render_gif(peng_scaled,
           tour_path = grand_tour(d=2),
           display_xy(col = peng$species,
                      palette = peng.colors("dark"),
                      pch = pch, cex = cex,
                      axis.col = "black", 
                      axis.text.col = "black", 
                      axis.lwd = 1.5),
           gif_file = "images/tours/peng-tourr-grand.gif")

# making them factors gives legends, but without the species names
#col <- peng.colors()[peng$species] |> as.factor()
#pch <- c(15,16,17)[peng$species] |> as.factor()

# grand tour
set.seed(1234)
animate(peng_scaled,
        tour_path = grand_tour(d=2),
        display = display_xy(col = peng$species,
                             palette = peng.colors("dark"),
                             pch = pch,
                             cex = cex))

# ## Guided tours
#  --let's use holes() ---
set.seed(1234)
animate(peng_scaled,
        tour_path = guided_tour(holes()),
        display = display_xy(col = peng$species,
                             palette = peng.colors("dark"),
                             pch = pch,
                             cex = cex))
set.seed(1234)
render_gif(peng_scaled,
        tour_path = guided_tour(holes()),
        display = display_xy(col = peng$species,
                             palette = peng.colors("dark"),
                             pch = pch,
                             cex = cex,
                             axis.col = "black", 
                             axis.text.col = "black", 
                             axis.lwd = 1.5),
        gif_file = "images/tours/peng-tourr-holes.gif",
        loop = 3)


# -- use LDA projection pursuit
set.seed(1234)
animate(peng_scaled, 
        guided_tour(lda_pp(peng$species)),
        display = display_xy(col = peng$species,
                             palette = peng.colors("dark"),
                             pch = pch,
                             cex = cex,
                             axis.col = "black", 
                             axis.text.col = "black", 
                             axis.lwd = 1.5))
set.seed(1234)
render_gif(peng_scaled, 
           guided_tour(lda_pp(peng$species)),
           display = display_xy(col = peng$species,
                                palette = peng.colors("dark"),
                                pch = pch,
                                cex = cex,
                                axis.col = "black", 
                                axis.text.col = "black", 
                                axis.lwd = 1.5),
           gif_file = "images/tours/peng-tourr-lda.gif",
           loop = 3)

# wha does LDA show?
MASS::lda(species ~ bill_length + bill_depth + flipper_length + body_mass, data=peng)



# |- use anomalies ---
animate(peng_scaled, 
        guided_anomaly_tour(anomaly_index(), ellipse = cov(peng_scaled)),
        display_xy(col = peng$species,
                   palette = peng.colors("dark"),
                   pch = pch,
                   cex = cex))

render_gif(peng_scaled, 
           guided_anomaly_tour(anomaly_index(), ellipse = cov(peng_scaled)),
           display_xy(col = peng$species,
                      palette = peng.colors("dark"),
                      pch = pch,
                      cex = cex,
                      axis.col = "black", 
                      axis.text.col = "black", 
                      axis.lwd = 1.5),
           gif_file = "images/tours/peng-tourr-anomalies.gif",
           loop = 3)

# display_pca
set.seed(1234)
peng_pca <- prcomp(peng_scaled, center = FALSE)
peng_scores <- peng_pca$x[, 1:3]
peng_coefs <- peng_pca$rotation[, 1:3]
animate_pca(peng_scores, pc_coefs = peng_coefs)


# save and animate as a planned tour
hist1 <- save_history(peng_scaled, guided_tour(holes()), max = 5)
animate(peng_scaled, planned_tour(hist1),
        display = display_xy(col = peng$species,
                             cex = 1.2))

render_gif(peng_scaled, planned_tour(hist1),
           display = display_xy(col = peng$species,
                                cex = 1.2),
           gif_file = "images/peng-tourr-holes.gif")

plot(path_index(interpolate(hist1), holes()))
plot(path_curves(interpolate(hist1)))

animate(peng_scaled, 
        guided_tour(lda_pp(peng$species)),
        display = display_xy(col = col,
                             cex = 1.2))

render_gif(peng_scaled, 
        guided_tour(lda_pp(peng$species)),
        display = display_xy(col = col,
                             cex = 1.2),
        gif_file = "images/peng-tourr-lda.gif",
        loop = 3)



# try:
devtools::install_github("uschiLaa/galahr")
library(galahr)
## launching the app with the default dataset
launchApp()

# from: https://raw.githubusercontent.com/dicook/vISEC2020/master/skills_showcase/runthis.R

# Checking important variables
# use this w/o axes to generate static view of some frames
set.seed(47)
animate_xy(peng_scaled, 
   tour_path = grand_tour(),
   col=col,
   pch = pch,
#   axes="off", 
   fps=5,
   max_frames = 20)

render_gif(peng_scaled, 
   tour_path = grand_tour(),
   display = display_xy(col = col,
                        cex = 1.5,
                         pch = pch,
                         axes="off"
                        ),
   frames = 20,
   gif_file = "images/peng-tourr-grand.gif",
   loop = 3)

# crop this using ezgif

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
animate_xy(peng_scaled, 
           local_tour(start=best_proj, 0.9),
           axes = "bottomleft", col=col)


# showing path curves

library(ggplot2)
library(tidyr)
path2d <- save_history(peng_scaled, grand_tour(2), 3)

# spaghetti plots
plot(path_curves(path2d))
plot(path_curves(interpolate(path2d)))

# Instead of relying on the built in plot method, you might want to
# generate your own.  Here are few examples of alternative displays:

df <- path_curves(path2d)
ggplot(data = df, aes(x = step, y = value, group = obs:var, colour = var)) +
  geom_line() +
  facet_wrap(~obs)

ggplot(
  data = pivot_wider(df,
                     id_cols = c(obs, step),
                     names_from = var, names_prefix = "Var",
                     values_from = value),
  aes(x = Var1, y = Var2)
  ) +
    geom_point() +
    facet_wrap(~step) +
    coord_equal()


