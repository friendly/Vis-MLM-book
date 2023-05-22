# How to plot leave-one-out regression lines with ggplot / tidyverse

I'd like to use `ggplot` to plot a regression line and also show the regression lines resulting
from omitting each of the observations in turn.

```
data(anscombe)

ggplot(anscombe, aes(x = x2, y = y2)) +
  geom_point(color = col, size = 4) +
  geom_smooth(method = "lm", formula = y ~ x, se = FALSE,
              color = "red", linewidth = 1.5) +
  labs(title = "Dataset 1" ) +
  theme_bw(base_size = 14)
```

I can do what I want manually, but it is very clunky. There is probably a tidyverse solution,
but I can't think of it.

```
ggplot(anscombe, aes(x = x2, y = y2)) +
  geom_point(color = col, size = 4) +
  geom_smooth(data = anscombe |> slice(-1), method = "lm", formula = y ~ x, se = FALSE, color = "grey") +
  geom_smooth(data = anscombe |> slice(-2), method = "lm", formula = y ~ x, se = FALSE, color = "grey") +
  geom_smooth(data = anscombe |> slice(-10), method = "lm", formula = y ~ x, se = FALSE, color = "grey") +
  geom_smooth(data = anscombe |> slice(-11), method = "lm", formula = y ~ x, se = FALSE, color = "grey") +
  geom_smooth(method = "lm", formula = y ~ x, se = FALSE,
              color = "red", linewidth = 1.5) +
  labs(title = "Dataset 2" ) +
  theme_bw(base_size = 14)
```
