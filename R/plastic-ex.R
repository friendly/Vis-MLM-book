library(heplots)
library(broom)
library(ggpubr)
library(patchwork)

data("Plastic", package="heplots")

plastic.mod <- lm(cbind(tear, gloss, opacity) ~ rate*additive, data=Plastic)
Anova(plastic.mod)
Anova(plastic.mod, test="Roy") # identical

uniStats(plastic.mod)
glance(plastic.mod)

# NB: Vignette shows how to get separate F tests for each term for each response
# using update())

# HE plot
## Compare evidence and effect scaling 
colors = c("red", "darkblue", "darkgreen", "brown4")
heplot(plastic.mod, size="significance", 
       col=colors, cex=1.5, cex.lab = 1.5,
       fill=TRUE, fill.alpha=0.1)
heplot(plastic.mod, size="effect", 
       col=colors, lwd=6,
       add=TRUE, term.labels=FALSE)

# plot the means & SEs

legend_inside <- function(pos) {
  theme(legend.position = "inside",
        legend.position.inside = pos)
}

p1 <- ggline(Plastic, 
  x = "rate", y = "tear",
  color = "additive", shape = "additive", linetype = "additive",
  add = c("mean_se"), position = position_dodge(width = .1),
  point.size = 5, linewidth = 1.5,
  palette = c("red", "blue"),
  ggtheme = theme_pubr(base_size = 16)
  ) +
  xlab("Rate of extrusion") +
  ylab("Tear resistance") +
  legend_inside(c(.25, .8)) 

p2 <- ggline(Plastic, 
  x = "rate", y = "gloss",
  color = "additive", shape = "additive", linetype = "additive",
  add = c("mean_se"), position = position_dodge(width = .1),
  palette = c("red", "blue"),
  point.size = 5, linewidth = 1.5,
  ggtheme = theme_pubr(base_size = 16)
  ) +
  xlab("Rate of extrusion") +
  ylab("Film gloss") +
  theme(legend.position = "none")

p1 + p2 

# try facet.by=c("variable"))
#  -- need data in the long format
ggline(Plastic, 
  x = "rate", y = "tear",
  color = "additive", shape = "additive", linetype = "additive",
  add = c("mean_se"), position = position_dodge(width = .1),
  point.size = 5, linewidth = 1.5,
  palette = c("red", "blue"),
#  facet.by = "variable",
  ggtheme = theme_pubr(base_size = 16)
  ) 



# show interaction means
intMeans <- termMeans(plastic.mod, 'rate:additive', 
                      abbrev.levels=3,
                      label.factors = TRUE) |> print()


heplot(plastic.mod, size="evidence", 
       col=colors, cex=1.5, cex.lab = 1.5, 
       lwd = c(1, 5),
       fill=TRUE, fill.alpha=0.05)

## add interaction means
intMeans <- termMeans(plastic.mod, 'rate:additive', 
                      abbrev.levels=3)
points(intMeans[,1], intMeans[,2], pch=18, cex=1.2, col="brown4")
text(intMeans[,1], intMeans[,2], rownames(intMeans), 
     adj=c(0.5, 1), col="brown4")
lines(intMeans[c(1,3),1], intMeans[c(1,3),2], 
      col="brown4", lwd = 3)
lines(intMeans[c(2,4),1], intMeans[c(2,4),2], 
      col="brown4", lwd = 3)
