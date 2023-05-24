#' ---
#' title: Leverage and influence demo
#' ---
library(tidyverse)

#' Four copies of the same data set
set.seed(42)
N <- 15
case_labels <- paste(1:4, c("OK", "Outlier", "Leverage", "Influence"))
levdemo <- tibble(
	case = rep(case_labels, 
	           each = N),
	x = rep(round(40 + 20 * runif(N), 1), 4),
	y = rep(round(10 + .75 * x + rnorm(N, 0, 2.5), 4)),
	id = " "
)

mod <- lm(y ~ x, data=levdemo)
coef(mod)

#' Add one more point to illustrate different cases
extra <- tibble(
  case = case_labels,
  x  = c(65, 52, 62, 64),
  y  = c(NA, 61, 57, 40),
  id = c("  ", "O_", "_L", "OL")
)


both <- bind_rows(levdemo, extra) 

ggplot(levdemo, aes(x = x, y = y)) +
  geom_point(color = "blue", size = 2) +
  geom_smooth(method = "lm", formula = y ~ x, se = FALSE,
              color = "blue", linewidth = 1, ) +
  stat_ellipse(level = 0.5, color="blue", type="norm") +
  geom_point(data=extra, color = "red", size = 4) +
  geom_smooth(data=both, 
              method = "lm", formula = y ~ x, se = FALSE,
              color = "red", linewidth = 1.1, linetype = 2) +
#  geom_text(data=extra, aes(label = id), nudge_y = -2, size = 5) +
  facet_wrap(~case, labeller = label_both) 
  

