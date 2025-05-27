```{r echo = -1}
#| label: fig-rohwer-HE-mod1
#| fig-width: 10
#| fig-height: 5
#| out-width: "100%"
#| fig-cap: "HE plot for SAT and PPVT (left) and for SAT and Raven (right) using the MANCOVA model. The ellipses labeled ‘Regr’ show the test of the overall model, including all predictors."
op <- par(mar = c(4,4,4,1) + .1, mfrow = c(1,2))
colors <- c("red", "blue", rep("black",5), "#969696")
covariates  <- c("n", "s", "ns", "na", "ss")
heplot(Rohwer.mod1, 
       col=colors, variables=c(1,2),
       hypotheses=list("Regr" = covariates),
       fill = TRUE, fill.alpha = 0.1,
       cex=1.5, cex.lab = 1.5,
       lwd=c(2, rep(3,5), 4))

heplot(Rohwer.mod1, 
       col=colors,  variables=c(1,3),
       hypotheses=list("Regr" = covariates),
       fill = TRUE, fill.alpha = 0.1,
       cex=1.5, cex.lab = 1.5,
       lwd=c(2, rep(3,5), 4))
par(op)
```

  