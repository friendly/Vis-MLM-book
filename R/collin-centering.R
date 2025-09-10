#' ---
#' title: demonstrate effect of centering
#' ---

library(ggplot2)
library(patchwork)
x <- 1:20
y1 <- x^2
y2 <- (x - mean(x))^2
XY <- data.frame(x, y1, y2)

R <- cor(XY)


r1 <- R[1, 2]
r2 <- R[1, 3]

gg1 <-
ggplot(XY, aes(x = x, y = y1)) +
  geom_point(size = 4) +
  geom_smooth(method = "lm", formula = y~x, 
              linewidth = 2, se = FALSE) +
  labs(x = "X", y = "Y") +
  theme_bw(base_size = 16) +
  annotate("text", x = 5, y = 350, size = 7,
           label = paste("X Uncentered\nr =", round(r1, 3)))

gg2 <-
  ggplot(XY, aes(x = x, y = y2)) +
  geom_point(size = 4) +
  geom_smooth(method = "lm", formula = y~x, 
              linewidth = 2, se = FALSE) +
  labs(x = "X", y = "Y") +
  theme_bw(base_size = 16) +
  annotate("text", x = 5, y = 80, size = 7,
           label = paste("X Centered\nr =", round(r2, 3)))

gg1 + gg2

# coefficients more interpretable with centering
# 

m1 <- lm(y1 ~ x, data = XY)
coef(m1)

# or
lm(y1 ~ x, data = XY) |> coef()

m2 <- lm(y2 ~ x, data = XY)
coef(m2) |> zapsmall()

# or
lm(y2 ~ x, data = XY) |> coef() |> zapsmall()

