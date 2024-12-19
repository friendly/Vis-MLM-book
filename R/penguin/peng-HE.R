library(dplyr)
library(car)
library(heplots)
library(candisc)

data(peng, package="heplots")
source(here::here("R", "penguin", "penguin-colors.R"))
## MANOVA

contrasts(peng$species)<-matrix(c(1,-1,0, -1, -1, -2), 3,2)
contrasts(peng$species)


peng.mod <-lm(cbind(bill_length, bill_depth, flipper_length, body_mass) ~ species, data=peng)
etasq(peng.mod)

col <- peng.colors("dark")
pch <- 15:17

clr <- c(col, "red")

# data ellipses vs HE plot

covEllipses(cbind(bill_length, bill_depth) ~ species, data=peng,
            pooled = TRUE,
            fill=TRUE,
            fill.alpha = 0.1,
            lwd = 3,
            col = clr,
            cex.lab = 1.25,
            xlim = c(35, 55), ylim = c(14, 20))

heplot(peng.mod, size = "effect",
       fill=TRUE, fill.alpha=0.1,
       cex = 1.25, cex.lab = 1.25,
       xlim = c(35, 55), ylim = c(14, 20))


# effect vs evidence scaling

heplot(peng.mod, size = "effect",
       fill=TRUE, fill.alpha=0.1,
       cex = 1.25, cex.lab = 1.25,
       xlim = c(0, 80), ylim = c(0, 30))

heplot(peng.mod, size = "evidence",
       fill=TRUE, fill.alpha=0.1,
       cex = 1.25, cex.lab = 1.25,
       xlim = c(0, 80), ylim = c(0, 30))



