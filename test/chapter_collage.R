# Thumbnail overview of every figure in one book chapter, via
# myutil::magick_collage(). Figures are ordered by their appearance in the
# chapter's .qmd source (`#| label: fig-*`), not alphabetically by filename
# -- e.g. in ch03, "fig-davis-diagnostic-1.png" would otherwise sort before
# "fig-davis-reg1-1.png"/"fig-davis-reg2-1.png", even though the diagnostic
# plot appears later in the chapter.
#
# Each chapter's fig.path (e.g. "figs/ch03/") is set via
# knitr::opts_chunk$set() near the top of its .qmd file -- the file-finding
# logic below still supports a chapter spanning more than one source file
# (matching every root-level .qmd that sets a given fig.path), but as of
# 2026-08-31 every chapter maps 1:1 to a single file. That used to include
# 04b-higher.qmd (also writing into figs/ch04/), which was draft material
# never actually used in the book; it's been moved to working-text/ (outside
# this scan, which only looks at the project root, non-recursively) so it
# stops showing up in ch04's figure list.
#
# chapter_figs_ordered() only covers R-generated figures under figs/<chapter>/.
# A chapter can also embed static images from images/ directly via
# knitr::include_graphics() (book covers, historical diagrams, etc.) -- those
# never land in figs/<chapter>/, so they're invisible to chapter_figs_ordered().
# chapter_figs(type = "all") covers both, interleaved in true source order.
# Only intended for top-level book chapters (the ones listed in _quarto.yml),
# not child/*.qmd includes or appendix/test files.

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

# ---- type = "all" internals ------------------------------------------

#' Which .qmd file(s) set fig.path for this chapter -- same detection
#' chapter_figs_ordered() uses inline; factored out here so chapter_figs()
#' doesn't have to duplicate the fig.path regex separately.
.find_chapter_qmds <- function(chapter, book_dir) {
  qmd_files <- list.files(book_dir, pattern = "\\.qmd$", full.names = TRUE)
  fig_path_pat <- paste0('fig\\.path\\s*=\\s*"figs/', chapter, '/"')
  sort(qmd_files[vapply(qmd_files, function(f) {
    any(grepl(fig_path_pat, readLines(f, warn = FALSE)))
  }, logical(1))])
}

#' Info-only note for an include_graphics() call that couldn't be resolved
#' to exactly one literal image path (most commonly a conditional expression
#' picking between e.g. a .pdf and a .png by output format).
.report_skipped <- function(file, line_no, text) {
  message("Skipped include_graphics() at ", basename(file), ":", line_no,
          " -- not a plain literal path: ", trimws(text))
}

#' A resolved static-image path to add to the ordered list -- unless it's an
#' animated .gif, which a static collage can't represent (there's no single
#' "the" frame); those are left out entirely, reported for info only, rather
#' than silently dropped or arbitrarily picking one frame.
#' @return the path as a length-1 character vector, or character(0) if skipped
.add_static_image <- function(path, file, line_no) {
  if (grepl("\\.gif$", path, ignore.case = TRUE)) {
    message("Skipped animated GIF at ", basename(file), ":", line_no,
            " -- not represented in a static collage: ", path)
    return(character(0))
  }
  path
}

