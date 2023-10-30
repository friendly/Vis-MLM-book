library(ggplot2)
library(car)
data(Salaries, package="carData")

# simple scatterplot
gg1 <-ggplot(Salaries, 
       aes(x = yrs.since.phd, y = salary)) +
  geom_jitter(size = 2) +
  scale_y_continuous(labels = scales::dollar_format(
    prefix="$", scale = 0.001, suffix = "K")) +
  labs(x = "Years since PhD",
       y = "Salary") +
  theme_bw(base_size = 14) 
gg1

# show just linear & quadratic
gg1 + 
  geom_smooth(method = "lm", formula = "y ~ x", 
              color = "red", fill= "red",
              linewidth = 2) +
  geom_smooth(method = "lm", formula = "y ~ poly(x,2)", 
              color = "darkgreen", fill = "darkgreen",
              linewidth = 2) 

# show loess, ditch se bands for linear & quadratic
gg1 + 
  geom_smooth(method = "loess", formula = "y ~ x", 
              color = "blue", fill = "blue",
              linewidth = 2) +
  geom_smooth(method = "lm", formula = "y ~ x", se = FALSE,
              color = "red",
              linewidth = 2) +
  geom_smooth(method = "lm", formula = "y ~ poly(x,2)", se = FALSE,
              color = "darkgreen",
              linewidth = 2) 



gg1 + 
  geom_smooth(fill = "blue", linewidth = 3) +
  geom_smooth(method = "lm", formula = "y ~ x", 
              color = "red", se = FALSE,
              linewidth = 2) +
  geom_smooth(method = "lm", formula = "y ~ poly(x,2)", 
              color = "darkgreen", se = FALSE,
              linewidth = 2) 

# make some re-useable pieces
sm1 <- geom_smooth(method = "loess", linewidth = 3)
sm2 <- geom_smooth(method = "lm", formula = "y ~ x", 
                   color = "red", se = FALSE,
                   linewidth = 2) 
sm3 <- geom_smooth(method = "lm", formula = "y ~ poly(x,2)", 
                   color = "darkgreen", se = FALSE,
                   linewidth = 2) 
legend <- theme(legend.position = c(.1, 0.95), 
                legend.justification = c(0, 1))



# color by: rank
gg2 <-ggplot(Salaries, 
             aes(x = yrs.since.phd, y = salary, color = rank)) +
  geom_point() +
  scale_y_continuous(labels = scales::dollar_format(
    prefix="$", scale = 0.001, suffix = "K")) +
  labs(x = "Years since PhD",
       y = "Salary") +
  theme_bw(base_size = 14) +
  theme(legend.position = "top")
gg2

gg2 + geom_smooth(aes(fill = rank),
                  method = "lm", formula = "y ~ poly(x,2)", 
                  linewidth = 2) + 
  legend


gg2 + legend

gg3 <-ggplot(Salaries, 
             aes(x = yrs.since.phd, y = salary, color = discipline)) +
  geom_point() +
  scale_y_continuous(labels = scales::dollar_format(
    prefix="$", scale = 0.001, suffix = "K")) +
  labs(x = "Years since PhD",
       y = "Salary") +
  theme_bw(base_size = 14) +
  theme(legend.position = "top")
gg3



