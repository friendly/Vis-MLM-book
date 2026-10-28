#' ---
#' title: NLSY data, HE plot with the overall test of both predictors (Fig 12.16), for the talk
#' ---

# Draws talks/images/NLSY-HE-overall.png, a square version of the book's Fig 12.16
# (12-mlm-viz.qmd, fig-NLSY-heplot2) for a slide after "Quantitative predictors: each effect is a line":
# much larger labels (allowed to stray outside the plot box), and the Overall H ellipse more transparent so E and the predictor lines show through.
# Run from the project root.

library(heplots)

data(NLSY, package = "heplots")
NLSY.mod1 <- lm(cbind(read, math) ~ income + educ,
                data = NLSY)
coefs <- rownames(coef(NLSY.mod1))[-1]

png("talks/images/NLSY-HE-overall.png", width = 6, height = 6, units = "in", res = 300)
op <- par(mar = c(4, 4, 2, 2) + 0.5, xpd = NA)                # room, and no clipping, for big labels
heplot(NLSY.mod1,
       hypotheses = list("Overall" = coefs),
       fill = TRUE, fill.alpha = c(0.2, 0.2, 0.2, 0.08),   # E, income, educ, Overall
       cex = 1.5, cex.lab = 1.5,
       label.cex = 2.2,                                     # ellipse labels; default par("cex")
       lwd = c(2, 3, 3, 2),
       label.pos = c("bottom", "top"))
par(op)
dev.off()
