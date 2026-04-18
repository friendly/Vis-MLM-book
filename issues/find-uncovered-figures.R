#' ---
#' title: Find figures without fig.code comments
#' ---
#'
#' Scans chapter .qmd files for {r} chunks with a `#| label: fig-*` that have
#' no  <!-- fig.code: R/... -->  comment in the preceding N_LOOKBACK lines.
#' For each uncovered figure, matches the dataset token (first word after "fig-")
#' against filenames in R/ to find candidate source files.
#'
#' Output: issues/figcode-gaps.md
#'   - 1 candidate  → ready-to-paste <!-- fig.code: R/foo.R --> comment
#'   - 2+ candidates → list of candidates to review manually
#'   - 0 candidates  → flagged as no match
#'
#' Usage (from project root):
#'   source("R/find-uncovered-figures.R")

library(yaml)

N_LOOKBACK <- 15      # lines before the label line to search for a fig.code comment
OUT_FILE   <- "issues/figcode-gaps.md"

# Chunk body must contain at least one of these to be considered a graphics chunk.
# Covers base R graphics, ggplot2, and common specialised plot functions used in the book.
GRAPHICS_RX <- paste(sep = "|",
  "\\bplot\\s*\\(",          # plot(), plot.default(), plot.lm(), etc.
  "\\bggplot\\s*\\(",        # ggplot()
  "\\bgeom_\\w+\\s*\\(",     # geom_point(), geom_line(), ...
  "\\bstat_\\w+\\s*\\(",     # stat_smooth(), ...
  "\\bautoplot\\s*\\(",      # ggplot2::autoplot()
  "\\bqplot\\s*\\(",
  "\\bggpairs\\s*\\(",       # GGally
  "\\bggbiplot\\s*\\(",
  "\\bcorrplot\\s*\\(",      # corrplot
  "\\bbiplot\\s*\\(",        # base / FactoMineR
  "\\bfviz_\\w+\\s*\\(",     # factoextra
  "\\bscatterplot\\s*\\(",   # car
  "\\bxyplot\\s*\\(",        # lattice
  "\\bbwplot\\s*\\(",
  "\\blevelplot\\s*\\(",
  "\\bbarplot\\s*\\(",
  "\\bhist\\s*\\(",
  "\\bboxplot\\s*\\(",
  "\\bpairs\\s*\\(",
  "\\bcurve\\s*\\(",
  "\\bpersp\\s*\\(",
  "\\bcontour\\s*\\(",
  "\\bimage\\s*\\(",
  "\\bmosaicplot\\s*\\(",
  "\\bsunflowerplot\\s*\\(",
  "\\bchart\\s*\\("          # other chart functions
)

# ------------------------------------------------------------------
# 1. Chapter list from _quarto.yml
# ------------------------------------------------------------------
cfg <- yaml::read_yaml("_quarto.yml")

flatten_chapters <- function(items) {
  result <- character(0)
  for (item in items) {
    if (is.character(item)) {
      result <- c(result, item)
    } else if (is.list(item) && !is.null(item$chapters)) {
      sub <- unlist(lapply(item$chapters, function(x) if (is.character(x)) x else NULL))
      result <- c(result, sub[!is.null(sub)])
    }
  }
  result[grepl("\\.qmd$", result)]
}

chapter_files <- flatten_chapters(cfg$book$chapters)
if (!is.null(cfg$book$appendices)) {
  app <- unlist(cfg$book$appendices)
  chapter_files <- c(chapter_files, app[grepl("\\.qmd$", app)])
}

# ------------------------------------------------------------------
# 2. R files available for matching
# ------------------------------------------------------------------
r_files <- sort(list.files("R", pattern = "\\.R$", full.names = FALSE))

# Token: first hyphen-delimited word after the "fig-" prefix
# e.g. "fig-Prestige-scatterplot1" -> "Prestige"
#      "fig-peng-ggplot1"          -> "peng"
#      "fig-crime-cor"             -> "crime"
label_token <- function(label) {
  sub("^fig-([^-]+).*", "\\1", label)
}

find_candidates <- function(token) {
  r_files[grepl(token, r_files, ignore.case = TRUE)]
}

# Chapter heading helpers (shared with make-rcode-appendix.R)
get_chapter_title <- function(qmd) {
  lines <- readLines(qmd, warn = FALSE)
  if (length(lines) && trimws(lines[1]) == "---") {
    end <- which(trimws(lines[-1]) == "---")[1] + 1
    if (!is.na(end)) lines <- lines[seq(end + 1, length(lines))]
  }
  hit <- grep("^#\\s+", lines, value = TRUE)[1]
  if (is.na(hit)) return(tools::file_path_sans_ext(basename(qmd)))
  trimws(sub("\\s*\\{[^}]*\\}\\s*$", "", sub("^#+\\s+", "", hit)))
}

