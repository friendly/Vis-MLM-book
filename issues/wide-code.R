# issues/wide-code.R
# Report code-chunk lines that exceed the PDF code-block width limit.
#
# Limit: ~65 chars at 10pt Fira Mono in a 33pc (396pt) tcolorbox.
#   With \small (9pt) the limit rises to ~71 chars.
#   R's default options(width=80) exceeds both — hence the overflows.
#
# LaTeX fix: preamble.tex loads fvextra and sets breaklines=true,breakanywhere=true
#   on the Highlighting environment so lines wrap automatically.
#   This script is useful for finding lines to reformat manually if wrap looks poor.
#
# Scans source code lines only (not rendered output).
# Output lines (str(), print(), etc.) must be controlled via options(width=N)
# in the chunk or in R/common.R.
#
# Run from the project root.

WIDTH_LIMIT <- 65L   # chars; flag lines strictly wider than this
TAB_STOP    <-  4L   # knitr expands tabs to tabstop=4 before writing .tex
                     # (confirmed: 2 spaces + tab -> 4 spaces in Vis-MLM.tex)

# Expand tabs to spaces using a given tabstop (positional, not fixed width)
expand_tabs <- function(s, tabstop = TAB_STOP) {
  chars <- strsplit(s, "")[[1]]
  col   <- 0L
  out   <- character(0)
  for (ch in chars) {
    if (ch == "\t") {
      n   <- tabstop - (col %% tabstop)
      out <- c(out, rep(" ", n))
      col <- col + n
    } else {
      out <- c(out, ch)
      col <- col + 1L
    }
  }
  paste(out, collapse = "")
}

# Active source files (same list as test/chunks.R) ---------------------------
chapter_files <- list.files(".", pattern = "^(0[1-9]|1[0-9]|2[0-9])-.*\\.qmd$")
child_files   <- c("child/04-grand-tour.qmd", "child/04-network.qmd")
active_files  <- c(chapter_files, child_files)

# Helpers --------------------------------------------------------------------
get_chapter <- function(f) {
  m <- regmatches(basename(f), regexpr("^[0-9]{2}", basename(f)))
  if (length(m) == 0 || m == "") NA_integer_ else as.integer(m)
}

# Scan one file --------------------------------------------------------------
scan_file <- function(file) {
  if (!file.exists(file)) return(NULL)
  lines <- readLines(file, warn = FALSE)
  n     <- length(lines)
  starts <- grep("^```\\{r", lines)
  if (length(starts) == 0) return(NULL)

  rows <- list()
  for (i in seq_along(starts)) {
    s      <- starts[i]
    header <- lines[s]
    if (grepl('child\\s*=', header)) next   # skip child= include chunks

    # find closing ```
    e <- n
    for (j in (s + 1):n)
      if (grepl("^```\\s*$", lines[j])) { e <- j; break }

    chunk_lines <- if (e > s) lines[(s + 1):e] else character(0)
    opts <- chunk_lines[grepl("^#\\|", chunk_lines)]

    # Skip chunks whose code is not shown in the PDF:
    #   echo=knitr::is_html_output()  -> FALSE in PDF
    #   echo=FALSE / echo=F            -> hidden everywhere
    #   #| echo: false                 -> hidden everywhere
    if (grepl("echo\\s*=\\s*knitr::is_html_output\\(\\)", header)) next
    if (grepl("echo\\s*=\\s*(FALSE|F)\\b", header)) next
    echo_opt <- NA_character_
    for (ol in opts) {
      m <- regmatches(ol, regexec("^#\\|\\s*echo\\s*:\\s*(.+)$", ol))[[1]]
      if (length(m) == 2) { echo_opt <- trimws(m[2]); break }
    }
    if (!is.na(echo_opt) && tolower(echo_opt) == "false") next

    # label (prefer #| label:, fall back to ```{r label})
    yaml_lbl <- NA_character_
    for (ol in opts) {
      m <- regmatches(ol, regexec("^#\\|\\s*label\\s*:\\s*(.+)$", ol))[[1]]
      if (length(m) == 2) { yaml_lbl <- trimws(m[2]); break }
    }
    hdr_lbl <- sub("^```\\{r\\s+([A-Za-z][A-Za-z0-9_.-]*)[,}\\s].*", "\\1", header)
    if (hdr_lbl == header) hdr_lbl <- NA_character_
    label <- if (!is.na(yaml_lbl)) yaml_lbl else hdr_lbl

    # code lines only (skip chunk options and closing ```)
    code <- chunk_lines[!grepl("^#\\|", chunk_lines) & !grepl("^```\\s*$", chunk_lines)]
    # expand tabs before measuring (knitr uses tabstop=4)
    widths <- nchar(vapply(code, expand_tabs, character(1), USE.NAMES = FALSE))
    wide   <- which(widths > WIDTH_LIMIT)
    for (w in wide) {
      rows <- c(rows, list(data.frame(
        chapter  = get_chapter(file),
        file     = file,
        chunk_line = s,           # opening ``` line in the file
        code_line  = s + w,       # absolute line number of the wide line
        label    = ifelse(is.na(label), "", label),
        width    = widths[w],
        text     = code[w],
        stringsAsFactors = FALSE
      )))
    }
  }
  do.call(rbind, Filter(Negate(is.null), rows))
}

# Run ------------------------------------------------------------------------
result <- do.call(rbind, lapply(active_files, scan_file))

if (is.null(result) || nrow(result) == 0) {
  cat("No code lines exceed", WIDTH_LIMIT, "characters.\n")
} else {
  result <- result[order(result$chapter, result$code_line), ]
  rownames(result) <- NULL

  cat(sprintf("Lines exceeding %d chars: %d across %d files\n\n",
              WIDTH_LIMIT, nrow(result), length(unique(result$file))))

  # Summary by file
  cat("By file:\n")
  print(sort(table(result$file), decreasing = TRUE))
  cat("\n")

  # Full listing
  cat(sprintf("%-40s %-10s  %5s  %s\n", "file:line", "chunk", "width", "text"))
  cat(strrep("-", 105), "\n")
  for (i in seq_len(nrow(result))) {
    r <- result[i, ]
    loc <- sprintf("%s:%d", r$file, r$code_line)
    cat(sprintf("%-40s %-10s  %5d  %s\n",
                substr(loc, 1, 40),
                substr(r$label, 1, 10),
                r$width,
                substr(r$text, 1, 55)))
  }
}
