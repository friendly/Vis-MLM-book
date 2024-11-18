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

# ------- SST, SSH, SSE

Y <- dogfood[, c("start", "amount")]
Ydev <- sweep(Y, 2, colMeans(Y)) |> as.matrix()

#SST <- t(Ydev) %*% Ydev |> print()
SST <- crossprod(as.matrix(Ydev)) |> print()

fitted <- fitted(dogfood.mod)
Yfit <- sweep(fitted, 2, colMeans(fitted)) |> as.matrix()
SSH <- crossprod(Yfit) |> print()

residuals <- residuals(dogfood.mod)
SSE <- crossprod(residuals) |> print()

# or, from results of Anova()
SSH <- dogfood.aov$SSP |> print()
SSE <- dogfood.aov$SSE |> print()

library(matlib)

options("digits" = 5)
# Ugh! rownames/colnames if present are used by default. Need to make them null to avoid them.
rownames(SST) <- rownames(SSH) <- rownames(SSE) <- NULL
colnames(SST) <- colnames(SSH) <- colnames(SSE) <- NULL
Eqn(latexMatrix(SST), "=", latexMatrix(SSH), "+", latexMatrix(SSE))


# data ellipses
covEllipses(cbind(start, amount) ~ formula, data=dogfood,
            pooled = FALSE, 
            level = 0.40, label.pos = 3,
            fill = TRUE, fill.alpha= 0.1)
# or
dataEllipse(amount ~ start | formula, data=dogfood,
            levels = 0.4,
            fill = TRUE, fill.alpha= 0.1)

# test contrasts
linearHypothesis(dogfood.mod, "formula1", title="Ours vs. Theirs")
linearHypothesis(dogfood.mod, "formula2", title="Old vs. New")
linearHypothesis(dogfood.mod, "formula3", title="Alps vs. Major")

heplot(dogfood.mod)

