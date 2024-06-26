#' ---
#' title: banknote data
#' ---

library(car)
library(dplyr)
library(ggbiplot)
library(ggplot2)
library(MASS)
library(heplots)
library(candisc)
library(broom)

data(banknote, package= "mclust")

# violin plot

banknote |>
  tidyr::gather(key = "measure", 
                value = "Size", 
                Length:Diagonal) |> 
  mutate(measure = factor(measure, 
                          levels = c(names(banknote)[-1]))) |> 

  ggplot(aes(x = Status, y = Size, color = Status)) +
  geom_violin(aes(fill = Status), alpha = 0.2) +
  geom_jitter(width = .2, size = 1.2) +
  geom_boxplot(width = 0.25, 
               linewidth=1.1, 
               color = "black", 
               alpha = 0.5) +
  labs(y = "Size (mm)") +
  facet_wrap( ~ measure, scales = "free", labeller = label_both) +
  theme_bw(base_size = 14) +
  theme(legend.position = "top")
  


banknote.pca <- prcomp(banknote[, -1], scale = TRUE)
summary(banknote.pca)

banknote.pca <- reflect(banknote.pca)
ggbiplot(banknote.pca,
   obs.scale = 1, var.scale = 1,
   groups = banknote$Status,
   ellipse = TRUE, 
   ellipse.level = 0.5, 
   ellipse.alpha = 0.1, ellipse.linewidth = 0,
   varname.size = 4,
   varname.color = "black") +
  labs(fill = "Status", color = "Status") +
  theme_minimal(base_size = 14) +
  theme(legend.direction = 'horizontal', legend.position = 'top')


#' MANOVA
#' 

banknote.mlm <- lm(cbind(Length, Left, Right, Bottom, Top, Diagonal) ~ Status,
                    data = banknote)
Anova(banknote.mlm)

# see all test statistics
summary(Anova(banknote.mlm)) |> print(SSP = FALSE)

#summary(Anova(banknote.mlm), univariate=TRUE)

heplots::etasq(banknote.mlm)

# univariate t tests
broom::tidy(banknote.mlm) |> 
  filter(term != "(Intercept)") |>
  rename(t = statistic)

# Univariate F tests
broom::tidy(banknote.mlm) |> 
  filter(term != "(Intercept)") |>
  dplyr::select(-term) |>
  rename(t = statistic) |>
  mutate(F = t^2) |>
  relocate(F, .after = t)


#' Discriminant analysis
banknote.lda <- lda(Status ~ Length + Left + Right + Bottom + Top + Diagonal,
                    data = banknote)
banknote.lda

plot(banknote.lda, dimen=1)


scores <- as.matrix(banknote[, -1]) %*% banknote.lda$scaling
boxplot(scores ~ banknote$Status)

fit <- predict(banknote.lda) |> as.data.frame()
boxplot(LD1 ~ class, data=fit)

banknote.mlm <- lm(cbind(Length, Left, Right, Bottom, Top, Diagonal) ~ Status,
                   data=banknote)

pairs(banknote.mlm)

banknote.can <- candisc(banknote.mlm)
banknote.can

plot(banknote.can)
