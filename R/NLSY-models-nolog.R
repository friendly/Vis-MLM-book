#' ---
#' title: NLSY models & HE plots - no log
#' ---

library(heplots)
library(car)
library(ggplot2)
library(dplyr)
library(mvinfluence)

data(NLSY, package = "heplots")

mod0 <- lm(cbind(read, math) ~ income + educ + antisoc + hyperact, 
           data = NLSY )


# test control variables by themselves
# -------------------------------------
NLSY.mod1 <- lm(cbind(read, math) ~ income + educ, 
                data = NLSY)

anova(NLSY.mod1)  # Type I, sequential test
Anova(NLSY.mod1)  # Type II

coef(NLSY.mod1)
tidy(NLSY.mod1)

# using income makes the scales of coefficients incommensurable
coefplot(NLSY.mod1, fill = TRUE,
         col = c("darkgreen", "brown"),
         lwd = 2,
         ylim = c(-0.5, 3),
         main = "Bivariate coefficient plot for reading and math\nwith 95% confidence ellipses")


# Plot standardized coefficients 
NLSY_std <- scale(NLSY) |>
  as.data.frame()

NLSY_std.mod1 <- lm(cbind(read, math) ~ income + educ, 
                data = NLSY_std)
op <- par(cex.lab = 1.5, mar = c(4,4,1,1)+.1)
coefplot(NLSY_std.mod1, fill = TRUE,
   col = c("darkgreen", "brown"),
   lwd = 2,
   cex.lab = 1.5,
   ylim = c(-0.1, 0.5),
   xlab = "read coefficient (std)",
   ylab = "math coefficient (std)")
par(op)


cqplot(NLSY.mod1, id.n = 5)

heplot(NLSY.mod1, 
       fill=TRUE, fill.alpha = 0.2, 
       cex = 1.5, cex.lab = 1.5,
       lwd=c(2, 3, 3),
       label.pos = c("bottom", "top", "top")
)

# test of overall regression
coefs <- rownames(coef(NLSY.mod1))[-1]
linearHypothesis(NLSY.mod1, coefs) |> print(SSP = FALSE)

heplot(NLSY.mod1, 
       hypotheses = list("Overall" = coefs),
       fill=TRUE, fill.alpha = 0.2, 
       cex = 1.5, cex.lab = 1.5,
       lwd=c(2, 3, 3, 2),
       label.pos = c("bottom", rep("top", 3))
)

NLSY.mod2 <- lm(cbind(read, math) ~ income + educ + antisoc + hyperact , 
                data = NLSY)

heplot(NLSY.mod2, 
       fill=TRUE, fill.alpha = 0.2, 
       cex = 1.5, cex.lab = 1.5,
       lwd=c(2, 3, 3),
       label.pos = c("bottom", "top", "top", "top", "bottom"))

NLSY.rlm <- robmlm(cbind(read, math) ~ income + educ, # + antisoc + hyperact , 
               data = NLSY)

heplot(NLSY.rlm, 
       fill=TRUE, fill.alpha = 0.2, 
       cex = 1.5, cex.lab = 1.5,
       lwd=c(2, 3, 3),
       label.pos = c("bottom", "top", "top", "top", "bottom")
)

op <- par(mar = c(5,5,1,1))
influencePlot(NLSY.mod1,
              id.method = "noteworthy",
              id.n = 3, id.cex = 1.25,
              cex.lab = 1.5)
par(op)

influencePlot(NLSY.mod1, type = "LR", 
              id.method = "noteworthy",
              id.n = 3, id.cex = 1.25,
              cex.lab = 1.5,
              ylim = c(-8, 3))



# gives a peculiar plot -- weights aren't used
influencePlot(NLSY.rlm,
              id.method = "noteworthy",
              id.n = 3, id.cex = 1.25,
              cex.lab = 1.5)

plot(NLSY.rlm, 
     segments = TRUE,
     id.weight = 0.3)

b.mlm <- coef(NLSY.mod1)
b.rlm <- coef(NLSY.rlm)

reldiff <- function(x, y, pct=TRUE) {
  res <- abs(x - y) / x
  if (pct) res <- 100 * res
  res
}

reldiff(b.mlm, b.rlm)

# or use new heplots::rel_diff
heplots::rel_diff(b.mlm, b.rlm)


