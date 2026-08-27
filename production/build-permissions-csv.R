#' ---
#' title: Build permissions-tracking CSV
#' ---
#'
#' Builds production/permissions-tracking.csv, a working dataset for the T&F
#' permissions process (see production/Permissions_guide.pdf and
#' production/task-permissions.md):
#'   1. Identify third-party material   -> pre-filled from fig-permission-list.md
#'   2. Confirm it is necessary         -> `necessary` (manual)
#'   3. Determine copyright status      -> `copyright_status`, `rightsholder_or_route`
#'   4. Apply for permission            -> `applied_date`, `applied_by`, `contact`
#'   5. Document permission             -> `received_date`, `doc_path`
#'   6. Submit permission               -> `submitted_date`
#'
#' Source of truth for *which* images need tracking is the three consolidated
#' tables at the end of production/fig-permission-list.md ("Permission required",
#' "Verify before deciding", and "Flagged for T&F (TFQ)" -- due-diligence
#' cases that can't be resolved from the author's end and are flagged as a
#' question for the publisher rather than claimed NPR or chased as a formal
#' request) -- that file has already been manually vetted against the
#' Permissions guide. This script does not re-derive copyright status; it
#' only (a) parses those tables and (b) cross-references each filename
#' against the .qmd sources to recover the chapter, figure label, and
#' caption-derived source/attribution text, so the result can be tracked as
#' a spreadsheet instead of prose.
#'
#' Usage (from project root):
#'   Rscript production/build-permissions-csv.R

library(stringr)
library(dplyr)
library(purrr)
library(readr)
library(yaml)

PERM_LIST <- "production/fig-permission-list.md"
OUT_CSV   <- "production/permissions-tracking.csv"

# ------------------------------------------------------------------
# 1. Parse the two consolidated tables in fig-permission-list.md
# ------------------------------------------------------------------

md_lines <- readLines(PERM_LIST, warn = FALSE)

is_separator_row <- function(cells) all(str_detect(cells, "^:?-+:?$"))

parse_pipe_table <- function(lines, header_idx) {
  # header_idx points at the "### ..." heading line preceding the table;
  # find the first "|" row after it, skip the header + separator rows.
  start <- header_idx + which(str_detect(lines[(header_idx + 1):length(lines)], "^\\|"))[1]
  i <- start + 2  # skip header row + separator row
  rows <- list()
  while (i <= length(lines) && str_detect(lines[i], "^\\|")) {
    cells <- str_split(lines[i], "\\|")[[1]]
    cells <- str_trim(cells[-c(1, length(cells))])
    rows[[length(rows) + 1]] <- cells
    i <- i + 1
  }
  rows
}

# A table cell can list more than one image (e.g. "`images/tesseract.gif` +
# `images/tesseract-frames.png`"), so expand to one filename per row.
expand_filenames <- function(cell) str_extract_all(cell, "images/[^`~\\s]+")[[1]]

req_header  <- grep("^### Permission required", md_lines)
ver_header  <- grep("^### Verify before deciding", md_lines)
tfq_header  <- grep("^### Flagged for T&F", md_lines)

req_rows <- parse_pipe_table(md_lines, req_header)
required_tbl <- map_dfr(req_rows, function(r) {
  raw_figure <- r[2]
  if (str_detect(raw_figure, "^~~")) return(tibble())  # resolved (strikethrough), skip
  imgs <- expand_filenames(raw_figure)
  if (!length(imgs)) return(tibble())
  tibble(filename = imgs, table_chapter = r[3], rightsholder_or_route = r[4],
         copyright_status = "permission_required", table_notes = r[5])
})

ver_rows <- parse_pipe_table(md_lines, ver_header)
verify_tbl <- map_dfr(ver_rows, function(r) {
  raw_figure <- r[1]
  if (str_detect(raw_figure, "^~~")) return(tibble())
  imgs <- expand_filenames(raw_figure)
  if (!length(imgs)) return(tibble())
  tibble(filename = imgs, table_chapter = r[2], rightsholder_or_route = r[3],
         copyright_status = "verify", table_notes = r[3])
})

tfq_rows <- parse_pipe_table(md_lines, tfq_header)
tfq_tbl <- map_dfr(tfq_rows, function(r) {
  raw_figure <- r[1]
  if (str_detect(raw_figure, "^~~")) return(tibble())
  imgs <- expand_filenames(raw_figure)
  if (!length(imgs)) return(tibble())
  tibble(filename = imgs, table_chapter = r[2], rightsholder_or_route = "flagged for T&F",
         copyright_status = "TFQ", table_notes = r[3])
})

tracked <- bind_rows(required_tbl, verify_tbl, tfq_tbl)

