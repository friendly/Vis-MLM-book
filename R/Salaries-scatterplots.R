library(ggplot2)
library(car)
library(dplyr)
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

# show loess, ditch se bands for linear 
gg1 + 
  geom_smooth(method = "loess", formula = "y ~ x", 
              color = "blue", fill = scales::muted("blue"),
              linewidth = 2) +
  geom_smooth(method = "lm", formula = "y ~ x", se = FALSE,
              color = "red",
              linewidth = 2) +
  geom_smooth(method = "lm", formula = "y ~ poly(x,2)", 
              color = "darkgreen", fill = "lightgreen",
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


# make some re-useable pieces to avoid repetitions
scale_salary <-   scale_y_continuous(
  labels = scales::dollar_format(prefix="$", 
                                 scale = 0.001, 
                                 suffix = "K")) 
# position the legend inside the plot
legend_pos <- theme(legend.position = c(.1, 0.95), 
                    legend.justification = c(0, 1))


# color by: rank
gg2 <-
ggplot(Salaries, 
             aes(x = yrs.since.phd, y = salary, color = rank)) +
  geom_point() +
  scale_salary +
  labs(x = "Years since PhD",
       y = "Salary") +
  geom_smooth(aes(fill = rank),
                  method = "loess", formula = "y ~ x", 
                  linewidth = 2) + 
  theme_bw(base_size = 14) +
  legend_pos

gg2

Salaries |>
  mutate(discipline = factor(discipline, 
                             labels = c("A: Theoretical", "B: Applied"))) |>
  ggplot(aes(x = yrs.since.phd, y = salary, color = discipline)) +
    geom_point() +
  scale_salary +
  geom_smooth(aes(fill = discipline ),
                method = "loess", formula = "y ~ x", 
                linewidth = 2) + 
  labs(x = "Years since PhD",
       y = "Salary") +
  
  theme_bw(base_size = 14) +
  legend_pos 

# avoid labels?

Salaries |>
  group_by(discipline) |>
  summarize(mean = mean(salary)) 

Salaries |>
  group_by(discipline, rank) |>
  summarize(mean = mean(salary)) |>
  spread()


# faceting
Salaries <- Salaries |>
  mutate(discipline = factor(discipline, 
                             labels = c("A: Theoretical", "B: Applied")))

Salaries |>
  ggplot(aes(x = yrs.since.phd, y = salary, color = rank)) +
  geom_point() +
  scale_salary +
  labs(x = "Years since PhD",
       y = "Salary") +
  geom_smooth(aes(fill = rank),
              method = "lm", formula = "y ~ x", 
              linewidth = 2) +
  facet_wrap(~ discipline) +
  theme_bw(base_size = 14) + 
  legend_pos
  
# rank x discipline x sex

Salaries |>
  ggplot(aes(x = yrs.since.phd, y = salary, color = sex)) +
  geom_point() +
  scale_salary +
  labs(x = "Years since PhD",
       y = "Salary") +
  geom_smooth(aes(fill = sex),
              method = "lm", formula = "y ~ x", se=FALSE,
              linewidth = 2) +
  facet_grid(rank ~ discipline) +
  theme_bw(base_size = 14) + 
  theme(legend.position = "top")

Salaries |>
  ggplot(aes(x = yrs.since.phd, y = salary, color = sex)) +
  geom_point() +
  scale_salary +
  labs(x = "Years since PhD",
       y = "Salary") +
  geom_smooth(aes(fill = sex),
              method = "lm", formula = "y ~ x", se=FALSE,
              linewidth = 2) +
  facet_grid(discipline ~ rank) +
  theme_bw(base_size = 14) + 
  theme(legend.position = "top")
