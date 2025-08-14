library(heplots)
library(broom)

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
colors = c("red", "darkblue", "darkgreen", "brown")
heplot(plastic.mod, size="evidence", 
       col=colors, cex=1.25,
       fill=TRUE, fill.alpha=0.1)
heplot(plastic.mod, size="effect", 
       add=TRUE, lwd=5, term.labels=FALSE, col=colors)


