library(car)
library(ggplot2)
library(tidyr)
library(dplyr)
library(heplots)

data(dogfood, package = "heplots")
str(dogfood)

op <- par(mfrow = c(1,2))
boxplot(start ~ formula, data = dogfood)
points(start ~ formula, data = dogfood, pch=16, cex = 1.2)

boxplot(amount ~ formula, data = dogfood)
points(amount ~ formula, data = dogfood, pch=16, cex = 1.2)
par(op)

dog_long <- dogfood |>
  pivot_longer(c(start, amount),
               names_to = "variable")
ggplot(data = dog_long, 
       aes(x=formula, y = value, fill = formula)) +
  geom_boxplot(alpha = 0.2) +
  geom_point(size = 2.5) +
  facet_wrap(~ variable, scales = "free") +
  theme_bw(base_size = 14) + 
  theme(legend.position="none")


dogfood.mod <- lm(cbind(start, amount) ~ formula, data=dogfood) |> 
  print()
dogfood.aov <- Anova(dogfood.mod) |>
  print()
summary(dogfood.mod) 

#------ model matrix
contrasts(dogfood$formula)
X <- model.matrix(dogfood.mod)

# first row of each type
cbind(formula = dogfood$formula,
      as.data.frame(X)) |> 
  dplyr::slice_head(n =1, by=formula)

# contrasts(dogfood$formula) <- contr.treatment(4)
# dogfood.mod0 <- lm(cbind(start, amount) ~ formula, data=dogfood)
# model.matrix(dogfood.mod0)

# ------- SST, SSP_H, SSP_E

Y <- dogfood[, c("start", "amount")]
Ydev <- sweep(Y, 2, colMeans(Y)) |> as.matrix()
SSP_T <- crossprod(as.matrix(Ydev)) |> print()

fitted <- fitted(dogfood.mod)
Yfit <- sweep(fitted, 2, colMeans(fitted)) |> as.matrix()
SSP_H <- crossprod(Yfit) |> print()

residuals <- residuals(dogfood.mod)
SSP_E <- crossprod(residuals) |> print()

# or, from results of Anova()
SSP_H <- dogfood.aov$SSP |> print()
SSP_E <- dogfood.aov$SSPE |> print()

library(matlib)

options("digits" = 5)
# Ugh! rownames/colnames if present are used by default. Need to make them null to avoid them.
rownames(SSP_T) <- rownames(SSP_H) <- rownames(SSP_E) <- NULL
colnames(SSP_T) <- colnames(SSP_H) <- colnames(SSP_E) <- NULL
Eqn(latexMatrix(SSP_T), "=", latexMatrix(SSP_H), "+", latexMatrix(SSP_E))

eqn <- "
\begin{equation*}
\overset{\mathbf{SSP}_T}
  {\begin{pmatrix} 
   35.4 & -59.2 \\ 
  -59.2 & 975.9 \\ 
  \end{pmatrix}}
=
\overset{\mathbf{SSP}_H}
  {\begin{pmatrix} 
    9.69 & -70.94 \\ 
  -70.94 & 585.69 \\ 
  \end{pmatrix}}
+
\overset{\mathbf{SSP}_E}
  {\begin{pmatrix} 
   25.8 &  11.8 \\ 
   11.8 & 390.3 \\ 
  \end{pmatrix}}
\end{equation*}
"

# eigenvalues

HEinv <- SSP_H %*% solve(SSP_E) |> print()
eigen(HEinv)

library(candisc)
dogfood.can <- candisc(dogfood.mod) |> print()

# data ellipses
covEllipses(cbind(start, amount) ~ formula, data=dogfood,
            pooled = FALSE, 
            level = 0.40, label.pos = 3,
            fill = TRUE, fill.alpha= 0.1)
# or
dataEllipse(amount ~ start | formula, data=dogfood,
            levels = 0.4,
            fill = TRUE, fill.alpha= 0.1)


# setup contrasts to test interesting comparisons
C <- matrix(
  c( 1,  1, -1, -1,         #Ours vs. Theirs
     0,  0,  1, -1,           #Major vs. Alps
     1, -1,  0,  0),             #New vs. Old
  nrow=4, ncol=3)
# assign these to the formula factor
contrasts(dogfood$formula) <- C

# test these contrasts with multivariate tests
linearHypothesis(dogfood.mod, "formula1", title="Ours vs. Theirs")
linearHypothesis(dogfood.mod, "formula2", title="Old vs. New")
linearHypothesis(dogfood.mod, "formula3", title="Alps vs. Major")

heplot(dogfood.mod, fill = TRUE, fill.alpha = 0.1)

# display contrasts in the heplot 
hyp <- list("Ours/Theirs" = "formula1",
            "Old/New" = "formula2")
heplot(dogfood.mod, hypotheses = hyp,
       fill = TRUE, fill.alpha = 0.1)

dogfood.can <- candisc(dogfood.mod, data=dogfood)
heplot(dogfood.can, 
       fill = TRUE, fill.alpha = 0.1, 
       lwd = 2, var.lwd = 2, var.cex = 2)

