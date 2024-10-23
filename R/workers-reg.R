#' ---
#' title: Workers data - regression models
#' ---
#' 

library(car)
library(ggplot2)
library(heplots)

data(workers, package = "matlib")
str(workers)


mod1 <- lm(Income ~ Experience, data=workers)
mod2 <- lm(Income ~ poly(Experience, 2), data=workers)
mod3 <- lm(Income ~ Experience + Skill, data=workers)
mod4 <- lm(Income ~ Gender, data = workers)
mod5 <- lm(Income ~ Experience + Gender, data = workers)
mod6 <- lm(Income ~ Experience * Gender, data = workers)

theme_set(theme_bw(base_size = 14))

p1 <- ggplot(data = workers,
             aes(x = Experience, y = Income)) +
  geom_point(size = 2.5) 
p1

# mod1
p2 <- p1 + 
  geom_smooth(method = "lm", formula = y~x,
              color = "red", fill = "red", alpha = 0.2)
p2

# mod2
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
