# from: https://evamaerey.github.io/featurette/2023-10-30-ggformula-penguins/ggformula-penguins.html

library(ggformula)
palmerpenguins::penguins %>%
  set_variable_labels(
    bill_length_mm = "bill length (mm)",
    bill_depth_mm = "bill depth (mm)"
  ) %>%
  gf_jitter(bill_length_mm ~ bill_depth_mm |  # y x
            island ~ sex,                     # row col facets
            color = ~ species,
            width = 0.05,
            height = 0.05,
            size = 0.5,
            alpha = 0.6) %>%
  gf_density2d(alpha = 0.3) %>%
  gf_labs(title = "Palmer Penguins",
          caption = "Data available in palmerpenguins package"
  ) %>%
  gf_refine(scale_color_brewer(type = "qual")) %>%
  gf_theme(theme_bw())