#' Figures for one chapter, in true source order, covering both
#' figs/<chapter>/*.png (R-generated) and static images/*.png|jpg|... embedded
#' via a literal knitr::include_graphics("images/...") or
#' here::here("images", "...") call. Used by chapter_figs(type = "all").
#'
#' Doesn't attempt <img> tags, pandoc `![]()` syntax, or a conditional
#' include_graphics() call (e.g. picking .pdf vs .png by output format) --
#' those are skipped with a message (see .report_skipped()) rather than
#' guessed at.
.chapter_figs_all <- function(chapter, book_dir = ".") {
  figs_dir <- file.path(book_dir, "figs", chapter)
  pngs <- list.files(figs_dir, pattern = "\\.png$")

  source_qmds <- .find_chapter_qmds(chapter, book_dir)
  if (length(source_qmds) == 0) {
    warning("No .qmd file sets fig.path for '", chapter, "' -- falling back to chapter_figs_ordered()")
    return(chapter_figs_ordered(chapter, book_dir))
  }

  used <- character(0)
  ordered <- character(0)

  for (f in source_qmds) {
    lines <- readLines(f, warn = FALSE)

    for (i in seq_along(lines)) {
      ln <- lines[i]

      lab <- regmatches(ln, regexpr("(?<=#\\|\\s{0,3}label:\\s)fig-[[:alnum:]_-]+", ln, perl = TRUE))
      if (!length(lab)) {
        lab <- trimws(regmatches(ln, regexpr("(?<=```\\{r[ ,])\\s*fig-[[:alnum:]_-]+", ln, perl = TRUE)))
      }
      if (length(lab) && nzchar(lab)) {
        hits <- pngs[grepl(paste0("^", lab, "-[0-9]+\\.png$"), pngs)]
        hits <- hits[order(as.integer(sub(paste0("^", lab, "-([0-9]+)\\.png$"), "\\1", hits)))]
        if (length(hits)) {
          ordered <- c(ordered, file.path(figs_dir, hits))
          used <- c(used, hits)
        }
        next
      }

      if (grepl("include_graphics", ln, fixed = TRUE)) {
        # The call can wrap across lines (most notably a conditional picking
        # between two literal paths by output format) -- gather forward to
        # the closing paren, up to a handful of lines, before deciding.
        call_lines <- ln
        j <- i
        while (!grepl("\\)\\s*$", call_lines[length(call_lines)]) && j < min(i + 6, length(lines))) {
          j <- j + 1
          call_lines <- c(call_lines, lines[j])
        }
        call_text <- paste(call_lines, collapse = " ")
        imgs <- regmatches(call_text, gregexpr('images/[^"\')]+', call_text, perl = TRUE))[[1]]

        if (length(imgs) == 1) {
          ordered <- c(ordered, .add_static_image(file.path(book_dir, imgs), f, i))
        } else if (length(imgs) == 0) {
          m <- regmatches(call_text, regexpr('here::here\\(\\s*"images"\\s*,\\s*"[^"]+"', call_text, perl = TRUE))
          if (length(m) && nzchar(m)) {
            fn <- sub('.*,\\s*"([^"]+)".*', "\\1", m)
            ordered <- c(ordered, .add_static_image(file.path(book_dir, "images", fn), f, i))
          } else {
            .report_skipped(f, i, ln)
          }
        } else {
          .report_skipped(f, i, ln)  # ambiguous, e.g. a conditional with two branches
        }
      }
    }
  }

  leftover <- sort(setdiff(pngs, used))
  if (length(leftover)) {
    message("Not traced to a fig-* label in ", chapter, ", appended at the end: ",
            paste(leftover, collapse = ", "))
  }

  c(ordered, file.path(figs_dir, leftover))
}

#' Figures for one chapter, ordered as they appear in its .qmd source(s)
#'
#' @param chapter chapter folder name under figs/, e.g. `"ch03"`
#' @param book_dir book project root
#' @param type `"figs"` (default) -- R-generated figures under
#'   `figs/<chapter>/` only, i.e. [chapter_figs_ordered()]. `"all"` -- also
#'   includes static images embedded via a literal
#'   `knitr::include_graphics("images/...")` call, interleaved in source
#'   order; see [.chapter_figs_all()] for what that does and doesn't catch.
#' @return character vector of image paths, in source order
chapter_figs <- function(chapter, book_dir = ".", type = c("figs", "all")) {
  type <- match.arg(type)
  if (type == "figs") chapter_figs_ordered(chapter, book_dir)
  else .chapter_figs_all(chapter, book_dir)
}

#' Thumbnail collage of all figures in one chapter
#'
#' @param chapter chapter folder name under figs/, e.g. `"ch03"`
#' @param book_dir book project root
#' @param type passed to [chapter_figs()] -- `"figs"` (default) for
#'   R-generated figures only, `"all"` to also include static images/*
#'   embedded via `knitr::include_graphics()`
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
chapter_collage <- function(chapter, book_dir = ".", type = c("figs", "all"), geometry = "x250+5+5", ...) {
  type <- match.arg(type)
  files <- chapter_figs(chapter, book_dir, type = type)
  columns <- ceiling(sqrt(length(files)))
  out_file <- file.path(book_dir, "images", paste0(chapter, "_collage.jpg"))
  myutil::magick_collage(files = files, columns = columns, geometry = geometry,
                          out_file = out_file, ...)
}

# ---- demo ----
if (FALSE) {
  chapter_collage("ch03")
  chapter_collage("ch01", type = "all")
}
