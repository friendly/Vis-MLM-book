library(ggplot2)
library(patchwork)
library(datasets)
data(anscombe)

col <- "blue"


p1 <- ggplot(anscombe, aes(x = x1, y = y1)) +
  geom_point(color = col, size = 4) +
  geom_smooth(method = "lm", formula = y ~ x, se = FALSE,
              color = "red", linewidth = 1.5) +
  scale_x_continuous(breaks = seq(0,20,2)) +
  scale_y_continuous(breaks = seq(0,12,2)) +
  labs(title = "Dataset 1" ) +
  theme_bw(base_size = 14)
p1

p2 <- ggplot(anscombe, aes(x = x2, y = y2)) +
  geom_point(color = col, size = 4) +
  geom_smooth(method = "lm", formula = y ~ x, se = FALSE,
              color = "red", linewidth = 1.5) +
  scale_x_continuous(breaks = seq(0,20,2)) +
  scale_y_continuous(breaks = seq(0,12,2)) +
  labs(title = "Dataset 2" ) +
  theme_bw(base_size = 14)
p2


p3 <- ggplot(anscombe, aes(x = x3, y = y3)) +
  geom_point(color = col, size = 4) +
  geom_smooth(method = "lm", formula = y ~ x, se = FALSE,
              color = "red", linewidth = 1.5) +
  scale_x_continuous(breaks = seq(0,20,2)) +
  scale_y_continuous(breaks = seq(0,12,2)) +
#  annotate("text", x = 5, y = 12.5, label = "Dataset 3", size = 8) +
  labs(title = "Dataset 3" ) +
  theme_bw(base_size = 14)
p3

p4 <- ggplot(anscombe, aes(x = x4, y = y4)) +
  geom_point(color = col, size = 4) +
  geom_smooth(method = "lm", formula = y ~ x, se = FALSE,
              color = "red", linewidth = 1.5) +
  scale_x_continuous(breaks = seq(0,20,2)) +
  scale_y_continuous(breaks = seq(0,12,2)) +
#  annotate("text", x = 6, y = 12, label = "Dataset 4", size = 8) +
  labs(title = "Dataset 4" ) +
  theme_bw(base_size = 14)
p4

(p1 + p2) / (p3 + p4)

# reshape to long

library(dplyr)
library(tidyr)
anscombe_long <- anscombe |> 
  pivot_longer(everything(), 
               names_to = c(".value", "set"), 
               names_pattern = "(.)(.)"
  ) |>
  arrange(set)

anscombe_long |>
  group_by(set) |>
  summarise(xbar = mean(x),
         ybar = mean(y),
         r = cor(x, y))
