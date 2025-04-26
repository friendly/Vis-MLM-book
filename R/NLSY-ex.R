
library(heplots)
library(car)
library(ggplot2)
library(dplyr)

data(NLSY, package = "heplots")

#examine the data
scatterplotMatrix(NLSY, smooth=FALSE)

ggplot2::theme_set(theme_bw(base_size = 14))

set.seed(47)
ggplot(NLSY, aes(x = read, y = math)) +
  geom_jitter()+
  geom_smooth(method = lm, formula = y~x, fill = "blue", alpha = 0.2) +
  geom_smooth(method = loess, se = FALSE, color = "red", linewidth = 2)

mod0 <- lm(math ~ read, data=NLSY)
infl <- influencePlot(mod0)

ids <- heplots::noteworthy(NLSY[, 1:2], n=5)
ggplot(NLSY, aes(x = read, y = math)) +
  geom_jitter()+
  geom_smooth(method = lm, formula = y~x, fill = "blue", alpha = 0.2) +
  geom_text(data = NLSY[ids, ], label = ids, size = 5, nudge_y = 2) 



# density plots of all
NLSY_long <- NLSY |> 
  tidyr::pivot_longer(math:educ, names_to = "variable") |>
  mutate(variable = forcats::fct_inorder(variable))

ggplot(NLSY_long, aes(x=value, fill=variable)) +
  geom_density(alpha = 0.5) +
  facet_wrap(~variable, scales="free") +
  theme_bw(base_size = 14) +
  theme(legend.position = "none") 


# test control variables by themselves
# -------------------------------------
mod1 <- lm(cbind(read, math) ~ log2(income) + educ, 
           data= NLSY |> filter(income != 0))

anova(mod1)  # Type I, sequential test
Anova(mod1)  # Type II

coef(mod1)
coefplot(mod1, fill = TRUE,
         col = c("green", "brown"),
         ylim = c(-0.5, 2.5))

heplot(mod1, fill=TRUE, fill.alpha = 0.2)

# test of overall regression
coefs <- rownames(coef(mod1))[-1]
linearHypothesis(mod1, coefs)

heplot(mod1, fill=TRUE, hypotheses = list("Overall" = coefs))


# additional contribution of antisoc + hyperact over income + educ
# ----------------------------------------------------------------
mod2 <- lm(cbind(read,math) ~ antisoc + hyperact + log2(income) + educ, 
           data = NLSY |> filter(income != 0))
# use update
update(mod1, . ~ . + antisoc + hyperact)

Anova(mod2)

coefs <- rownames(coef(mod2))[-1]
heplot(mod2, fill=TRUE, 
       hypotheses=list("Overall"=coefs, "mod2|mod1"=coefs[1:2]))

linearHypothesis(mod2, coefs[1:2], title = "mod2 | mod1")

linearHypothesis(mod2, coefs, title = "Overall")

heplot(mod2, fill=TRUE, hypotheses=list("mod2|mod1"=coefs[1:2]))

coef(mod2)
coefplot(mod2, fill = TRUE)

# Is there an update method for the LHS of an mlm?

update(mod2, read ~ .)
update(mod2, math ~ .)

update(mod1, cbind(read, math, antisoc, hyperact) ~ .)


