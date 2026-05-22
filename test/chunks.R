# test/chunks.R
# Build data/chunks.RData: metadata for all code chunks in active .qmd files.
# Run from the project root.
#
# Fields in the output data frame:
#   chapter      integer chapter number extracted from the filename (e.g. 4)
#   file         source .qmd filename (relative to project root)
#   line         line number of the opening ```{r} header in that file
#   label        chunk label (from #| label: or old-style ```{r label})
#   has_label    TRUE if the chunk has any label
#   old_style    TRUE if the label is in old ```{r label} form, not #| label:
#   is_fig       TRUE if the label starts with "fig-"
#   echo_html    TRUE if echo=knitr::is_html_output() is on the header line
#                  (suppresses code in PDF while allowing fold in HTML)
#   echo_header  any other echo= value found on the header line (e.g. "-1")
#   echo_opt     value of #| echo: if set (e.g. "false")
#   code_fold    raw value of #| code-fold: (true / false / show, or NA)
#   code_summary TRUE if #| code-summary: is set
#   eval         value of #| eval: if set (usually "false")
#   fig_cap      TRUE if #| fig-cap: is set (confirms chunk produces a figure)
#   out_width    value of #| out-width: if set
#   n_code_lines number of non-blank, non-option lines in the chunk body
#                  (proxy for how much code is hidden when folded)
#   fold_status  derived summary of fold treatment:
#                  "both"      -- echo_html TRUE and code_fold "true" (fully treated)
#                  "echo-only" -- echo_html TRUE but no code-fold (PDF hidden, HTML shown)
#                  "fold-only" -- code_fold "true" but no echo_html (HTML folded, PDF shown)
#                  "fold-show" -- code_fold "show" (always visible)
#                  "fold-false"-- code_fold "false" (explicitly not folded)
#                  "no-eval"   -- eval: false (chunk does not run)
#                  "neither"   -- no fold treatment at all

# Active source files --------------------------------------------------------
chapter_files <- list.files(".", pattern = "^(0[1-9]|1[0-9]|2[0-9])-.*\\.qmd$")
child_files   <- c(
  "child/04-grand-tour.qmd",
  "child/04-network.qmd"
)
active_files <- c(chapter_files, child_files)

# Helpers --------------------------------------------------------------------

get_chapter <- function(f) {
  m <- regmatches(basename(f), regexpr("^[0-9]{2}", basename(f)))
  if (length(m) == 0 || m == "") NA_integer_ else as.integer(m)
}

# Extract value of a single YAML chunk option from a vector of "#| key: val" lines
get_opt <- function(opts, name) {
  pat <- paste0("^#\\|\\s*", name, "\\s*:\\s*(.+)$")
  for (o in opts) {
    m <- regmatches(o, regexec(pat, o))[[1]]
    if (length(m) == 2) return(trimws(m[2]))
  }
  NA_character_
}

# Fold-status summary: combines code-fold and echo_html into one factor
fold_status <- function(echo_html, code_fold, eval_opt) {
  cf <- trimws(replace(code_fold, is.na(code_fold), ""))
  if (!is.na(eval_opt) && trimws(eval_opt) == "false") return("no-eval")
  if (echo_html && cf == "true")  return("both")       # fully treated
  if (echo_html)                  return("echo-only")  # PDF hidden, HTML shown
  if (cf == "true")               return("fold-only")  # HTML folded, PDF shown
  if (cf == "show")               return("fold-show")
  if (cf == "false")              return("fold-false")
  "neither"
}

# Parse all chunks from one file ---------------------------------------------
parse_file_chunks <- function(file) {
  if (!file.exists(file)) { message("Not found: ", file); return(NULL) }
  lines <- readLines(file, warn = FALSE)
  n <- length(lines)

  starts <- grep("^```\\{r", lines)
  if (length(starts) == 0) return(NULL)

  out <- vector("list", length(starts))

  for (i in seq_along(starts)) {
    s <- starts[i]
    header <- lines[s]

    # Skip knitr child= chunks — they include sub-documents, not code
    if (grepl('child\\s*=', header)) next

    # Find matching closing ```
    e <- n
    if (s < n) {
      for (j in (s + 1):n) {
        if (grepl("^```\\s*$", lines[j])) { e <- j; break }
      }
    }

    chunk_lines <- if (e > s) lines[(s + 1):e] else character(0)
    opts  <- chunk_lines[grepl("^#\\|", chunk_lines)]
    code  <- chunk_lines[!grepl("^#\\|", chunk_lines) & !grepl("^```\\s*$", chunk_lines)]
    n_code <- sum(nchar(trimws(code)) > 0)

    # Label: prefer #| label:, fall back to ```{r old-label}
    yaml_lbl <- get_opt(opts, "label")
    hdr_lbl  <- sub("^```\\{r\\s+([A-Za-z][A-Za-z0-9_.-]*)[,}\\s].*", "\\1", header)
    if (hdr_lbl == header) hdr_lbl <- NA_character_
    label     <- if (!is.na(yaml_lbl)) yaml_lbl else hdr_lbl
    old_style <- is.na(yaml_lbl) && !is.na(hdr_lbl)

    # Echo options
    echo_html   <- grepl("echo=knitr::is_html_output()", header, fixed = TRUE)
    echo_header <- sub(".*\\becho=([^,}]+).*", "\\1", header)
    if (echo_header == header) echo_header <- NA_character_
    # also catch #| echo: false
    echo_opt <- get_opt(opts, "echo")

    # Other options
    cf      <- get_opt(opts, "code-fold")
    cs      <- get_opt(opts, "code-summary")
    eval_o  <- get_opt(opts, "eval")
    fig_cap <- get_opt(opts, "fig-cap")
    out_w   <- get_opt(opts, "out-width")

    out[[i]] <- data.frame(
      chapter      = get_chapter(file),
      file         = file,
      line         = s,
      label        = ifelse(is.na(label), NA_character_, label),
      has_label    = !is.na(label),
      old_style    = old_style,
      is_fig       = !is.na(label) && startsWith(label, "fig-"),
      echo_html    = echo_html,
      echo_header  = echo_header,    # any other echo= in header line
      echo_opt     = echo_opt,       # #| echo: value
      code_fold    = cf,             # raw value: true/false/show
      code_summary = !is.na(cs),
      eval         = eval_o,
      fig_cap      = !is.na(fig_cap),
      out_width    = out_w,
      n_code_lines = n_code,
      fold_status  = fold_status(echo_html, cf, eval_o),
      stringsAsFactors = FALSE
    )
  }

  do.call(rbind, Filter(Negate(is.null), out))
}

# Build dataset --------------------------------------------------------------
chunks <- do.call(rbind, lapply(active_files, parse_file_chunks))
chunks <- chunks[order(chunks$file, chunks$line), ]
rownames(chunks) <- NULL

# Summary --------------------------------------------------------------------
cat(sprintf("Total chunks: %d across %d files\n", nrow(chunks), length(unique(chunks$file))))
cat("\nfold_status breakdown:\n")
print(sort(table(chunks$fold_status), decreasing = TRUE))
cat("\nFigure chunks (is_fig == TRUE) by fold_status:\n")
print(sort(table(chunks$fold_status[chunks$is_fig]), decreasing = TRUE))
cat("\nChunks with old-style labels:\n")
print(chunks[!is.na(chunks$old_style) & chunks$old_style, c("file", "line", "label")])

# Save -----------------------------------------------------------------------
if (!dir.exists("data")) dir.create("data")
save(chunks, file = "data/chunks.RData")
cat("\nSaved to data/chunks.RData\n")
