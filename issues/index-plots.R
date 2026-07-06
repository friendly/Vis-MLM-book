# index-plots.R
# Visualizations of the subject index distribution for Vis-MLM-book.
# Reads issues/index-terms-ch.csv (produced by index-add-chapters.R).
# Saves plots to issues/index-plots/
#
# Run from the project root:
#   Rscript issues/index-plots.R

library(dplyr)
library(ggplot2)
library(stringr)
library(forcats)
library(tidyr)

outdir <- "issues/index-plots"
if (!dir.exists(outdir)) dir.create(outdir)

idx <- read.csv("issues/index-terms-ch.csv", stringsAsFactors = FALSE)

# ── Part membership (for consistent coloring) ─────────────────────────────────
part_map <- tribble(
  ~part, ~label,               ~chapters,          ~color,
  1L,    "I: Orienting Ideas", 1:3,                "#4169E1",  # blue
  2L,    "II: Exploratory",    4:5,                "#008080",  # teal
  3L,    "III: Univariate LM", 6:9,                "#267342",  # partIII green
  4L,    "IV: Multivariate LM",10:15,              "#CC6600"   # partIV orange
)

ch_part <- part_map |>
  rowwise() |>
  reframe(chapter = chapters, part = part, part_label = label, part_color = color)

idx <- idx |>
  left_join(ch_part, by = "chapter")

# Convenient chapter label factor (for axis)
ch_labels <- idx |>
  filter(!is.na(chapter), chapter > 0) |>
  distinct(chapter, ch_title) |>
  arrange(chapter) |>
  mutate(ch_label = sprintf("Ch %d\n%s", chapter,
                            str_trunc(ch_title, 22, ellipsis = "…")))

idx <- idx |>
  left_join(ch_labels |> select(chapter, ch_label), by = "chapter")

# ── Helpers ───────────────────────────────────────────────────────────────────
save_plot <- function(p, name, w = 9, h = 5) {
  path <- file.path(outdir, paste0(name, ".png"))
  ggsave(path, p, width = w, height = h, dpi = 150)
  message("Saved: ", path)
  print(p)
}

theme_book <- theme_minimal(base_size = 12) +
  theme(panel.grid.minor = element_blank())

part_colors <- setNames(part_map$color, part_map$label)

# ── Plot 1: Index entries per chapter (bar, colored by part) ──────────────────
ch_counts <- idx |>
  filter(!is.na(chapter), chapter > 0) |>
  count(chapter, ch_label, part_label, part_color) |>
  arrange(chapter) |>
  mutate(ch_label = fct_inorder(ch_label))

p1 <- ggplot(ch_counts, aes(x = ch_label, y = n, fill = part_label)) +
  geom_col(width = 0.75) +
  geom_text(aes(label = n), vjust = -0.4, size = 3.2) +
  scale_fill_manual(values = part_colors, name = "Part") +
  labs(title = "Index entries per chapter",
       x = NULL, y = "Number of index entries") +
  theme_book +
  theme(axis.text.x = element_text(size = 7.5),
        legend.position = "bottom")

save_plot(p1, "01-entries-per-chapter", w = 11, h = 5.5)

# ── Plot 2: Page density histogram (arabic pages only) ────────────────────────
# Mark chapter start pages as vertical lines
ch_starts <- ch_labels |>
  left_join(idx |> filter(chapter > 0) |>
              group_by(chapter) |> summarise(start = min(page_num, na.rm = TRUE)),
            by = "chapter")

p2 <- idx |>
  filter(!is.na(page_num), page_num > 0) |>
  ggplot(aes(x = page_num)) +
  geom_histogram(binwidth = 5, fill = "steelblue", color = "white", linewidth = 0.2) +
  geom_vline(data = ch_starts, aes(xintercept = start),
             color = "firebrick", linewidth = 0.4, linetype = "dashed", alpha = 0.7) +
  geom_text(data = ch_starts,
            aes(x = start, y = Inf, label = chapter),
            vjust = 1.5, hjust = -0.3, size = 2.8, color = "firebrick") +
  labs(title = "Distribution of index entries across pages",
       subtitle = "Dashed lines = chapter starts; numbers = chapter",
       x = "Page number", y = "Index entries per 5-page bin") +
  theme_book

save_plot(p2, "02-page-density", w = 11, h = 5)