# ------------------------------------------------------------------
# 2. Scan .qmd files for chapter / fig label / fig-cap source text
# ------------------------------------------------------------------

qmd_files <- list.files(".", pattern = "\\.qmd$", recursive = TRUE, full.names = TRUE)
qmd_files <- qmd_files[!str_detect(qmd_files, "^\\./(docs|test|_freeze)/")]
qmd_files <- qmd_files[!str_detect(qmd_files, "\\.claude/worktrees")]

extract_source <- function(cap) {
  if (is.na(cap)) return(NA_character_)
  m <- str_match(cap, "(?i)_?source_?:?\\s*(.*)$")[, 2]
  if (is.na(m)) return(NA_character_)
  str_trim(m)
}

scan_qmd <- function(path) {
  lines <- readLines(path, warn = FALSE)
  out <- list()
  in_chunk   <- FALSE
  in_comment <- FALSE
  chunk_label <- NA_character_
  chunk_cap   <- NA_character_

  for (i in seq_along(lines)) {
    ln <- lines[i]

    # Skip HTML comment blocks (single-line and multi-line) -- e.g. old
    # markdown-image alternatives left commented out beside a live chunk.
    if (in_comment) {
      if (str_detect(ln, "-->")) in_comment <- FALSE
      next
    }
    if (str_detect(ln, "<!--")) {
      if (!str_detect(ln, "-->")) in_comment <- TRUE  # multi-line comment starts
      next                                            # self-contained or opening line: skip
    }

    if (str_detect(ln, "^```\\{r")) { in_chunk <- TRUE; chunk_label <- NA_character_; chunk_cap <- NA_character_; next }
    if (in_chunk && str_detect(ln, "^```\\s*$")) { in_chunk <- FALSE; next }

    if (in_chunk) {
      lab <- str_match(ln, "^#\\|\\s*label:\\s*(\\S+)")[, 2]
      if (!is.na(lab)) chunk_label <- lab
      cap <- str_match(ln, '^#\\|\\s*fig-cap:\\s*"(.*)"\\s*$')[, 2]
      if (!is.na(cap)) chunk_cap <- cap
    }

    if (str_detect(ln, "include_graphics")) {
      # Usual form: include_graphics("images/foo.png") or here::here("images/foo.png")
      img <- str_match(ln, "images/[^\"'\\)]+")[, 1]
      # Two-arg form: here::here("images", "foo.png")
      if (is.na(img)) {
        fn <- str_match(ln, 'here::here\\(\\s*"images"\\s*,\\s*"([^"]+)"')[, 2]
        if (!is.na(fn)) img <- paste0("images/", fn)
      }
      if (!is.na(img)) {
        out[[length(out) + 1]] <- list(file = path, line = i, label = chunk_label,
                                        source = extract_source(chunk_cap), image = img)
      }
    } else if (str_detect(ln, "<img\\s") && str_detect(ln, "images/")) {
      img <- str_match(ln, "images/[^\"'\\)]+")[, 1]
      if (!is.na(img)) {
        out[[length(out) + 1]] <- list(file = path, line = i, label = NA_character_,
                                        source = NA_character_, image = img)
      }
    } else if (str_detect(ln, "!\\[") && str_detect(ln, "\\(images/")) {
      # Pandoc image syntax: ![alt text](images/foo.png){#fig-label ...}
      mds <- str_match_all(ln, "!\\[([^\\]]*)\\]\\((images/[^)]+)\\)(?:\\{[^}]*#(fig-\\S+)[^}]*\\})?")[[1]]
      for (r in seq_len(nrow(mds))) {
        out[[length(out) + 1]] <- list(file = path, line = i,
                                        label = if (is.na(mds[r, 4]) || mds[r, 4] == "") NA_character_ else mds[r, 4],
                                        source = extract_source(mds[r, 2]), image = mds[r, 3])
      }
    }
  }
  bind_rows(out)
}

scanned <- qmd_files |> map(scan_qmd) |> bind_rows()

# `chapter` is just the source filename (e.g. "04-multivariate_plots.qmd") so
# rows sort into chapter order -- trust _quarto.yml, not this prefix, for the
# actual printed chapter number (see CLAUDE.md: file-name prefixes and printed
# chapter numbers diverge for Ch. 15 / the online-only appendix).
scanned <- scanned |>
  mutate(chapter = basename(file))

# ------------------------------------------------------------------
# 3. Join tracked filenames against scanned occurrences (one row per
#    occurrence -- a filename reused across chapters gets one row each)
# ------------------------------------------------------------------

joined <- tracked |>
  left_join(scanned, by = c("filename" = "image"), relationship = "many-to-many")

