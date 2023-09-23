# equality of covariances for penguins data

library(dplyr)
library(ggplot2)
library(car)
library(effects)
library(heplots)
library(candisc)

# 
# library(palmerpenguins)
# 
# # clean up variable names, etc.
# peng <- penguins %>%
#   rename(
#     bill_length = bill_length_mm, 
#     bill_depth = bill_depth_mm, 
#     flipper_length = flipper_length_mm, 
#     body_mass = body_mass_g
#   ) %>%
#   mutate(species = as.factor(species),
#          island = as.factor(island),
#          sex = as.factor(substr(sex,1,1))) %>%
#   filter(!is.na(bill_depth),
#          !is.na(sex))

load(here::here("data", "peng.RData"))

# ggplotColours <- function(n = 6, h = c(0, 360) + 15){
#   if ((diff(h) %% 360) < 1) h[2] <- h[2] - 360/n
#   hcl(h = (seq(h[1], h[2], length = n)), c = 100, l = 65)
# }
# 
#' ## Initial scatterplots and data ellipses

# use ggplot colors
col <- scales::hue_pal()(3)
pch <- 15:17

op <- par(mfcol=c(1,2), mar=c(5,4,1,1)+.1)
scatterplot(bill_length ~ body_mass | species, data=peng,
            ellipse=list(levels=0.68), 
            smooth=FALSE, # regLine=FALSE, 
            grid=FALSE,
            legend=list(coords = "bottomright"), 
            col = col
            )	

scatterplot(bill_length ~ body_mass | species, data=peng,
            ellipse=list(levels=0.68), 
            smooth=FALSE, grid=FALSE, # regLine=FALSE, 
            cex=0, 
            legend=list(coords = "bottomright"), 
            col = col)
par(op)


#' ## Using the covEllipse function

#' Uncentered and centered, first two variables

covEllipses(cbind(bill_length, bill_depth) ~ species, data=peng,
            fill=c(rep(FALSE,3), TRUE))


covEllipses(cbind(bill_length, bill_depth) ~ species, data=peng,
            center=TRUE, 
            fill=c(rep(FALSE,3), TRUE), 
            fill.alpha=.1, label.pos=c(1:3,0))

#' All pairs when more than two variables are specified
#' They look pretty similar
covEllipses(peng[,3:6], peng$species, 
            variables=1:4, 
            fill=c(rep(FALSE,3), TRUE), 
            fill.alpha=.1)

#' See diffs better by overlay at grand mean
covEllipses(peng[,3:6], peng$species, 
            variables=1:4, 
            center=TRUE,
            fill=c(rep(FALSE,3), TRUE), 
            label.pos=c(1:3,0), 
            fill.alpha=.1)




# # fit a model for bill_length
# 
# peng.mod0 <- lm(bill_length ~ body_mass + sex + species + island, data=peng)
# Anova(peng.mod0)
# 
# peng.mod1 <- lm(bill_length ~ bill_depth + flipper_length + body_mass + sex + species + island, data=peng)
# Anova(peng.mod1)


# fit an MLM
peng.mod2 <- lm(cbind(bill_length, bill_depth, flipper_length, body_mass) ~ species, data=peng)
Anova(peng.mod2)

#' Box's M test 	

peng.boxm <- boxM(cbind(bill_length, bill_depth, flipper_length, body_mass) ~ species, data=peng)
peng.boxm

op <- par(mar=c(4,5,1,1)+.1)
plot(peng.boxm, gplabel="Species")
par(op)

#' ## View in PCA space
#'
peng.pca <- prcomp(peng[, 3:6], scale = TRUE) 
summary(peng.pca)

#' Plot in space of PC1 & PC2
op <- par(mfcol=c(1,2), mar=c(5,4,1,1)+.1)
covEllipses(peng.pca$x, peng$species, 
            fill=c(rep(FALSE,3), TRUE), 
            fill.alpha=.1,
            label.pos=1:4, asp=1)

covEllipses(peng.pca$x, peng$species, 
            center=TRUE,
            fill=c(rep(FALSE,3), TRUE), 
            fill.alpha=.1, 
            label.pos=1:4, asp=1)
par(op)

# all variables
covEllipses(peng.pca$x, peng$species, 
            variables=1:4, 
            fill=c(rep(FALSE,3), TRUE), 
            label.pos=1:4, fill.alpha=.1)

covEllipses(peng.pca$x, peng$species, 
            center=TRUE,  
            variables=1:4, 
            fill=c(rep(FALSE,3), TRUE), 
            label.pos=1:4, fill.alpha=.1)

# Plot the last two, PC 3,4
covEllipses(peng.pca$x, peng$species, 
            variables=3:4, 
            fill=c(rep(FALSE,3), TRUE), 
            label.pos=c(1:3,0), fill.alpha=.1, asp=1)

covEllipses(peng.pca$x, peng$species, 
            center=TRUE, 
            variables=3:4, 
            fill=c(rep(FALSE,3), TRUE), 
            label.pos=c(1:3,0), fill.alpha=.1, asp=1)
