# R script for analyzing your Vis-MLM-book index term frequency distribution (Zipf check). Runs with simulated data out of the box -- swap in your real term/locator_count CSV when ready.

# ---------------------------------------------------------------
# index_distribution.R
#
# Quick diagnostic: rank-frequency (Zipf-style) analysis of a
# book subject index, for Vis-MLM-book.
#
# Expects a CSV (or data frame) with one row per index entry,
# something like:
#
# term, locator_count
# "Hotelling's T2", 14
# "collinearity", 9
# "ridge regression", 9
# ...
#
# If your index is exported from Quarto/LaTeX as raw entries
# (one per occurrence, not pre-aggregated), see the aggregation
# step below.
# ---------------------------------------------------------------

library(tidyverse)

# ---- 1. Read your index data -----------------------------------
# Option A: already aggregated (term, count)
# idx <- read_csv("vis_mlm_index.csv")

# Option B: raw occurrences (one row per term mention) -- aggregate first
# raw <- read_csv("vis_mlm_index_raw.csv") # columns: term, page
# idx <- raw %>%
#   count(term, name = "locator_count")

# ---- Minimal worked example (replace with your real data) ------
set.seed(42)
terms <- c(
  "Hotelling's T2", "collinearity", "ridge regression",
  "canonical correlation", "MANOVA", "discriminant analysis",
  "biplot", "eigenvalue", "covariance matrix", "candisc package",
  "Wilks' lambda", "multivariate normality", "Box's M test",
  "variance inflation factor", "principal components",
  "linear discriminant function", "Mahalanobis distance",
  "heplots package", "scatterplot matrix", "QR decomposition"
)

# Simulated Zipfian counts for illustration only
idx <- tibble(
  term = terms,
  locator_count = round(50 / rank(-seq_along(terms)) * runif(length(terms), 0.8, 1.2))
) %>%
  arrange(desc(locator_count))

# ---- 2. Compute rank and basic diagnostics ----------------------
idx <- idx %>%
  arrange(desc(locator_count)) %>%
  mutate(
    rank = row_number(),
    log_rank = log10(rank),
    log_count = log10(locator_count)
  )

# Summary stats
n_terms <- nrow(idx)
n_singletons <- sum(idx$locator_count == 1)
pct_singletons <- round(100 * n_singletons / n_terms, 1)

cat("Number of index terms:", n_terms, "\n")
cat("Terms with only 1 locator (singletons):", n_singletons,
    sprintf("(%.1f%%)\n", pct_singletons))
cat("Max locator count:", max(idx$locator_count), "\n")
cat("Median locator count:", median(idx$locator_count), "\n")

# ---- 3. Fit a power law: log(count) ~ log(rank) -----------------
# Zipf's law predicts count ~ rank^(-alpha), so log-log should be
# roughly linear with negative slope alpha.
fit <- lm(log_count ~ log_rank, data = idx)
alpha <- -coef(fit)[["log_rank"]]
r2 <- summary(fit)$r.squared

cat(sprintf("\nFitted Zipf exponent (alpha): %.2f\n", alpha))
cat(sprintf("R-squared of log-log fit: %.3f\n", r2))
cat("(alpha near 1 is classic Zipf; R^2 close to 1 means the index\n",
    " follows the expected rank-frequency shape)\n")

# ---- 4. Plot: rank-frequency on log-log scale -------------------
p <- ggplot(idx, aes(x = rank, y = locator_count)) +
  geom_point(size = 2, color = "steelblue") +
  geom_smooth(method = "lm", se = FALSE, color = "firebrick",
              linetype = "dashed") +
  scale_x_log10() +
  scale_y_log10() +
  labs(
    title = "Index Term Frequency Distribution (Zipf check)",
    subtitle = sprintf("alpha = %.2f, R^2 = %.3f", alpha, r2),
    x = "Rank (log scale)",
    y = "Locator count (log scale)"
  ) +
  theme_minimal(base_size = 13)

print(p)

ggsave("index_zipf_plot.png", p, width = 7, height = 5, dpi = 150)

# ---- 5. Coverage / specificity diagnostics ----------------------
# Distribution of subentries per main entry, if you have that column
# (term_main, subentry) -- uncomment and adapt if your data has it:
#
# specificity <- idx_raw %>%
#   count(term_main, name = "n_subentries") %>%
#   summarise(
#     mean_sub = mean(n_subentries),
#     pct_no_sub = mean(n_subentries == 1) * 100
#   )
# print(specificity)

# ---- Notes -------------------------------------------------------
# - A healthy index typically shows alpha in the 0.7-1.2 range and
#   a long tail of singleton terms (this is normal, not a flaw --
#   many legitimate terms only appear once).
# - If the distribution is too FLAT (alpha << 0.5), your index may
#   be over-fragmented: synonyms or near-duplicate terms splitting
#   what should be one entry's locators.
# - If a few terms dominate even more than Zipf predicts
#   (alpha >> 1.5), check whether those are overly broad terms
#   (e.g., "model", "data") that should be split into subentries.