make_chapter_heading <- function(qmd, title) {
  base    <- tools::file_path_sans_ext(basename(qmd))
  num_str <- sub("^(\\d+)-.*", "\\1", base)
  if (num_str == base) return(title)
  num <- as.integer(num_str)
  if (num >= 1 && num <= 15) sprintf("Chapter %d: %s", num, title)
  else if (num == 21)        sprintf("Appendix: %s", title)
  else                       title
}

# ------------------------------------------------------------------
# 3. Scan chapters for uncovered figures
# ------------------------------------------------------------------
results <- list()

for (qmd in chapter_files) {
  if (!file.exists(qmd)) next
  lines <- readLines(qmd, warn = FALSE)

  label_idx <- grep("^#\\|\\s*label:\\s*fig-", lines)
  if (!length(label_idx)) next

  uncovered <- list()

  for (li in label_idx) {
    label <- trimws(sub("^#\\|\\s*label:\\s*", "", lines[li]))

    # Look back N lines for an existing fig.code comment
    lookback <- lines[max(1, li - N_LOOKBACK) : (li - 1)]
    if (any(grepl("<!--\\s*fig\\.code:", lookback))) next

    # Find the chunk boundaries so we can inspect the body
    chunk_start <- NA
    for (k in seq(li - 1, max(1, li - 6), by = -1)) {
      if (grepl("^```\\{r", lines[k])) { chunk_start <- k; break }
    }
    chunk_end <- NA
    for (k in seq(li + 1, min(length(lines), li + 300), by = 1)) {
      if (grepl("^```\\s*$", lines[k])) { chunk_end <- k; break }
    }
    if (is.na(chunk_start) || is.na(chunk_end)) next

    chunk_body <- lines[(chunk_start + 1):(chunk_end - 1)]

    # Skip: chunk just embeds a pre-made image
    if (any(grepl("knitr::include_graphics\\s*\\(", chunk_body))) next

    # Skip: no recognisable R graphics call in the body
    if (!any(grepl(GRAPHICS_RX, chunk_body, perl = TRUE))) next

    token      <- label_token(label)
    candidates <- find_candidates(token)

    uncovered[[length(uncovered) + 1]] <- list(
      label      = label,
      line       = li,
      token      = token,
      candidates = candidates
    )
  }

  if (length(uncovered)) {
    ch_title <- get_chapter_title(qmd)
    results[[qmd]] <- list(
      heading   = make_chapter_heading(qmd, ch_title),
      qmd       = qmd,
      uncovered = uncovered
    )
  }
}

# ------------------------------------------------------------------
# 4. Write report
# ------------------------------------------------------------------
n_total     <- sum(sapply(results, function(x) length(x$uncovered)))
n_clear     <- sum(sapply(results, function(x) sum(sapply(x$uncovered, function(u) length(u$candidates) == 1))))
n_ambiguous <- sum(sapply(results, function(x) sum(sapply(x$uncovered, function(u) length(u$candidates) > 1))))
n_none      <- sum(sapply(results, function(x) sum(sapply(x$uncovered, function(u) length(u$candidates) == 0))))

con <- file(OUT_FILE, "w")

cat(sprintf(
'# Figures without fig.code comments

Figures in `{r}` chunks with a `fig-*` label that have no `<!-- fig.code: -->` comment
in the %d lines before the label. The dataset token (first word after `fig-`) is matched
against filenames in `R/`.

**Summary:** %d uncovered figures across %d chapters — %d clear match, %d ambiguous, %d no match.

To add a comment, insert it in the `.qmd` file immediately before the opening ` ```{r}` of the chunk.

---

', N_LOOKBACK, n_total, length(results), n_clear, n_ambiguous, n_none), file = con)

for (ch in results) {
  cat(sprintf("## %s (`%s`)\n\n", ch$heading, ch$qmd), file = con)

  for (u in ch$uncovered) {
    nc <- length(u$candidates)

    if (nc == 1) {
      cat(sprintf("**`%s`** (line %d)\n→ `<!-- fig.code: R/%s -->`\n\n",
                  u$label, u$line, u$candidates[1]), file = con)
    } else if (nc == 0) {
      cat(sprintf("**`%s`** (line %d) — *no match for token `%s`*\n\n",
                  u$label, u$line, u$token), file = con)
    } else {
      cat(sprintf("**`%s`** (line %d) — *ambiguous* (token: `%s`)\n",
                  u$label, u$line, u$token), file = con)
      for (cand in u$candidates) {
        cat(sprintf("- `<!-- fig.code: R/%s -->`\n", cand), file = con)
      }
      cat("\n", file = con)
    }
  }

  cat("---\n\n", file = con)
}

close(con)
message(sprintf("Written: %s  (%d figures: %d clear, %d ambiguous, %d no match)",
                OUT_FILE, n_total, n_clear, n_ambiguous, n_none))