# Filenames from the tables with no qmd match at all (e.g. embedded only via
# raw <img> in a way the scanner missed, or genuinely not found) still get
# one row, using the table's own chapter text as fallback.
unmatched <- joined |> filter(is.na(file))
matched   <- joined |> filter(!is.na(file))

result <- bind_rows(matched, unmatched) |>
  transmute(
    chapter    = coalesce(chapter, table_chapter),
    fig_label  = label,
    filename,
    source     = coalesce(source, table_notes),
    copyright_status,
    rightsholder_or_route,
    # step 2: confirm third-party material is necessary. Default Y -- decided
    # 2026-08-23 (MF): every figure reused here illustrates a specific point
    # in the text, not decoration; none are candidates for dropping on
    # necessity grounds alone (see task-permissions.md). Override by hand in
    # the CSV only for a genuine individual exception.
    necessary        = "Y",
    # step 4: how to actually reach the rightsholder (CCC/RightsLink,
    # publisher permissions page, direct email/contact, internal-T&F,
    # nearly-ready [a contact exists but isn't a confirmed email/response
    # channel], or manual-followup-needed) -- filled by hand from research,
    # not derivable from fig-permission-list.md. See "Permission requests" in
    # task-permissions.md for the write-up.
    route             = NA_character_,  # step 4
    applied_date      = NA_character_,  # step 4
    applied_by        = NA_character_,  # step 4
    contact           = NA_character_,  # step 4
    received_date     = NA_character_,  # step 5
    doc_path          = NA_character_,  # step 5: path to saved permission evidence
    submitted_date    = NA_character_,  # step 6
    status            = if_else(copyright_status == "TFQ", "flagged for T&F", "not started"),
    notes             = table_notes,
    qmd_file          = file,
    qmd_line          = line
  ) |>
  arrange(chapter, filename)

# ------------------------------------------------------------------
# 4. Merge-preserve: if OUT_CSV already exists, keep the progress columns
#    (route, applied/received/submitted dates and contacts, status, notes)
#    from the existing file for rows that already exist there, instead of
#    resetting them to fresh defaults. Only genuinely new rows -- first
#    time this fig_label/filename pairing has ever been tracked -- get the
#    freshly-computed defaults above.
#
#    Match key: (fig_label, filename) together, NOT fig_label alone --
#    fig_label is not always unique (fig-tesseract covers both
#    tesseract.gif and tesseract-frames.png), so filename disambiguates.
#    Verified unique across the current 21 tracked rows; re-verify (the
#    stopifnot() below will catch it) if that ever stops holding.
#
#    This closes the gap task-permissions.md previously documented as a
#    manual-discipline rule ("don't re-run this while requests are in
#    flight") -- update_permissions() (see update_permissions.R) and this
#    script can now both safely touch the same file in either order.
# ------------------------------------------------------------------

PRESERVE_COLS <- c("necessary", "route", "applied_date", "applied_by", "contact",
                    "received_date", "doc_path", "submitted_date", "status", "notes")

if (file.exists(OUT_CSV)) {
  # read every column as character -- otherwise readr's type-guessing turns
  # a date column into a Date the moment it has real values in it, and the
  # later element-wise assignment below would silently serialize it as a
  # raw day-count integer instead of "YYYY-MM-DD"
  old <- read_csv(OUT_CSV, show_col_types = FALSE, col_types = cols(.default = "c"))

  old_key    <- paste(coalesce(old$fig_label, "NA"), old$filename, sep = "|")
  result_key <- paste(coalesce(result$fig_label, "NA"), result$filename, sep = "|")
  stopifnot(
    "match key is not unique in the existing CSV -- fix before merging" = !anyDuplicated(old_key),
    "match key is not unique in the freshly-built result -- fix before merging" = !anyDuplicated(result_key)
  )

  match_idx <- match(result_key, old_key)
  has_match <- !is.na(match_idx)
  for (col in PRESERVE_COLS) {
    result[[col]][has_match] <- old[[col]][match_idx[has_match]]
  }

  n_preserved <- sum(has_match)
  n_new       <- sum(!has_match)
  message(sprintf("Merge-preserve: %d existing row(s) kept their progress, %d new row(s) got fresh defaults.",
                   n_preserved, n_new))
}

write_csv(result, OUT_CSV, na = "")

message(sprintf("Written: %s (%d rows: %d permission_required, %d verify, %d TFQ)",
                 OUT_CSV, nrow(result),
                 sum(result$copyright_status == "permission_required"),
                 sum(result$copyright_status == "verify"),
                 sum(result$copyright_status == "TFQ")))

n_no_label <- sum(is.na(result$fig_label))
if (n_no_label > 0) {
  message(sprintf("%d row(s) have no fig_label (not in a labeled {r} chunk, or filename not found by the scanner) -- fill in manually.", n_no_label))
}
