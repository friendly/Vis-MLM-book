#' ---
#' title: Workers data - regression models
#' ---
#' 

library(car)
library(ggplot2)
library(heplots)

data(workers, package = "matlib")
str(workers)


workers.mod1 <- lm(Income ~ Experience, data=workers)
workers.mod2 <- lm(Income ~ poly(Experience, 2), data=workers)

coef(workers.mod1)
coef(workers.mod2)

equatiomatic::extract_eq(workers.mod1, use_coefs = TRUE)
equatiomatic::extract_eq(workers.mod2, use_coefs = TRUE)

# to get interpretable coefficients, use centered values
workers <- workers |>
  mutate(Exp_centered = Experience - mean(Experience))
workers.mod2a <- lm(Income ~ Exp_centered + I(Exp_centered^2), data=workers)
coef(workers.mod2a)

equatiomatic::extract_eq(workers.mod2a, use_coefs = TRUE)

# to get interpretable coefficients, use raw=TRUE
workers.mod2b <- lm(Income ~ poly(Experience, 2, raw = TRUE), data=workers)
coef(workers.mod2b)
equatiomatic::extract_eq(workers.mod2b, use_coefs = TRUE, coef_digits = 3)


anova(workers.mod1, workers.mod2)

mod3 <- lm(Income ~ Experience + Skill, data=workers)
mod4 <- lm(Income ~ Gender, data = workers)
mod5 <- lm(Income ~ Experience + Gender, data = workers)
mod6 <- lm(Income ~ Experience * Gender, data = workers)

theme_set(theme_bw(base_size = 14))

ggplot(data = workers,
       aes(x = Experience, y = Income)) +
  geom_point(size = 3) +
  geom_smooth(method = "lm", formula = y~x,
              se = FALSE, linewidth = 2,
              color = "blue") +
  geom_smooth(method = "lm", formula = y ~ poly(x,2),
              se = FALSE, linewidth = 2,
              color = "red") 


# separate plots
p1 <- ggplot(data = workers,
             aes(x = Experience, y = Income)) +
  geom_point(size = 2.5) 
p1

# workers.mod1
p2 <- p1 + 
  geom_smooth(method = "lm", formula = y~x,
              color = "red", fill = "red", alpha = 0.2)
p2

# workers.mod2
p1 + 
  geom_smooth(method = "lm", formula = y ~ x,
              color = "red", se = FALSE) +
  geom_smooth(method = "lm", formula = y ~ poly(x,2),
              color = "black") 

# mod4
ggplot(data = workers,
       aes(x = Gender, y = Income)) +
  geom_boxplot(alpha = 0.3) +
  geom_jitter(size = 2, width = 0.2) +
  stat_summary(fun=mean, geom="line",
               aes(group = 1), 
               color = "red",
               linewidth = 2)

df5 <- cbind(workers, fit = predict(mod5))
ggplot(data = df5,
       aes(x = Experience, y = Income, color = Gender)) +
  geom_point(size = 2.5) +
  geom_line(aes(y = fit), linewidth = 1.5) +
  theme(legend.position = "inside",
        legend.position.inside = c(0.8, 0.2))

# mod6
ggplot(data = workers,
       aes(x = Experience, y = Income, color = Gender)) +
  geom_point(size = 2.5) +
  geom_smooth(aes(color = Gender),
              method = "lm", formula = y~x, se = FALSE,
              linewidth = 1.5) +
  theme(legend.position = "inside",
        legend.position.inside = c(0.8, 0.2))


# mod3
with(workers, 
     {scatter3d(x = Experience, 
                y = Income, 
                z = Skill,
                fit = "linear")})  
