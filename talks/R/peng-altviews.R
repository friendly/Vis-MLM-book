#' ---
#' title: Penguin bills as length & depth vs. size & shape, for the talk
#' ---

# The two panels of Fig. 3 of the blog post "Thinking about Penguin Variables"
# (friendly.github.io/blog/posts/2026-10-peng-altviews/, from R/penguin/peng-bill-size-shape-altviews.qmd),
# drawn as separate images so the slide can reveal the size & shape view after the length & depth one.
# Run from the project root.

library(dplyr)
library(ggplot2)

data(peng, package = "heplots")
source("R/penguin/penguin-colors.R")

peng <- peng |>
  mutate(log_size  = log(bill_length) + log(bill_depth),
         log_shape = log(bill_length) - log(bill_depth))

peng_cols <- peng.colors("dark")
theme_set(theme_bw(base_size = 18))

# points, 68% and 95% data ellipses, within-species regression lines, the pooled line (dashed),
# and the species labeled at their means
peng_plot <- function(x, y) {
  means <- peng |>
    group_by(species) |>
    summarise(x = mean({{ x }}), y = mean({{ y }}))
  ggplot(peng, aes(x = {{ x }}, y = {{ y }}, color = species, shape = species, fill = species)) +
    geom_point(size = 2, alpha = 0.6) +
    stat_ellipse(geom = "polygon", level = 0.68, alpha = 0.15) +
    stat_ellipse(geom = "polygon", level = 0.95, alpha = 0.10) +
    geom_smooth(method = "lm", formula = y ~ x, se = FALSE, linewidth = 1.5) +
    geom_smooth(aes(x = {{ x }}, y = {{ y }}), inherit.aes = FALSE,
                method = "lm", formula = y ~ x, se = FALSE,
                color = "black", linetype = "dashed", linewidth = 1) +
    geom_label(data = means, aes(x = x, y = y, label = species, color = species),
               fill = "white", alpha = 0.75, size = 6, fontface = "bold", inherit.aes = FALSE) +
    scale_color_manual(values = peng_cols, aesthetics = c("colour", "fill")) +
    theme(legend.position = "none")
}

p1 <- peng_plot(bill_length, bill_depth) +
  labs(x = "Bill length (mm)", y = "Bill depth (mm)", title = "Length & depth")
ggsave("talks/images/peng-altviews-1-length-depth.png", p1, width = 6, height = 6, dpi = 300, bg = "white")

p2 <- peng_plot(log_size, log_shape) +
  labs(x = "log Size = log(L x D)", y = "log Shape = log(L / D)", title = "Size & shape")
ggsave("talks/images/peng-altviews-2-size-shape.png", p2, width = 6, height = 6, dpi = 300, bg = "white")
