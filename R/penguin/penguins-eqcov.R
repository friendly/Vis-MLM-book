# equality of covariances for penguins data

library(dplyr)
library(ggplot2)
library(car)
library(effects)
library(heplots)
library(candisc)

data(peng, package="heplots")
source("R/penguin/penguin-colors.R")
# use penguin colors
col <- peng.colors()
pch <- 15:17

# Levine tests

leveneTest(bill_length ~ species, data=peng)
leveneTest(body_mass ~ species, data=peng)

leveneTests(peng[, 3:6], peng$species)

leveneTests(cbind(bill_length, bill_depth, flipper_length, body_mass) ~ species, data = peng)

peng.mod <- lm(cbind(bill_length, bill_depth, flipper_length, body_mass) ~ species, 
               data = peng)
leveneTests(peng.mod)

# do it manually

vars <- c("bill_length", "bill_depth", "flipper_length", "body_mass")

# Multivariate levene test
pengDevs <- abs(colDevs(peng[, vars], peng$species, median))
dev.mod <- lm(pengDevs ~ peng$species)
Anova(dev.mod)

pengDevs <- data.frame(species = peng$species, pengDevs)
dev.mod <- lm(cbind(bill_length, bill_depth, flipper_length, body_mass) ~ species, 
              data=pengDevs)
Anova(dev.mod)

heplot(dev.mod)


# box plots of deviations
dev_long <- data.frame(species = peng$species, pengDevs) |> 
  pivot_longer(bill_length:body_mass, 
               names_to = "variable", 
               values_to = "value") 

dev_long |>
  group_by(species) |> 
  ggplot(aes(value, species, fill = species)) +
#  geom_vline(xintercept = 0, color = "red") +
  geom_boxplot() +
  facet_wrap(~ variable, scales = 'free_x') +
  xlab("abs( median deviation )") +
  theme_penguins() +
  theme_bw(base_size = 14) +
  theme(legend.position = 'none') 



#' ## Initial scatterplots and data ellipses


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

col <- peng.colors("dark")
clr <- c(col, gray(.20))
op <- par(mar = c(4, 4, 1, 1) + .5,
          mfrow = c(c(1,2)))
covEllipses(cbind(bill_length, bill_depth) ~ species, data=peng,
            fill=TRUE,
            fill.alpha = 0.1,
            lwd = 3,
            col = clr)

covEllipses(cbind(bill_length, bill_depth) ~ species, data=peng,
            center=TRUE, 
            fill=c(rep(FALSE,3), TRUE), 
            fill.alpha=.1, 
            lwd = 3,
            col = clr,
            label.pos=c(1:3,0))
par(op)



#' All pairs when more than two variables are specified
#' They look pretty similar
clr <- c(peng.colors(), "black")
covEllipses(peng[,3:6], peng$species, 
            variables=1:4,
            col = clr,
            fill=TRUE, 
            fill.alpha=.1)

#' See diffs better by overlay at grand mean
covEllipses(peng[,3:6], peng$species, 
            variables=1:4, 
            col = clr,
            center=TRUE,
            fill=TRUE, 
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
#cols = c(scales::hue_pal()(3), "black")
cols = c(peng.colors(), "black")
covEllipses(peng.pca$x, peng$species, 
            col = cols,
            fill= TRUE, 
            fill.alpha=.1,
            label.pos=1:4, asp=1)

covEllipses(peng.pca$x, peng$species, 
            col = cols,
            center=TRUE,
            fill=TRUE, 
            fill.alpha=.1, 
            label.pos=1:4, asp=1)
par(op)

# all variables
covEllipses(peng.pca$x, peng$species, 
            col = cols,
            variables=1:4, 
            fill=TRUE, 
            label.pos=1:4, fill.alpha=.1)

covEllipses(peng.pca$x, peng$species, 
            col = cols,
            center=TRUE,  
            variables=1:4, 
            fill=TRUE, 
            label.pos=1:4, fill.alpha=.1)

# Plot the last two, PC 3,4
op <- par(mfcol=c(1,2), mar=c(5,4,1,1)+.1)
covEllipses(peng.pca$x, peng$species, 
            col = cols,
            variables=3:4, 
            fill=TRUE, 
            label.pos=c(1, 3, 3, 0), fill.alpha=.1, asp=1)

covEllipses(peng.pca$x, peng$species, 
            col = cols,
            center=TRUE, 
            variables=3:4, 
            fill=c(rep(FALSE,3), TRUE), 
            label.pos=c(1:3,0), fill.alpha=.1, asp=1)
par(op)
