#' ---
#' title: dogfood quartet
#' ---
#' 
data(dogfood, package="heplots")
library(car)
library(heplots)
library(candisc)

source(here::here("R", "util", "text.usr.R"))

# setup contrasts to test interesting comparisons
C <- matrix(
       c( 1,  1, -1, -1,         #Ours vs. Theirs
          0,  0,  1, -1,           #Major vs. Alps
          1, -1,  0,  0),             #New vs. Old
       nrow=4, ncol=3)
# assign these to the formula factor
contrasts(dogfood$formula) <- C

dogfood.mod <- lm(cbind(start, amount) ~ formula, data=dogfood)
Anova(dogfood.mod)

col <- c("red", "blue", "darkgreen", "brown", "black", "darkgray")
options(heplot.colors = col)

# dataEllipse(amount ~ start | formula, data=dogfood,
#             pch = 15:19, 
#             col = col,
# #            cex = 3,
#             levels = 0.40)

# (a) just the data

op <- par(mar = c(4, 4, 0, 0)+.5,
          mfrow = c(2, 2))
plot(amount ~ start, data=dogfood, 
     pch = (15:19)[dogfood$formula], 
     col = col[dogfood$formula],
     cex=2, cex.lab = 1.5,
     xlim = c(-1, 5),
     ylim = c(70, 110))
text.usr(0.02, 0.95, "(a) Data", pos = 4, cex = 1.3)

# (b) data ellipses
covEllipses(cbind(start, amount) ~ formula, data=dogfood,
            col = col, lwd=0.1,
            pooled = FALSE, level = 0.40,
            fill = TRUE, fill.alpha = 0.05,
            cex.lab = 1.5,
            cex = 1.5,
            xlim = c(-1,5),
            ylim = c(70, 110))
oints(amount ~ start, data=dogfood, 
       pch = (15:19)[dogfood$formula], 
       col = col[dogfood$formula],
       cex=1.5)
text.usr(0.02, 0.95, "(b) Data ellipses", pos = 4, cex = 1.3)

# (c) HE plot
heplot(dogfood.mod, fill = TRUE, 
       fill.alpha = 0.1, 
       cex.lab = 1.5,
       cex = 1.5,
       xlim = c(-1, 5),
       ylim = c(70, 110))
text.usr(0.02, 0.95, "(c) HE plot", pos = 4, cex = 1.3)

#'
# display contrasts in the heplot 
# hyp <- list("Ours/Theirs" = "formula1",
#             "Old/New" = "formula2")
# heplot(dogfood.mod, hypotheses = hyp,
#        fill = TRUE, fill.alpha = 0.1,
#        cex.lab = 1.5,
#        xlim = c(0,5),
#        ylim = c(75, 100))

# (d) Canonical HE plot
dogfood.can <- candisc(dogfood.mod, data=dogfood)
heplot(dogfood.can, 
       fill = TRUE, fill.alpha = 0.1, 
       lwd = 2, var.lwd = 2, var.cex = 1.5,
       scale = 2,
       cex = 1.25,
       cex.lab = 1.5)
text.usr(0.02, 0.95, "(d) CD-HE plot", pos = 4, cex = 1.3)

par(op)

# just the HE plot

# H & E matrices for 

dogfood.aov <- Anova(dogfood.mod) 
SSP_H <- dogfood.aov$SSP[[1]] |> print()


SSP_E <- dogfood.aov$SSPE |> print()

cov2cor(SSP_H)
cov2cor(SSP_E)


heplot(dogfood.mod, fill = TRUE, 
       fill.alpha = 0.1, 
       cex.lab = 1.5,
       cex = 1.5,
       xlim = c(-1,5),
       ylim = c(70, 100))



