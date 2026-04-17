#' ---
#' title: Normalize fig.code comments in .qmd files
#' ---
#'
#' Scans all .qmd files for `<!-- fig.code: ... -->` comments and normalises
#' them to the canonical form: `<!-- fig.code: R/path/to/file.R -->`
#'
#' Also reports: non-R-path entries, missing files, files without #' title: headers.
#'
#' Usage (from project root):
#'   source("R/normalize-figcode.R")   # dry run: shows changes, writes nothing
#'   normalize_figcode(write = TRUE)   # applies changes to .qmd files

normalize_figcode <- function(write = FALSE, root = ".") {

  qmd_files <- c(
    list.files(root,                       pattern = "\\.qmd$", full.names = TRUE),
    list.files(file.path(root, "child"),   pattern = "\\.qmd$", full.names = TRUE)
  )

  # Matches anything of the form <!-- fig.code[...]: ...content... -->
  # Group 1 captures the raw content between the colon and -->
  comment_rx <- "<!--\\s*fig\\.code[^:]*:\\s*(.*?)\\s*-->"

  changes <- list()
  issues  <- list()

  for (f in qmd_files) {
    lines <- readLines(f, warn = FALSE)
    fname <- sub(paste0("^", root, "/?"), "", f)   # path relative to root
    hit   <- grep("fig\\.code", lines)
    if (length(hit) == 0) next

    new_lines    <- lines
    file_changed <- FALSE

    for (i in hit) {
      line <- lines[i]

      # ---- extract raw content ----------------------------------------
      m <- regmatches(line, regexpr(comment_rx, line, perl = TRUE))
      if (length(m) == 0) {
        issues <- c(issues, list(list(
          file = fname, line = i,
          reason = "unrecognised fig.code format",
          text = trimws(line))))
        next
      }

      raw <- sub(comment_rx, "\\1", m, perl = TRUE)

      # ---- clean the path: strip backticks, quotes, extra whitespace --
      path <- gsub('[`"]', "", raw)
      path <- trimws(path)

      # ---- validate -------------------------------------------------------
      if (!grepl("^R/.+\\.R$", path)) {
        issues <- c(issues, list(list(
          file = fname, line = i,
          reason = paste0("not a valid R/ path: '", path, "'"),
          text = trimws(line))))
        next
      }

      # ---- check file exists ----------------------------------------------
      full <- file.path(root, path)
      if (!file.exists(full)) {
        issues <- c(issues, list(list(
          file = fname, line = i,
          reason = paste0("file not found: ", path),
          text = trimws(line))))
        # still normalise the comment so the typo is visible in canonical form
      }

      # ---- check for title block (first 10 lines) -------------------------
      if (file.exists(full)) {
        hdr <- readLines(full, n = 10, warn = FALSE)
        if (!any(grepl("^#'\\s*title:", hdr))) {
          issues <- c(issues, list(list(
            file = fname, line = i,
            reason = paste0("no title: block in ", path),
            text = trimws(line))))
        }
      }

      # ---- build canonical form and record change -------------------------
      canonical <- paste0("<!-- fig.code: ", path, " -->")
      if (trimws(line) != canonical) {
        changes <- c(changes, list(list(
          file = fname, line = i,
          old  = trimws(line),
          new  = canonical)))
        new_lines[i] <- canonical
        file_changed  <- TRUE
      }
    }

    if (file_changed && write) {
      writeLines(new_lines, f)
      message("Written: ", fname)
    }
  }

  # ---- report -------------------------------------------------------------
  mode_tag <- if (write) "(written)" else "(DRY RUN -- not written)"

  if (length(changes) > 0) {
    cat(sprintf("\n=== NORMALISED COMMENTS %s ===\n", mode_tag))
    for (ch in changes) {
      cat(sprintf("  %s  line %d\n    WAS: %s\n    NOW: %s\n",
                  ch$file, ch$line, ch$old, ch$new))
    }
  } else {
    cat("\nNo comment changes needed.\n")
  }

  if (length(issues) > 0) {
    cat("\n=== ISSUES (manual review needed) ===\n")
    for (iss in issues) {
      cat(sprintf("  %s  line %d  [%s]\n    >> %s\n",
                  iss$file, iss$line, iss$reason, iss$text))
    }
  } else {
    cat("No issues found.\n")
  }

  invisible(list(changes = changes, issues = issues))
}

# Run as dry run when sourced directly
normalize_figcode(write = FALSE)
