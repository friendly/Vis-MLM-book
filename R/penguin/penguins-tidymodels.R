#' ---
#' title: Fitting many models
#' ---

# from: https://cameronpatrick.com/post/2023/06/dplyr-fitting-multiple-models-at-once/

library(tidyverse)
library(gt)
library(emmeans)
library(performance)

library(palmerpenguins)
data(penguins)
head(penguins)

penguins_long <- penguins %>%
  pivot_longer(
    c(bill_length_mm, bill_depth_mm, flipper_length_mm, body_mass_g),
    names_to = "outcome",
    values_to = "value"
  ) %>%
  mutate(
    outcome = fct_inorder(outcome),
    outcome = fct_recode(
      outcome,
      "Bill length (mm)" = "bill_length_mm",
      "Bill depth (mm)" = "bill_depth_mm",
      "Flipper length (mm)" = "flipper_length_mm",
      "Body mass (g)" = "body_mass_g"
    )
  )

head(penguins_long)

# fit model for each
penguin_models <- penguins_long %>%
  group_by(outcome) %>%
  summarise(
    model = list(
      lm(value ~ species, data = pick(everything()))
    )
  )

# make a diagnostic plot for each variable
walk2(
  penguin_models$outcome, 
  penguin_models$model,
  ~ ggsave(
    paste0(.x, ".png"),
    plot(check_model(.y, check = c("pp_check", "linearity",
                                   "homogeneity", "qq"))),
    width = 12,
    height = 9
  )
)

# get estimated marginal means

penguin_means <- penguin_models %>%
  rowwise(outcome) %>%
  reframe(
    emmeans(model, "species") %>%
      as_tibble()
  )
head(penguin_means)

# plot means & CI
penguin_means %>%
  ggplot(aes(x = emmean, y = species, xmin = lower.CL, xmax = upper.CL)) +
  geom_errorbar(width = 0.5) +
  geom_point() +
  scale_y_discrete(limits = rev) +
  facet_wrap(vars(outcome), nrow = 2, scales = "free_x") +
  labs(
    x = "Mean", 
    y = "Species",
    caption = "Error bars show 95% confidence interval for mean."
  )

# table
penguin_means %>%
  group_by(outcome) %>%
  gt() %>%
  fmt_number(c(emmean, SE, lower.CL, upper.CL),
             decimals = 1, use_seps = FALSE) %>%
  fmt_number(c(emmean, SE, lower.CL, upper.CL),
             rows = outcome == "Body mass (g)",
             decimals = 0, use_seps = FALSE) %>%
  fmt_number(df, decimals = 0) %>%
  cols_align("left", species) %>%
  cols_merge_range(lower.CL, upper.CL, sep = ", ") %>%
  cols_label(
    species = "Species",
    emmean = "Mean",
    lower.CL = "95% Confidence Interval"
  )

# F-test for each variable

penguin_tests <- penguin_models %>%
  rowwise(outcome) %>%
  reframe(
    joint_tests(model) %>%
      as_tibble()
  )

# gt table

penguin_tests %>%
  gt() %>%
  fmt_number(F.ratio, decimals = 1) %>%
  fmt_number(p.value, decimals = 3) %>%
  cols_merge_range(df1, df2, sep = ", ") %>%
  sub_small_vals(p.value, threshold = 0.001) %>%
  cols_label(
    outcome = "Outcome",
    `model term` = "Predictor",
    df1 = "df",
    F.ratio = "F",
    p.value = "p-value"
  )

# Finally, we often want to obtain comparisons between particular estimated quantities. In this example we use the emmeans package again for this, this time using the pairs() function to produce comparisons between all pairs of species.

penguin_pairs <- penguin_models %>%
  rowwise(outcome) %>%
  reframe(
    emmeans(model, "species") %>%
      pairs(infer = TRUE, reverse = TRUE, adjust = "none") %>%
      as_tibble()
  )

# plot comparisons

penguin_pairs %>%
  ggplot(aes(x = estimate, y = contrast, xmin = lower.CL, xmax = upper.CL)) +
  geom_vline(xintercept = 0, linetype = "dotted") +
  geom_errorbar(width = 0.5) +
  geom_point() +
  scale_y_discrete(limits = rev) +
  facet_wrap(vars(outcome), nrow = 2, scales = "free_x") +
  labs(
    x = "Difference in means", 
    y = "Contrast",
    caption = "Error bars show 95% confidence interval for difference in mean."
  )

# Finally, we often want to obtain comparisons between particular estimated quantities. In this example we use the emmeans package again for this, this time using the pairs() function to produce comparisons between all pairs of species.