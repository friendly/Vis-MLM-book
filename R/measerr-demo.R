# simulation for measurement error
# from: https://statmodeling.stat.columbia.edu/2024/04/14/simulation-to-understand-measurement-error-in-regression/

library(car)
library(dplyr)
library(ggplot2)
library(forcats)
library(patchwork)

set.seed(123)
n <- 300

a <- 0.2    # true intercept
b <- 0.3    # true slope
sigma <- 0.5 # baseline error standard deviation

x <- runif(n, 0, 10)
y <- rnorm(n, a + b*x, sigma)
demo <- data.frame(x,y)

# add random normal errors to x and y around each point
err_y <- 1   # additional error stdev for y
err_x <- 4   # additional error stdev for x
demo  <- demo |>
  mutate(y_star = rnorm(n, y, err_y),
         x_star = rnorm(n, x, err_x))


fit_1 <- lm(y ~ x,           data = demo)   # no additional error
fit_2 <- lm(y_star ~ x,      data = demo)   # error in y
fit_3 <- lm(y ~ x_star,      data = demo)   # error in x
fit_4 <- lm(y_star ~ x_star, data = demo)   # error in x and y



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

#' Do this with ggplot

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
               alpha=0.05, linewidth = 1.1) +
  geom_smooth(method="lm", formula = y~x, fullrange=TRUE, level=0.995,
              color = "red", fill = "red", alpha = 0.2) +
  facet_wrap(~name) +
  theme_bw(base_size = 16)

# get coefficients and std. errors for models
model_stats <- df |>
  dplyr::nest_by(name) |>
  mutate(model = list(lm(y ~ x, data = data)),
         sigma = sigma(model),
         intercept = coef(model)[1],
         slope = coef(model)[2],
         r = sqrt(summary(model)$r.squared)) |>
  mutate(errX = stringr::str_detect(name, " x"),
         errY = stringr::str_detect(name, " y")) |>
  mutate(errX = factor(errX, levels = c("TRUE", "FALSE")),
         errY = factor(errY, levels = c("TRUE", "FALSE"))) |>
  relocate(errX, errY, r, .after = name) |>
  select(-data) |>
  print()

# mod_stats <- models |>
#   summarise(broom::glance(model), .groups = "keep") |>
#   select(name, r.squared, sigma) |>
#   mutate(errX = stringr::str_detect(name, " x"),
#          errY = stringr::str_detect(name, " y"),
#          r = sqrt(r.squared)) |>
#   relocate(errX, errY, r, .after = name) |>
#   print()

legend_inside <- function(position) {
  theme(legend.position = "inside",
        legend.position.inside = position)
}

p1 <- ggplot(data=model_stats, 
             aes(x = errX, y = r, 
                 group = errY, color = errY, 
                 shape = errY, linetype = errY)) +
  geom_point(size = 4) +
  geom_line(linewidth = 1.2) +
  labs(x = "Error on X?",
       y = "Model R ",
       color = "Error on Y?",
       shape = "Error on Y?",
       linetype = "Error on Y?") +
  theme_bw(base_size = 16) +
  legend_inside(c(0.2, 0.9))

p2 <- ggplot(data=model_stats, 
             aes(x = errX, y = sigma, 
                 group = errY, color = errY, 
                 shape = errY, linetype = errY)) +
  geom_point(size = 4) +
  geom_line(linewidth = 1.2) +
  labs(x = "Error on X?",
       y = "Model residual standard error",
       color = "Error on Y?",
       shape = "Error on Y?",
       linetype = "Error on Y?") +
  theme_bw(base_size = 16) +
  legend_inside(c(0.8, 0.9))

p1 + p2

# view in beta space

confidenceEllipse(fit_1, col = "black", 
                  xlim = c(-.25, 1.5), ylim = c(0, .4))
confidenceEllipse(fit_2, col = "blue", add = TRUE)
confidenceEllipse(fit_3, col = "red", add = TRUE)
confidenceEllipse(fit_4, col = "purple", add = TRUE)

labs <- tibble::tribble(
  ~x, ~y, ~label, ~color,
  .244, .25, "No X error", "black",
  1.22, .06, "X error", "red",
  -.03, .39, "Y error", "blue",
  1.0,  .17, "Y error", "purple"
)

with(labs, text(x, y, label, col = color, cex = 1.4))




