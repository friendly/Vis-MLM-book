#' ---
#' title: Generate Rcode.qmd -- R code appendix listing fig.code files per chapter
#' ---
#'
#' Reads chapter order from _quarto.yml, scans each .qmd (and any child files
#' it includes) for normalised <!-- fig.code: R/... --> comments, then writes
#' Rcode.qmd with one section per chapter listing the R files with GitHub links.
#'
#' R files with a  #' title: ...  header get their title shown.
#' Missing files or missing titles are flagged with a warning symbol.
#'
#' Usage (from project root):
#'   source("issues/make-rcode-appendix.R")

library(yaml)

GITHUB_BASE <- "https://github.com/friendly/vis-MLM-book/blob/master/"
FIGCODE_RX  <- "<!--\\s*fig\\.code:\\s*(R/\\S+\\.R)\\s*-->"

# ------------------------------------------------------------------
# 1. Parse chapter list from _quarto.yml (in order)
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

appendix_files <- if (!is.null(cfg$book$appendices)) {
  app <- unlist(cfg$book$appendices)
  app[grepl("\\.qmd$", app)]
} else character(0)

all_files <- c(chapter_files, appendix_files)

# Build actual chapter-number lookup from position in the ordered chapter list.
# Preamble (index.qmd, 00-Author.qmd) and end-matter (91-*, 95-*) get no number.
preamble_rx  <- "^(index\\.qmd|00-.*\\.qmd)"
endmatter_rx <- "^(9[0-9]-.*\\.qmd)"
numbered_chapters <- chapter_files[
  !grepl(preamble_rx, chapter_files) & !grepl(endmatter_rx, chapter_files)
]
ch_num_lookup <- setNames(seq_along(numbered_chapters), numbered_chapters)

# ------------------------------------------------------------------
# 2. Helper functions
# ------------------------------------------------------------------

# Chapter title: first "# Title {#label}" heading in the .qmd
get_chapter_title <- function(qmd) {
  lines <- readLines(qmd, warn = FALSE)
  # skip YAML front matter if present
  if (length(lines) && trimws(lines[1]) == "---") {
    end <- which(trimws(lines[-1]) == "---")[1] + 1
    if (!is.na(end)) lines <- lines[seq(end + 1, length(lines))]
  }
  hit <- grep("^#\\s+", lines, value = TRUE)[1]
  if (is.na(hit)) return(tools::file_path_sans_ext(basename(qmd)))
  title <- sub("^#+\\s+", "", hit)
  trimws(sub("\\s*\\{[^}]*\\}\\s*$", "", title))   # strip {#sec-...}
}

# Section heading: "Chapter N: Title", "Appendix: Title", or plain title.
# Uses actual position in book.chapters (not filename prefix) for chapter number,
# and the book.appendices membership for the "Appendix" label.
make_chapter_heading <- function(qmd, title, ch_num_lookup, appendix_files) {
  if (qmd %in% appendix_files) return(sprintf("Appendix: %s", title))
  num <- ch_num_lookup[qmd]
  if (!is.na(num)) return(sprintf("Chapter %d: %s", num, title))
  title   # preamble / end-matter (index.qmd, colophon, references)
}

# Child .qmd files included via {{< include child/... >}} or {r child="child/..."}
get_child_files <- function(qmd) {
  lines <- readLines(qmd, warn = FALSE)

  # Quarto shortcode: {{< include child/foo.qmd >}}
  hits1 <- regmatches(lines,
             gregexpr("\\{\\{<\\s*include\\s+(child/\\S+\\.qmd)\\s*>\\}\\}", lines))
  paths1 <- unlist(hits1)
  paths1 <- sub(".*include\\s+(child/\\S+\\.qmd).*", "\\1", paths1[nchar(paths1) > 0])

  # knitr chunk option: ```{r child="child/foo.qmd"} or child='child/foo.qmd'
  hits2 <- regmatches(lines,
             gregexpr("child\\s*=\\s*[\"'](child/[^\"']+\\.qmd)[\"']", lines))
  paths2 <- unlist(hits2)
  paths2 <- sub(".*child\\s*=\\s*[\"'](child/[^\"']+\\.qmd)[\"'].*", "\\1", paths2[nchar(paths2) > 0])

  unique(c(paths1, paths2))
}

