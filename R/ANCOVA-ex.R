# ANCOVA example from: https://stats.stackexchange.com/questions/183026/r%C2%B2-of-ancova-mostly-driven-by-covariate

library(ggplot2)
library(patchwork)
library(dplyr)



# generate some toy data
set.seed(42)
n <- 60
pre_weight <- rnorm(n, mean = 150, sd = 10) 
error <- rnorm(n/2, sd = 10)
Group <- gl(2, k=n/2, labels = c("Control", "Treatment"))
post_weight <-  pre_weight + ifelse(Group == "Treatment", -10, 0) + error
post_weight2 <- post_weight + ifelse(Group == "Treatment", 0.6*(pre_weight-150), 0)

df <- data.frame(Group, pre_weight, post_weight, post_weight2)

df_mean <- df |> 
  group_by(Group) |> 
  summarise(across(c(pre_weight, post_weight, post_weight2), mean))

p1 <- ggplot(df, aes(y=post_weight, x=pre_weight, color = Group, fill = Group)) + 
  geom_point(size = 3) +
  stat_smooth(method = "lm", formula = y ~ x,
              linewidth = 2, alpha = 0.15) +
  geom_point(data = df_mean, shape = "+", size = 14, show.legend=FALSE) +
  labs(x = "Pre weight (x)", y = "Post weight (y)") +
  annotate(geom = "text", x = 123, y = 177, label = "(a)", size = 9) +
  theme_classic(base_size = 16) +
  theme(legend.position = "inside",
        legend.position.inside = c(.8, .2)) 
p1

p2 <- ggplot(df, aes(y=post_weight2, x=pre_weight, color = Group, fill = Group)) + 
  geom_point(size = 3) +
  stat_smooth(method = "lm", formula = y ~ x,
              linewidth = 2, alpha = 0.15) +
  geom_point(data = df_mean, shape = "+", size = 14, show.legend=FALSE) +
  labs(x = "Pre weight (x)", y = "Post weight (y)") +
  annotate(geom = "text", x = 123, y = 177, label = "(b)", size = 9) +
  theme_classic(base_size = 16) +
  theme(legend.position = "inside",
        legend.position.inside = c(.8, .2))
p2

p1 + p2



# test homogeneity of slopes: additional contribution of Group:pre_weight
m1 <- lm(post_weight ~ pre_weight + Group)
m2 <- lm(post_weight ~ pre_weight * Group)
anova(m1, m2)

# getting the sums squared for each effect using the Anova function from the car package
sstable <- car::Anova(lm(post_weight ~ pre_weight + Group), type = 3)
# partial eta squared:
sstable$pes <- c(sstable$'Sum Sq'[-nrow(sstable)], NA)/(sstable$'Sum Sq' + sstable$'Sum Sq'[nrow(sstable)]) # SS for each effect divided by the last SS (SS_residual)

sstable

library(equatiomatic)

df <- df |>
  rename(pre = pre_weight,
         post = post_weight,
         post2 = post_weight2)
# ANCOVA model
mod <- lm(post2 ~ Group + pre, data = df)
extract_eq(mod)

mod2 <- lm(post2 ~ Group * pre, data = df)
extract_eq(mod2)

