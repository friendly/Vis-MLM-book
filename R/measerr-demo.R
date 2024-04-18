# simulation for measurement error
# from: https://statmodeling.stat.columbia.edu/2024/04/14/simulation-to-understand-measurement-error-in-regression/

#library("arm")
library(car)
library(dplyr)
library(ggplot2)
library(forcats)

set.seed(123)
n <- 500

a <- 0.2    # true intercept
b <- 0.3    # true slope

sigma <- 0.5 # baseline error standard deviation
err_y <- 1   # additional error stdev for y
err_x <- 4   # additional error stdev for x

x <- runif(n, 0, 10)
y <- rnorm(n, a + b*x, sigma)
demo <- data.frame(x,y)

# add random normal errors to x and y around each point
demo  <- demo |>
  mutate(y_star = rnorm(n, y, err_y),
         x_star = rnorm(n, x, err_x))


fit_1 <- lm(y ~ x,           data = demo)
fit_2 <- lm(y_star ~ x,      data=demo)
fit_3 <- lm(y ~ x_star,      data=demo)
fit_4 <- lm(y_star ~ x_star, data=demo)



# use a function to plot data & data ellipses

x_range <- range(demo$x, demo$x_star)
y_range <- range(demo$y, demo$y_star)

library(car)
demo_plot <- function(x, y, fit, title) {
  dataEllipse(x, y,
              xlim=x_range, ylim=y_range, 
              pch=20, levels = 0.9,
              main = title)
  abline(coef(fit), col="red", lwd=2)
}

op <- par(mfrow=c(2,2), 
          mar=c(3,3,1,1), 
          mgp=c(1.5,.5,0), tck=-.01)

demo_plot(demo$x, demo$y,           fit_1, "No measurement error")
demo_plot(demo$x, demo$y_star,      fit_2, "Measurement error on y")
demo_plot(demo$x_star, demo$y,      fit_3, "Measurement error on x")
demo_plot(demo$x_star, demo$y_star, fit_4, "Measurement error on x and y")
par(op)


# make long, with names for the four conditions
df <- bind_rows(
  data.frame(x=demo$x,      y=demo$y,      name="No measurement error"),
  data.frame(x=demo$x,      y=demo$y_star, name="Measurement error on y"),
  data.frame(x=demo$x_star, y=demo$y,      name="Measurement error on x"),
  data.frame(x=demo$x_star, y=demo$y_star, name="Measurement error on x and y")) |>
  mutate(name = fct_inorder(name)) 

ggplot(df, aes(x,y)) +
  geom_point(alpha = 0.2) +
  stat_ellipse(geom = "polygon", 
               color = "blue",fill= "blue", 
               alpha=0.1, linewidth = 1.1) +
  geom_smooth(method="lm", formula = y~x, fullrange=TRUE, level=0.995) +
  facet_wrap(~name) +
  theme_bw(base_size = 14)

# get coefficients and std. errors for models
models <- df |>
  dplyr::nest_by(name) |>
  mutate(model = list(lm(y ~ x, data = data)))

mod_stats <- models |>
  summarise(broom::glance(model), .groups = "keep") |>
  select(name, r.squared, sigma) |>
  mutate(errX = stringr::str_detect(name, " x"),
         errY = stringr::str_detect(name, " y")) |>
  relocate(errX, errY, .after = name) |>
  print()

ggplot(data=mod_stats, aes(x = errX, y = sqrt(r.squared), 
                           group = errY, color = errY, shape = errY)) +
  geom_point(size = 4) +
  geom_line(linewidth = 1.2) +
  labs(x = "Error on X?",
       y = "Model R squared",
       color = "Error on Y?",
       shape = "Error on Y?"
  ) +
  theme_bw(base_size = 14)



ggplot(data=mod_stats, aes(x = errX, y = sigma, 
                           group = errY, color = errY, shape = errY)) +
  geom_point(size = 4) +
  geom_line(linewidth = 1.2) +
  labs(x = "Error on X?",
     y = "Model residual standard error",
     color = "Error on Y?",
     shape = "Error on Y?"
) +
  theme_bw(base_size = 14)









  summarise(
    model = list(lm(y ~ x, data = data)),
    sigma = list(sigma(model))
  )
