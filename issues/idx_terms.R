# idx_terms.R — Parse a LaTeX .idx file into a tidy CSV
#
# Produces a CSV with one row per \indexentry occurrence, columns:
#   term      : plain-text sort key (e.g. "Cook's distance!multivariate")
#   page      : integer page number
#   formatted : LaTeX display text when the entry uses sort@display notation
#               (e.g. "\texttt{ggeffects} package"); NA when term is its own display
#
# Quotes in the CSV catch trailing/leading spaces in index terms.
#
# Usage: source this file from the project root, or set either variable
# before sourcing to override the default:
#   idx_file <- "pdf/index.idx"; source("issues/idx_terms.R")

if (!exists("idx_file")) idx_file <- "index.idx"          # built at project root by quarto render
if (!exists("out_file")) out_file <- "issues/index-terms.csv"

lines <- readLines(idx_file, warn = FALSE, encoding = "latin1")

# ---------------------------------------------------------------------------
# Helpers
# ---------------------------------------------------------------------------

# Strip the |encap suffix (everything from the last | to end of spec string).
strip_encap <- function(spec) sub("\\|[^|]*$", "", spec)

# Parse a spec (after stripping encap) into `term` (sort keys) and `formatted`
# (display text, or NA when no @ notation is present at any level).
#
# makeindex multi-level format: sort1@disp1!sort2@disp2...
# Each level may optionally have sort@display; without @ the text serves as both.
parse_spec <- function(spec) {
  levels <- strsplit(spec, "!", fixed = TRUE)[[1]]
  sort_v <- character(length(levels))
  disp_v <- character(length(levels))
  has_at <- FALSE

  for (i in seq_along(levels)) {
    at <- regexpr("@", levels[i], fixed = TRUE)
    if (at > 0L) {
      sort_v[i] <- substr(levels[i], 1L, at - 1L)
      disp_v[i] <- substr(levels[i], at + 1L, nchar(levels[i]))
      has_at <- TRUE
    } else {
      sort_v[i] <- disp_v[i] <- levels[i]
    }
  }

  list(
    term      = paste(sort_v, collapse = "!"),
    formatted = if (has_at) paste(disp_v, collapse = "!") else NA_character_
  )
}

# ---------------------------------------------------------------------------
# Parse
# ---------------------------------------------------------------------------

# Match lines of the exact form \indexentry{SPEC}{PAGE}
pat   <- "^\\\\indexentry\\{(.+)\\}\\{([0-9]+)\\}$"
valid <- grepl(pat, lines, perl = TRUE)
lines <- lines[valid]

if (length(lines) == 0L) stop("No \\indexentry lines found in '", idx_file, "'")

raw_specs <- sub(pat, "\\1", lines, perl = TRUE)
pages     <- as.integer(sub(pat, "\\2", lines, perl = TRUE))
specs     <- strip_encap(raw_specs)
parsed    <- lapply(specs, parse_spec)

df <- data.frame(
  term      = vapply(parsed, `[[`, character(1), "term"),
  page      = pages,
  formatted = vapply(parsed, `[[`, character(1), "formatted"),
  stringsAsFactors = FALSE
)

# ---------------------------------------------------------------------------
# Write
# ---------------------------------------------------------------------------

write.csv(df, out_file, row.names = FALSE)

n_fmt <- sum(!is.na(df$formatted))
message(sprintf("Read  %d entries from '%s'", nrow(df), idx_file))
message(sprintf("Wrote %d rows to '%s'  (%d with @-display formatting)",
                nrow(df), out_file, n_fmt))
