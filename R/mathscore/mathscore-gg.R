library(ggplot2)
data(mathscore, package = "heplots")

means <- mathscore |>
  group_by(group) |>
  summarize(BM = mean(BM), WP = mean(WP))


mathscore |>
  ggplot(aes(x = BM, y = WP, color = group, fill = group)) +
  stat_ellipse(level = 0.68, 
               geom="polygon",
               alpha = 0.1,
               show.legend = FALSE) +
  geom_point(size = 2) +
  geom_point(data=means, size = 16, shape = "+") +
  geom_text(data = means, aes(label = group), size = 8, nudge_y = 3, nudge_x = 3) +
  theme_bw(base_size = 14) +
  theme(legend.position = "none")


