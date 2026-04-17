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
#'   source("R/make-rcode-appendix.R")

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

if (!is.null(cfg$book$appendices)) {
  app <- unlist(cfg$book$appendices)
  chapter_files <- c(chapter_files, app[grepl("\\.qmd$", app)])
}

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

# Child .qmd files included via {{< include child/... >}}
get_child_files <- function(qmd) {
  lines <- readLines(qmd, warn = FALSE)
  hits  <- regmatches(lines,
             gregexpr("\\{\\{<\\s*include\\s+(child/\\S+\\.qmd)\\s*>\\}\\}", lines))
  paths <- unlist(hits)
  if (!length(paths)) return(character(0))
  sub(".*include\\s+(child/\\S+\\.qmd).*", "\\1", paths)
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

# ------------------------------------------------------------------
# 3. Collect data per chapter
# ------------------------------------------------------------------
chapter_data <- list()

for (qmd in chapter_files) {
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

  chapter_data[[qmd]] <- list(
    title   = get_chapter_title(qmd),
    entries = entries
  )
}

# ------------------------------------------------------------------
# 4. Write Rcode.qmd
# ------------------------------------------------------------------
n_chapters <- length(chapter_data)
n_files    <- sum(sapply(chapter_data, function(x) length(x$entries)))

lines_out <- c(
  "---",
  'title: "R Code for Figures and Analyses"',
  "---",
  "",
  "This appendix lists the R source files used to produce the figures and",
  "analyses in each chapter, with links to the source code on GitHub.",
  "",
  "Files marked &#9888; do not yet have a descriptive title in their header.",
  ""
)

for (ch in chapter_data) {
  lines_out <- c(lines_out, paste0("## ", ch$title), "")

  for (e in ch$entries) {
    url   <- paste0(GITHUB_BASE, e$path)
    fname <- basename(e$path)

    if (!e$exists) {
      entry <- sprintf("- &#9888; `%s` &mdash; *file not found*", e$path)
    } else if (is.na(e$title)) {
      entry <- sprintf("- &#9888; [%s](%s) &mdash; *no title*", fname, url)
    } else {
      entry <- sprintf("- [%s](%s) &mdash; %s", fname, url, e$title)
    }
    lines_out <- c(lines_out, entry)
  }
  lines_out <- c(lines_out, "")
}

writeLines(lines_out, "Rcode.qmd")
message(sprintf("Written: Rcode.qmd  (%d chapters, %d R files)", n_chapters, n_files))
