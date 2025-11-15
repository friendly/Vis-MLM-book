#' ---
#' title: discriminant analysis demo
#' author: Michael Friendly
#' ---

# https://gist.github.com/friendly/7cd853ced1eeae3b3a91b64205163743

library(MASS)
library(ggplot2)
#library(candisc)
library(dplyr)

# Parameters: two groups with different means, but same covariance matrix
set.seed(1234)
n <- 100
mu1 <- c(3,4)
mu2 <- c(6,2)
Sigma <- matrix(c(2, 1, 1, 2), 2,2)

# create the two datasets
X1 <- mvrnorm(n, mu1, Sigma) |>
  as.data.frame() |>
  setNames(nm = c("y1", "y2")) |>
  cbind(group = "A")

X2 <- mvrnorm(n, mu2, Sigma) |>
  as.data.frame() |>
  setNames(nm = c("y1", "y2")) |>
  cbind(group = "B")

X <- rbind(X1, X2)

# get the sample means for use in plots
means <- X |>
  summarise(y1 = mean(y1),
            y2 = mean(y2), .by = group)
means_wide <- means |>
  pivot_wider(names_from  = group, 
              values_from = y1:y2,
              names_vary = "slowest")

means_all <- X |>
  summarise(y1 = mean(y1),
            y2 = mean(y2))
  
# --------------------------------------
# Plot 1: scatterplot with data ellipses
# --------------------------------------
ggplot(data = X, 
       aes(y1, y2, 
           color = group, shape = group, fill = group)) +
  geom_point(size = 2, alpha = 0.8) +
  geom_point(data = means,
             shape = "+", size = 10, color = "black") +
  geom_text(data = means,
            aes(label = group),
            size = 8,
            color = "black",
            nudge_y = 0.5) +
  stat_ellipse(geom = "polygon", alpha = 0.3, level = 0.68) +
  geom_segment(data = means_wide,
               aes(x = y1_A,  y = y2_A,
                   xend = y1_B, yend = y2_B),
               inherit.aes = FALSE,
               linewidth = 2) +
  geom_point(data = means_all,
             aes(y1, y2),
             size = 3,
             inherit.aes = FALSE) +
  coord_equal() +
  theme_bw(base_size = 16) +
  theme(legend.position = "none") +
  theme(
    panel.background = element_rect(fill = "transparent"),
    plot.background = element_rect(fill = "transparent", color = NA)
  )

ggsave("images/discrim-demo1.png", 
       height = 6, width = 6,
       dpi = 200)


# -------------------------------------------
# plot 2 densities of the discriminant scores
# -------------------------------------------

X.lda <- lda(group ~ ., data = X)

X.pred <- predict_discrim(X.lda, scores = TRUE, post=FALSE)


# density plot of LD1
# 
meanLD <- X.pred |>
  select(group, LD1) |>
  summarize(LD1 = mean(LD1), .by = group)

ggplot(data = X.pred, 
       aes(x = LD1,
           color = group, shape = group, fill = group)) +
  geom_density(alpha = 0.3) + 
  geom_label(data = meanLD, 
             aes(label = group),
             y = .2,
             size = 8,
             color = "black") +
  theme_classic(base_size = 14) +
  theme(legend.position = "none") +
  theme(
    axis.title.y = element_blank(),
    axis.text.y = element_blank(),
    axis.ticks.y = element_blank(),
    panel.background = element_rect(fill = "transparent"),
    plot.background = element_rect(fill = "transparent", color = NA)
  )

ggsave("images/discrim-demo2.png", 
       height = 4.75, width = 15.25, units = "cm",
       dpi = 200)

# plot_discrim(X.lda, y2 ~ y1,
#              showgrid = "none", ellipse = TRUE) 