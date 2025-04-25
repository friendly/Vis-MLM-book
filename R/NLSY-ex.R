
library(heplots)
library(car)

data(NLSY, package = "heplots")

#examine the data
scatterplotMatrix(NLSY, smooth=FALSE)

# test control variables by themselves
# -------------------------------------
mod1 <- lm(cbind(read,math) ~ income+educ, data=NLSY)
Anova(mod1)
heplot(mod1, fill=TRUE)

# test of overall regression
coefs <- rownames(coef(mod1))[-1]
linearHypothesis(mod1, coefs)
heplot(mod1, fill=TRUE, hypotheses=list("Overall"=coefs))


# additional contribution of antisoc + hyperact over income + educ
# ----------------------------------------------------------------
mod2 <- lm(cbind(read,math) ~ antisoc + hyperact + income + educ, data=NLSY)
Anova(mod2)

coefs <- rownames(coef(mod2))[-1]
heplot(mod2, fill=TRUE, hypotheses=list("Overall"=coefs, "mod2|mod1"=coefs[1:2]))
linearHypothesis(mod2, coefs[1:2])

heplot(mod2, fill=TRUE, hypotheses=list("mod2|mod1"=coefs[1:2]))