# ── Plot 3: Top 30 terms by page count ────────────────────────────────────────
# Aggregate: for each term, count distinct pages
# Use the top-level term (before ! for subentries)
top_terms <- idx |>
  mutate(main_term = str_replace(term, "!.*", "")) |>
  filter(!str_detect(main_term, "^(packages|datasets)")) |>  # handled separately
  group_by(main_term) |>
  summarise(n_pages = n_distinct(page_num, na.rm = TRUE), .groups = "drop") |>
  arrange(desc(n_pages)) |>
  slice_head(n = 30)

p3 <- top_terms |>
  mutate(main_term = fct_reorder(main_term, n_pages)) |>
  ggplot(aes(x = n_pages, y = main_term)) +
  geom_col(fill = "steelblue") +
  geom_text(aes(label = n_pages), hjust = -0.2, size = 3) +
  labs(title = "Top 30 most-referenced index terms",
       subtitle = "(excluding packages and datasets subcategories)",
       x = "Number of distinct pages", y = NULL) +
  theme_book +
  theme(axis.text.y = element_text(size = 9)) +
  scale_x_continuous(expand = expansion(mult = c(0, 0.12)))

save_plot(p3, "03-top-terms", w = 9, h = 7)

# ── Plot 4: Category breakdown (main entry categories via !) ──────────────────
cats <- idx |>
  mutate(
    category = case_when(
      str_detect(term, "^packages!")   ~ "packages",
      str_detect(term, "^datasets!")   ~ "datasets",
      str_detect(term, "^functions!")  ~ "functions",
      str_detect(term, "!")            ~ "other subentries",
      TRUE                             ~ "main entries"
    )
  ) |>
  count(category) |>
  mutate(category = fct_reorder(category, n),
         pct = round(100 * n / sum(n), 1),
         label = sprintf("%s\n(%d, %.0f%%)", category, n, pct))

p4 <- ggplot(cats, aes(x = n, y = category, fill = category)) +
  geom_col(show.legend = FALSE) +
  geom_text(aes(label = sprintf("%d  (%.0f%%)", n, pct)), hjust = -0.1, size = 3.5) +
  scale_fill_brewer(palette = "Set2") +
  labs(title = "Index entry categories",
       x = "Number of entries", y = NULL) +
  theme_book +
  scale_x_continuous(expand = expansion(mult = c(0, 0.18)))

save_plot(p4, "04-categories", w = 8, h = 4)

# ── Plot 5: Rank-frequency (Zipf) plot ────────────────────────────────────────
zipf <- idx |>
  group_by(term) |>
  summarise(n = n(), .groups = "drop") |>
  arrange(desc(n)) |>
  mutate(rank = row_number())

fit <- lm(log10(n) ~ log10(rank), data = zipf)
alpha <- -coef(fit)[["log10(rank)"]]
r2    <- summary(fit)$r.squared

p5 <- ggplot(zipf, aes(x = rank, y = n)) +
  geom_point(size = 1, color = "steelblue", alpha = 0.6) +
  geom_smooth(method = "lm", se = FALSE, color = "firebrick",
              linetype = "dashed", linewidth = 0.8) +
  scale_x_log10() +
  scale_y_log10() +
  labs(title = "Index term frequency distribution (Zipf check)",
       subtitle = sprintf("Fitted exponent α = %.2f,  R² = %.3f", alpha, r2),
       x = "Rank (log scale)", y = "Entry count (log scale)") +
  theme_book

save_plot(p5, "05-zipf", w = 7, h = 5)

# ── Plot 6: Packages referenced per chapter ───────────────────────────────────
pkg_ch <- idx |>
  filter(str_detect(term, "^packages!"), !is.na(chapter), chapter > 0) |>
  mutate(pkg = str_remove(term, "^packages!")) |>
  distinct(pkg, chapter, ch_label, part_label) |>
  count(chapter, ch_label, part_label)

p6 <- ggplot(pkg_ch, aes(x = fct_reorder(ch_label, chapter), y = n, fill = part_label)) +
  geom_col(width = 0.75) +
  geom_text(aes(label = n), vjust = -0.4, size = 3.2) +
  scale_fill_manual(values = part_colors, name = "Part") +
  labs(title = "Distinct packages indexed per chapter",
       x = NULL, y = "Distinct packages") +
  theme_book +
  theme(axis.text.x = element_text(size = 7.5),
        legend.position = "bottom")

save_plot(p6, "06-packages-per-chapter", w = 11, h = 5)

message("\nAll plots saved to ", outdir)
