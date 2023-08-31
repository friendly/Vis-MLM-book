#' ---
#' title: Leverage and influence demo
#' ---
library(tidyverse)

#' ## Four copies of the same data set
set.seed(42)
N <- 15
case_labels <- paste(1:4, c("OK", "Outlier", "Leverage", "Influence"))
levdemo <- tibble(
	case = rep(case_labels, 
	           each = N),
	x = rep(round(40 + 20 * runif(N), 1), 4),
	y = rep(round(10 + .75 * x + rnorm(N, 0, 1.25), 4)),
	id = " "
)

mod <- lm(y ~ x, data=levdemo)
coef(mod)

#' Add one more point to illustrate different cases
extra <- tibble(
  case = case_labels,
  x  = c(65, 52, 75, 70),
  y  = c(NA, 65, 65, 40),
  id = c("  ", "O", "L", "OL")
)

#' Join these to the data
both <- bind_rows(levdemo, extra) |>
  mutate(case = factor(case))

#' ## Plot in separate panels
#' 
ggplot(levdemo, aes(x = x, y = y)) +
  geom_point(color = "blue", size = 2) +
  geom_smooth(data=both, 
              method = "lm", formula = y ~ x, se = FALSE,
              color = "red", linewidth = 1.3, linetype = 1) +
  geom_smooth(method = "lm", formula = y ~ x, se = FALSE,
              color = "blue", linewidth = 1, linetype = "longdash" ) +
  stat_ellipse(data = both, level = 0.5, color="blue", type="norm", linewidth = 1.4) +
  geom_point(data=extra, color = "red", size = 4) +
  geom_text(data=extra, aes(label = id), nudge_x = -2, size = 5) +
  facet_wrap(~case, labeller = label_both) +
  theme_bw(base_size = 14)
  

#' ## Draw the data ellipses, superimposed.
#' (Why doesn't this give what I want?)
ggplot(levdemo, aes(x = x, y = y, color = case)) +
  geom_point(color = "blue", size = 2) +
  geom_point(data=extra, color = "red", size = 4) +
  stat_ellipse(data = both, level = 0.5)


library(car) # needs: car 3.1.4

# Try to override car internal label.ellipse -- doesn't work
# label.ellipse <- heplots::label.ellipse
#fixInNamespace(label.ellipse, "car")

#source("C:/Dropbox/R/functions/Ellipse.R")
# rlang::env_unlock(env = asNamespace('car'))
# rlang::env_binding_unlock(env = asNamespace('car'))
# assign('dataEllipse', dataEllipse, envir = asNamespace('car'))
# rlang::env_binding_lock(env = asNamespace('car'))
# rlang::env_lock(asNamespace('car'))

colors <- c("black", "blue", "darkgreen", "red")
with(both,
     {dataEllipse(x, y, groups = case, 
          levels = 0.68,
          plot.points = FALSE, add = FALSE,
          center.pch = "+",
          col = colors,
          fill = TRUE, fill.alpha = 0.1
 #         label.pos = c(0, 4, 4, 1)  # would like to specify these
          )
     })

case1 <- both |> filter(case == "1 OK")
points(case1[, c("x", "y")], cex=1)

points(extra[, c("x", "y")], 
       col = colors,
       pch = 16, cex = 2)

text(extra[, c("x", "y")],
     labels = extra$id,
     col = colors, pos = 2, offset = 0.5)

#' ## Beta space: confidence ellipses

library(purrr)
library(broom)

models <- both |>
  nest(data = -case) |>
  mutate(model = map(data, ~lm(y ~ x, data = .)))

for (i in 1:4) {
  confidenceEllipse(models$model[[i]],
                    col = colors[i],
                    levels = 0.5,
                    add = if (i==1) FALSE else TRUE,
                    fill = TRUE, fill.alpha = 0.1,
                    xlim = c(0, 50),
                    ylim = c(0, 1))
}


confidenceEllipse(models$model[[1]], col=colors[1], levels=0.5, xlim = c(0, 50), ylim = c(0.2, 1.2))
confidenceEllipse(models$model[[2]], col=colors[2], levels=0.5, xlim = c(0, 50), ylim = c(0.2, 1.2))
confidenceEllipse(models$model[[3]], col=colors[3], levels=0.5, xlim = c(0, 50))
confidenceEllipse(models$model[[4]], col=colors[4], levels=0.5, xlim = c(0, 50))
