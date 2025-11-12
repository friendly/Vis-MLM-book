# Plot of longley variables over time
# from: https://jmsallan.netlify.app/blog/examining-the-longley-dataset/
# Use for exercise

longley |>
  select(Year, Unemployed, Employed, Armed.Forces, Population) |>
  pivot_longer(-Year) |>
  ggplot(aes(Year, value, color = name)) +
  geom_line(linewidth = 1) +
  scale_color_manual(values = c("#990000", "#FF8000", "#0080FF", "#CCCC00")) +
  theme_minimal(base_size = 12) +
  theme(legend.position = "bottom") +
  labs(x = NULL, y = NULL, title = "Evolution of population variables longley")
