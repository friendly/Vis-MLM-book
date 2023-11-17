library(ggplot2)
library(patchwork)
library(datasets)
library(tidyverse)

data(anscombe)

ggplot2:: theme_set(theme_bw(base_size = 16))
col <- "blue"


p1 <- ggplot(anscombe, aes(x = x1, y = y1)) +
  geom_point(color = "blue", size = 4) +
  geom_smooth(method = "lm", formula = y ~ x, se = FALSE,
              color = "red", linewidth = 1.5) +
  scale_x_continuous(breaks = seq(0,20,2)) +
  scale_y_continuous(breaks = seq(0,12,2)) +
  stat_ellipse(level = 0.5, color="blue", type = "norm") +
  labs(title = "Dataset 1" ) +
  theme_bw(base_size = 14)
p1

p2 <- ggplot(anscombe, aes(x = x2, y = y2)) +
  geom_point(color = "blue", size = 4) +
  geom_smooth(method = "lm", formula = y ~ x, se = FALSE,
              color = "red", linewidth = 1.5) +
  scale_x_continuous(breaks = seq(0,20,2)) +
  scale_y_continuous(breaks = seq(0,12,2)) +
  stat_ellipse(level = 0.5, color="blue", type = "norm") +
  labs(title = "Dataset 2" ) +
  theme_bw(base_size = 14)
p2


p3 <- ggplot(anscombe, aes(x = x3, y = y3)) +
  geom_point(color = "blue", size = 4) +
  geom_smooth(method = "lm", formula = y ~ x, se = FALSE,
              color = "red", linewidth = 1.5) +
  scale_x_continuous(breaks = seq(0,20,2)) +
  scale_y_continuous(breaks = seq(0,12,2)) +
  stat_ellipse(level = 0.5, color="blue", type = "norm") +
  labs(title = "Dataset 3" ) +
  theme_bw(base_size = 14)
p3

p4 <- ggplot(anscombe, aes(x = x4, y = y4)) +
  geom_point(color = "blue", size = 4) +
  geom_smooth(method = "lm", formula = y ~ x, se = FALSE,
              color = "red", linewidth = 1.5) +
  scale_x_continuous(breaks = seq(0,20,2)) +
  scale_y_continuous(breaks = seq(0,12,2)) +
  stat_ellipse(level = 0.5, color="blue", type = "norm") +
  labs(title = "Dataset 4" ) +
  theme_bw(base_size = 14)
p4

(p1 + p2) / (p3 + p4)

# reshape to long

library(dplyr)
library(tidyr)
anscombe_long <- anscombe |> 
  pivot_longer(everything(), 
               names_to = c(".value", "dataset"), 
               names_pattern = "(.)(.)"
  ) |>
  arrange(dataset)

anscombe_long |>
  group_by(dataset) |>
  summarise(xbar = mean(x),
         ybar      = mean(y),
         r         = cor(x, y),
         intercept = coef(lm(y ~ x))[1],
         slope     = coef(lm(y ~ x))[2]
         )

#' Plot all together using facets

desc <- tibble(
  dataset = 1:4,
  label = c("Pure error", "Lack of fit", "Outlier", "Influence")
)

ggplot(anscombe_long, aes(x = x, y = y)) +
  geom_point(color = "blue", size = 4) +
  geom_smooth(method = "lm", formula = y ~ x, se = FALSE,
              color = "red", linewidth = 1.5) +
  scale_x_continuous(breaks = seq(0,20,2)) +
  scale_y_continuous(breaks = seq(0,12,2)) +
  stat_ellipse(level = 0.5, color=col, type="norm") +
  geom_label(data=desc, aes(label = label), x=6, y=12) +
  facet_wrap(~dataset, labeller = label_both) +
  theme(panel.grid.major = element_blank(), 
        panel.grid.minor = element_blank())




# show result omitting each point in turn ??
ggplot(anscombe_long, aes(x = x, y = y)) +
  geom_point(color = "blue", size = 4) +
  lapply(seq(nrow(anscombe_long)), function(i) {
    geom_smooth(
      data = anscombe_long[-i, ],
      method = "lm", formula = y ~ x, se = FALSE,
      color = "grey", linewidth = 1.1
    )
  }) +
  geom_smooth(
    method = "lm", formula = y ~ x, se = FALSE,
    color = "red", linewidth = 1.5
  ) +
  facet_wrap(~dataset, labeller = label_both) +
  theme_bw(base_size = 14)

