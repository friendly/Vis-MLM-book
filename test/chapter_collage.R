# Thumbnail overview of every figure in one book chapter, via
# myutil::magick_collage(). Figures are ordered by their appearance in the
# chapter's .qmd source (`#| label: fig-*`), not alphabetically by filename
# -- e.g. in ch03, "fig-davis-diagnostic-1.png" would otherwise sort before
# "fig-davis-reg1-1.png"/"fig-davis-reg2-1.png", even though the diagnostic
# plot appears later in the chapter.
#
# Each chapter's fig.path (e.g. "figs/ch03/") is set via
# knitr::opts_chunk$set() near the top of its .qmd file(s) -- ch04 is split
# across 04-multivariate_plots.qmd and 04b-higher.qmd, both writing into
# figs/ch04/, so a chapter can map to more than one source file.

library(myutil)

#' Figures for one chapter, ordered as they appear in its .qmd source(s)
#'
#' @param chapter chapter folder name under figs/, e.g. `"ch03"`
#' @param book_dir book project root
#' @return character vector of PNG paths, in source order. Any PNG present
#'   in the folder but not traceable to a `#| label: fig-*` chunk (e.g. old
#'   leftover files) is appended at the end, alphabetically, with a message.
chapter_figs_ordered <- function(chapter, book_dir = ".") {
  figs_dir <- file.path(book_dir, "figs", chapter)
  pngs <- list.files(figs_dir, pattern = "\\.png$")
  if (length(pngs) == 0) stop("No PNGs found in ", figs_dir)

  qmd_files <- list.files(book_dir, pattern = "\\.qmd$", full.names = TRUE)
  fig_path_pat <- paste0('fig\\.path\\s*=\\s*"figs/', chapter, '/"')
  source_qmds <- sort(qmd_files[vapply(qmd_files, function(f) {
    any(grepl(fig_path_pat, readLines(f, warn = FALSE)))
  }, logical(1))])

  if (length(source_qmds) == 0) {
    warning("No .qmd file sets fig.path for '", chapter, "' -- falling back to alphabetical order")
    return(file.path(figs_dir, sort(pngs)))
  }

  extract_labels <- function(lines) {
    labs <- character(0)
    for (ln in lines) {
      m <- regmatches(ln, regexpr("(?<=#\\|\\s{0,3}label:\\s)fig-[[:alnum:]_-]+", ln, perl = TRUE))
      if (!length(m)) {
        m <- regmatches(ln, regexpr("(?<=```\\{r[ ,])\\s*fig-[[:alnum:]_-]+", ln, perl = TRUE))
        m <- trimws(m)
      }
      if (length(m) && nzchar(m)) labs <- c(labs, m)
    }
    labs
  }
  labels <- unlist(lapply(source_qmds, function(f) extract_labels(readLines(f, warn = FALSE))))

  used <- character(0)
  ordered <- character(0)
  for (lab in labels) {
    hits <- pngs[grepl(paste0("^", lab, "-[0-9]+\\.png$"), pngs)]
    hits <- hits[order(as.integer(sub(paste0("^", lab, "-([0-9]+)\\.png$"), "\\1", hits)))]
    ordered <- c(ordered, hits)
    used <- c(used, hits)
  }

  leftover <- sort(setdiff(pngs, used))
  if (length(leftover)) {
    message("Not traced to a fig-* label in ", chapter, ", appended at the end: ",
            paste(leftover, collapse = ", "))
  }

  file.path(figs_dir, c(ordered, leftover))
}

#' Thumbnail collage of all figures in one chapter
#'
#' @param chapter chapter folder name under figs/, e.g. `"ch03"`
#' @param book_dir book project root
#' @param geometry passed to [myutil::magick_collage()] -- smaller than the
#'   package default, since this is meant as a compact overview
#' @param ... other arguments passed to [myutil::magick_collage()]
#' @return the collage file path, invisibly
#' @details
#' The collage is written to `images/<chapter>_collage.jpg`, not
#' `figs/<chapter>/` -- `figs/` is knitr's own generated-figure output
#' directory (regenerated, possibly wiped, on a full rebuild), while
#' `images/` is already this book's convention for hand-placed static
#' assets (e.g. `images/anscombe1.png`). Writing the collage into
#' `figs/<chapter>/` would also risk `chapter_figs_ordered()` picking up
#' the collage from a *previous* run as an "orphan" file on the next one.
chapter_collage <- function(chapter, book_dir = ".", geometry = "x250+5+5", ...) {
  files <- chapter_figs_ordered(chapter, book_dir)
  columns <- ceiling(sqrt(length(files)))
  out_file <- file.path(book_dir, "images", paste0(chapter, "_collage.jpg"))
  myutil::magick_collage(files = files, columns = columns, geometry = geometry,
                          out_file = out_file, ...)
}

# ---- demo ----
chapter_collage("ch03")
