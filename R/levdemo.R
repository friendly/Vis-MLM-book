library(tidyverse)

set.seed(42)
levdemo <- tibble(
	case = rep(0:3, each = 20),
	x = rep(round(40 + 10 * runif(20), 1), 4),
	y = rep(round(10 + .75 * x + rnorm(20, 0, 2.5), 4)),
	id = " "
)

extra <- tibble(
  case = 0:3,
  x  = c(65, 40, 88, 88),
  y  = c(NA, 71, 71, 21),
  id = c("  ", "O_", "_L", "OL")
)


levdemo <- bind_rows(levdemo, extra) 
levdemo <- levedemo |>
  mutate(
    id = case_when(
          case == 0, ~ "  ",
          case == 1, ~ "O ",
          case == 2, ~ " L",
          case == 3, ~ "OL")
  )
  arrange(case)

ggplot(levdemo, aes(x = x, y = y)) +
  geom_point(color = "blue", size = 3) +
  geom_smooth(method = "lm", formula = y ~ x, se = FALSE,
              color = "red", linewidth = 1.5) +
  stat_ellipse(level = 0.5, color="blue", type="norm") +
  geom_label(data=extra, aes(label = id), x=40, y=30) +
  facet_wrap(~case, labeller = label_both, scales = "free") 
  