# fig.code paths from one file (unique, preserving order)
get_figcodes <- function(qmd) {
  if (!file.exists(qmd)) return(character(0))
  lines <- readLines(qmd, warn = FALSE)
  hits  <- regmatches(lines, regexpr(FIGCODE_RX, lines, perl = TRUE))
  paths <- sub(FIGCODE_RX, "\\1", hits[nchar(hits) > 0], perl = TRUE)
  unique(paths)
}

# Title from R file's #' title: line (first 10 lines)
get_r_title <- function(rfile) {
  if (!file.exists(rfile)) return(NA_character_)
  lines <- readLines(rfile, n = 10, warn = FALSE)
  hit   <- grep("^#'\\s*title:", lines, value = TRUE)[1]
  if (is.na(hit)) return(NA_character_)
  trimws(sub("^#'\\s*title:\\s*", "", hit))
}

# Utility files sourced within an R script, normalised to "R/..." paths.
# Handles:
#   source("R/foo.R")                             — simple relative path
#   source(here::here("R/foo.R"))                 — here(), single-string form
#   source(here::here("R", "foo.R"))              — here(), two-arg form
#   source(here::here("R", "util", "foo.R"))      — here(), three-or-more-arg form
# Skips commented-out lines and absolute/external paths.
get_sourced_files <- function(rfile) {
  if (!file.exists(rfile)) return(character(0))
  lines <- readLines(rfile, warn = FALSE)
  # Remove full-line comments
  lines <- lines[!grepl("^\\s*#", lines)]
  text  <- paste(lines, collapse = "\n")

  found <- character(0)

  # Pattern 1: source("R/foo.R") — simple relative path starting with R/
  m1 <- gregexpr('source\\s*\\(\\s*["\']([^"\']+\\.R)["\']', text, perl = TRUE)
  hits1 <- regmatches(text, m1)[[1]]
  if (length(hits1)) {
    paths <- sub('.*["\']([^"\']+\\.R)["\'].*', "\\1", hits1)
    found <- c(found, paths[grepl("^R/", paths)])
  }

  # Pattern 2: source(here[::here]("R/path/foo.R")) — single-string form
  # Must start with "R/" to avoid matching non-project paths
  m2 <- gregexpr('source\\s*\\(\\s*here(?:::here)?\\s*\\(\\s*["\']([^"\']+\\.R)["\']',
                 text, perl = TRUE)
  hits2 <- regmatches(text, m2)[[1]]
  if (length(hits2)) {
    paths <- sub('.*["\']([^"\']+\\.R)["\'].*', "\\1", hits2)
    found <- c(found, paths[grepl("^R/", paths)])
  }

  # Pattern 3: source(here[::here]("R", "sub", ..., "foo.R")) — multi-arg form.
  # Extract the full argument list, pull out all quoted strings, and join with /.
  # First arg must be "R" for the result to be an R/ path.
  m3 <- gregexpr('source\\s*\\(\\s*here(?:::here)?\\s*\\(([^)]+)\\)',
                 text, perl = TRUE)
  hits3 <- regmatches(text, m3)[[1]]
  if (length(hits3)) {
    for (h in hits3) {
      # Extract the content inside here(...)
      inner <- sub('.*here(?:::here)?\\s*\\(([^)]+)\\).*', "\\1", h, perl = TRUE)
      # Pull out all quoted strings in order
      parts <- regmatches(inner, gregexpr('["\'][^"\']+["\']', inner))[[1]]
      parts <- gsub('["\']', "", parts)
      if (length(parts) >= 2 && parts[1] == "R") {
        found <- c(found, paste(parts, collapse = "/"))
      }
    }
  }

  unique(found)
}

# ------------------------------------------------------------------
# 3. Collect data per chapter
# ------------------------------------------------------------------
chapter_data <- list()

for (qmd in all_files) {
  if (!file.exists(qmd)) {
    warning("chapter file not found: ", qmd)
    next
  }

  children <- get_child_files(qmd)
  figcodes  <- unique(unlist(lapply(c(qmd, children), get_figcodes)))
  if (!length(figcodes)) next

  entries <- lapply(figcodes, function(path) {
    list(path   = path,
         title  = get_r_title(path),
         exists = file.exists(path))
  })

  ch_title <- get_chapter_title(qmd)
  chapter_data[[qmd]] <- list(
    heading = make_chapter_heading(qmd, ch_title, ch_num_lookup, appendix_files),
    entries = entries
  )
}

