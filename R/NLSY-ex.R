
library(heplots)
library(car)
library(ggplot2)
library(dplyr)
library(mvinfluence)
library(ggrepel)

data(NLSY, package = "heplots")

#examine the data
scatterplotMatrix(NLSY, smooth=FALSE)

ggplot2::theme_set(theme_bw(base_size = 14))

set.seed(47)
ggplot(NLSY, aes(x = read, y = math)) +
  geom_jitter()+
  geom_smooth(method = lm, formula = y~x, fill = "blue", alpha = 0.2) +
  geom_smooth(method = loess, se = FALSE, color = "red", linewidth = 2) +
  geom_rug()

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
  geom_rug() +
  facet_wrap(~variable, scales="free") +
  theme_bw(base_size = 14) +
  theme(legend.position = "none") 

# outliers?
res <- cqplot(NLSY, id.n = 4)
res
outliers <- rownames(res) |> as.numeric()


# pairwise scatterplots

xvars <- names(NLSY)[c(5, 6, 3, 4)]
yvars <- names(NLSY)[1:2]

NLSY_rect <- NLSY |>
  mutate(ID = row_number()) |>
  pivot_longer(cols = all_of(xvars), names_to = "xvar", values_to = "x") |>
  pivot_longer(cols = all_of(yvars), names_to = "yvar", values_to = "y") |>
  mutate(xvar = factor(xvar, xvars), yvar = factor(yvar, yvars))


ggplot(NLSY_rect, aes(x, y)) +
  geom_point(size = 1) +
  geom_smooth(method = "lm", se = FALSE, formula = y ~ x) +
  geom_smooth(method = "loess", se = FALSE, formula = y ~ x, color = "red") +
  stat_ellipse(geom = "polygon", 
               level = 0.95, fill = "blue", alpha = 0.2) +
  facet_grid(yvar ~ xvar, scales = "free") +
  labs(x = "predictor", y = "response") +
  theme_bw(base_size = 16) +
  geom_text_repel(data = NLSY_rect |> filter(ID %in% outliers), 
                  aes(label = ID))



mod0 <- lm(cbind(read, math) ~ log2(income) + educ + antisoc + hyperact, 
           data= NLSY |> filter(income != 0))


# test control variables by themselves
# -------------------------------------
NLSY.mod1 <- lm(cbind(read, math) ~ log2(income) + educ, 
           data= NLSY |> filter(income != 0))

anova(NLSY.mod1)  # Type I, sequential test
Anova(NLSY.mod1)  # Type II

coef(NLSY.mod1)
tidy(NLSY.mod1)

coefplot(NLSY.mod1, fill = TRUE,
         col = c("darkgreen", "brown"),
         lwd = 2,
         ylim = c(-0.5, 3),
         main = "Bivariate coefficient plot for reading and math\nwith 95% confidence ellipses")

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


# additional contribution of antisoc + hyperact over income + educ
# ----------------------------------------------------------------
# NLSY.mod2 <- lm(cbind(read,math) ~ antisoc + hyperact + log2(income) + educ, 
#            data = NLSY |> filter(income != 0))
# use update
NLSY.mod2 <- update(NLSY.mod1, . ~ . + antisoc + hyperact)
Anova(NLSY.mod2)

# test these jointly
coefs <- rownames(coef(NLSY.mod2))[-1] |> print()
linearHypothesis(NLSY.mod2, coefs[3:4], title = "NLSY.mod2 | NLSY.mod1") |>
  print(SSP = FALSE)

heplot(NLSY.mod2, fill=TRUE, 
       hypotheses=list("Overall"=coefs, "NLSY.mod2|NLSY.mod1"=coefs[1:2]))


linearHypothesis(NLSY.mod2, coefs, title = "Overall")

heplot(NLSY.mod2, fill=TRUE, hypotheses=list("NLSY.mod2|NLSY.mod1"=coefs[1:2]))

coef(NLSY.mod2)
coefplot(NLSY.mod2, fill = TRUE)

idx < cqplot(NLSY.mod2, id.n = 5)

# Influence

influencePlot(NLSY.mod2)


#-- robust methods

NLSY.rlm <-  heplots::robmlm(cbind(read,math) ~ antisoc + hyperact + log2(income) + educ, 
                data = NLSY |> filter(income != 0))
Anova(NLSY.rlm)

wts <- NLSY.rlm$weights
small <- wts < 0.1
sum(small)
ymax <- 1
plot(wts,
     ylim = c(-0.1, ymax),
     ylab = "Robust observation weight")
index <- seq_along(wts)
segments(index[small], wts[small], index[small], 1)
text(index[small], wts[small], 
     label= index[small], 
     pos = rep(c(1,3), length = length(index[small])), 
     xpd = TRUE)


# doesn't handle observation weights-- fix Mahalanobis?
cqplot(NLSY.rlm, id.n = 5)

library(candisc)

NLSY.can <- cancor(cbind(read,math) ~ antisoc + hyperact + log2(income) + educ, 
                   data = NLSY |> filter(income != 0)) |> 
  print()


# Is there an update method for the LHS of an mlm?

update(NLSY.mod2, read ~ .)
update(NLSY.mod2, math ~ .)

update(NLSY.mod1, cbind(read, math, antisoc, hyperact) ~ .)


library(equatiomatic)
extract_eq(NLSY.mod1)

