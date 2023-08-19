# boxplots & violin plots

library(ggplot2)
ggplot(mtcars, aes(x = factor(cyl), y = mpg, fill = factor(cyl))) +
  geom_violin(scale = "width", trim = FALSE, alpha = 0.7) +
  geom_boxplot(width = 0.2, fill = "white", alpha = 0.9, outlier.shape = NA) +
  geom_jitter(width = 0.1, height = 0, size = 2, color = "black", alpha = 0.6) +
  scale_fill_manual(values = c("#F8766D", "#00BA38", "#619CFF")) +
  xlab("Number of Cylinders") +
  ylab("Miles per Gallon (MPG)") +
  ggtitle("Distribution of MPG by Number of Cylinders") +
  theme_bw() +
  theme(
    plot.title = element_text(size = 18, face = "bold", hjust = 0.5),
    axis.title = element_text(size = 14, face = "bold"),
    axis.text = element_text(size = 12),
    legend.title = element_blank(),
    panel.grid.major = element_blank(),
    panel.grid.minor = element_blank()
  )