# ------------------------------------------------------------------
# 3.5 Collect utility files sourced by the cited R scripts
#     AND sourced directly in chapter/child .qmd files
# ------------------------------------------------------------------

# Infrastructure files sourced in every chapter — omit from utilities listing.
SKIP_UTILS <- c("R/common.R")

cited_paths <- unique(unlist(lapply(chapter_data, function(ch)
  sapply(ch$entries, `[[`, "path"))))

# Source() calls found inside the cited R scripts
utility_from_rscripts <- unique(unlist(lapply(cited_paths, get_sourced_files)))

# Source() calls found directly inside chapter and child .qmd files.
# get_sourced_files() works on any text file; .qmd R code chunks are plain R.
all_qmd_files <- unique(c(all_files,
                           unlist(lapply(all_files, get_child_files))))
utility_from_qmds <- unique(unlist(lapply(all_qmd_files, get_sourced_files)))
utility_from_qmds <- setdiff(utility_from_qmds, SKIP_UTILS)

utility_paths <- unique(c(utility_from_rscripts, utility_from_qmds))
# Remove any path that is already a cited chapter-figure script
utility_paths <- setdiff(utility_paths, cited_paths)

utility_entries <- lapply(utility_paths, function(path) {
  list(path   = path,
       title  = get_r_title(path),
       exists = file.exists(path))
})

# ------------------------------------------------------------------
# 4. Write 30-Rcode.qmd
# ------------------------------------------------------------------
n_chapters <- length(chapter_data)
n_files    <- sum(sapply(chapter_data, function(x) length(x$entries)))

con <- file("30-Rcode.qmd", "w")

cat('# R Code for Figures and Analyses {#sec-Rcode}

This online appendix lists the R source files used to produce some of the figures and analyses in each chapter, with links to the source code on GitHub.

This is included here because it may be useful to readers to see the complete context in which many examples were developed, beyond the code displayed in the text. And also because you may want to use or adapt the code for your own work or to develop related examples using the same ideas with different datasets.

It is incomplete because it was constructed by scanning the chapter source files for special comments,
of the form `<!-- fig.code: R/Davis-reg.R -->` that were manually embedded in the chapter `.qmd` files as I wrote this, but not always.
Making this less incomplete proved to be a challenge because it involved scanning the text to find the corresponding R code files that had been included that had been included in chunks.

Files marked &#9888; (if any) do not yet have a descriptive title in their header.

', file = con)

for (ch in chapter_data) {
  cat(sprintf("## %s {.unnumbered}\n\n", ch$heading), file = con)

  for (e in ch$entries) {
    url   <- paste0(GITHUB_BASE, e$path)
    fname <- basename(e$path)

    if (!e$exists) {
      cat(sprintf("- &#9888; `%s` &mdash; *file not found*\n", e$path), file = con)
    } else if (is.na(e$title)) {
      cat(sprintf("- &#9888; [%s](%s) &mdash; *no title*\n", fname, url), file = con)
    } else {
      cat(sprintf("- [%s](%s) &mdash; %s\n", fname, url, e$title), file = con)
    }
  }
  cat("\n", file = con)
}

if (length(utility_entries)) {
  cat('## Utilities {.unnumbered}

These R files are `source()`d by one or more of the scripts above or used directly in a chapter.
They define custom functions and helpers, some used across multiple chapters.

', file = con)

  for (e in utility_entries) {
    url   <- paste0(GITHUB_BASE, e$path)
    fname <- basename(e$path)

    if (!e$exists) {
      cat(sprintf("- &#9888; `%s` &mdash; *file not found*\n", e$path), file = con)
    } else if (is.na(e$title)) {
      cat(sprintf("- &#9888; [%s](%s) &mdash; *no title*\n", fname, url), file = con)
    } else {
      cat(sprintf("- [%s](%s) &mdash; %s\n", fname, url, e$title), file = con)
    }
  }
  cat("\n", file = con)
}

close(con)
message(sprintf("Written: 30-Rcode.qmd  (%d chapters, %d R files, %d utilities)",
                n_chapters, n_files, length(utility_entries)))
