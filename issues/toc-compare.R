# Compare pages-per-chapter between two PDF builds.
# Reads the embedded bookmark outline via pdftools::pdf_toc() — no .toc file needed.
# Run from the project root.
library(pdftools)

prev_pdf <- "pdf/Vis-MLM.pdf"   # May 12 2026 reference
curr_pdf <- "docs/Vis-MLM.pdf"  # May 16 2026 current (still includes appendices)

prev_total <- pdf_info(prev_pdf)$pages
curr_total  <- pdf_info(curr_pdf)$pages
cat("Previous total pages:", prev_total, "\n")
cat("Current  total pages:", curr_total,  "\n\n")

# ── helpers ──────────────────────────────────────────────────────────────────

# Recursively flatten a pdf_toc() list, collecting entries at `target` depth.
# pdf_toc() structure: list of nodes, each node = list(title, page, children).
# For a krantz book: Parts at depth 1, Chapters at depth 2.
flatten_toc <- function(nodes, depth = 1, target = 2) {
  rows <- list()
  for (nd in nodes) {
    if (depth == target)
      rows <- c(rows, list(data.frame(title = nd$title, page = nd$page,
                                      stringsAsFactors = FALSE)))
    if (length(nd$children))
      rows <- c(rows, flatten_toc(nd$children, depth + 1L, target))
  }
  do.call(rbind, rows)
}

# Build a pages-per-chapter table from a PDF file.
# `target` depth: 2 for Parts→Chapters layout, 1 if chapters are top-level.
chapters_from <- function(pdf_path, total_pages, target = 2) {
  toc <- pdf_toc(pdf_path)
  df  <- flatten_toc(toc, depth = 1L, target = target)
  # Fall back to depth 1 if depth 2 is empty (chapters at top level).
  if (is.null(df) || nrow(df) == 0)
    df <- flatten_toc(toc, depth = 1L, target = 1L)
  df <- df[order(df$page), ]
  df$pages <- c(diff(df$page), total_pages + 1L - tail(df$page, 1L))
  df
}

# ── inspect structure (run interactively to check depth) ─────────────────────
# str(pdf_toc(prev_pdf), max.level = 2)

# ── build tables ─────────────────────────────────────────────────────────────
prev <- chapters_from(prev_pdf, prev_total, target = 2)
curr <- chapters_from(curr_pdf, curr_total, target = 2)

merged <- merge(prev, curr, by = "title", all = TRUE, suffixes = c("_prev", "_curr"))
merged <- merged[order(pmax(merged$page_prev, merged$page_curr, na.rm = TRUE)), ]
merged$diff <- merged$pages_curr - merged$pages_prev

# ── print ─────────────────────────────────────────────────────────────────────
fmt <- function(x) ifelse(is.na(x), "  —", formatC(x, width = 5))
cat(sprintf("%-48s %5s %5s %5s %5s %5s\n",
            "Chapter", "p_prv", "n_prv", "p_cur", "n_cur", " diff"))
cat(strrep("-", 75), "\n")
for (i in seq_len(nrow(merged))) {
  r <- merged[i, ]
  diff_str <- if (is.na(r$diff)) "  —" else sprintf("%+5d", r$diff)
  cat(sprintf("%-48s %s %s %s %s %s\n",
    substr(r$title, 1L, 48L),
    fmt(r$page_prev), fmt(r$pages_prev),
    fmt(r$page_curr), fmt(r$pages_curr),
    diff_str))
}
cat(strrep("-", 75), "\n")
cat(sprintf("%-48s %5d %5d %5d %5d %+5d\n", "TOTAL (PDF pages)",
            NA, prev_total, NA, curr_total, curr_total - prev_total))
