# cmyk-image-audit.R
# Read-only audit of raster images embedded in the PDF build, per step 3 of
# issues/cmyk-conversion-plan.md. For every images/*.png|jpg|jpeg actually
# reachable in the PDF (excludes when-format="html" blocks and exempt
# formats gif/webp/svg/pptx), reports current colorspace and *effective*
# print DPI — pixel width divided by the image's largest used print width
# in the book, not the (often meaningless) embedded metadata DPI tag.
#
# Requires ImageMagick (`magick`) and xelatex on PATH.
#
# Run from the project root:
#   Rscript issues/cmyk-image-audit.R

library(dplyr)
library(stringr)
library(purrr)

# ── 1. Determine the book's actual \textwidth (krantz class, PDF profile) ──
# _quarto.yml pdf format: documentclass krantz, classoption
# [10pt, krantz2, titlepage, letterpaper], no geometry override.

get_textwidth_in <- function() {
  probe_dir <- tempfile("textwidth-probe-")
  dir.create(probe_dir)
  probe_tex <- file.path(probe_dir, "probe.tex")
  writeLines(c(
    "\\documentclass[10pt,krantz2,titlepage,letterpaper]{krantz}",
    "\\begin{document}",
    "\\typeout{PROBE-TEXTWIDTH=\\the\\textwidth}",
    "\\end{document}"
  ), probe_tex)
  log <- system2("xelatex",
                  c("-interaction=nonstopmode", "-halt-on-error",
                    "-output-directory", shQuote(probe_dir), shQuote(probe_tex)),
                  stdout = TRUE, stderr = TRUE)
  unlink(probe_dir, recursive = TRUE)
  pt <- as.numeric(na.omit(str_match(log, "PROBE-TEXTWIDTH=([0-9.]+)pt")[, 2]))[1]
  if (is.na(pt)) stop("Could not determine \\textwidth from probe compile.")
  pt / 72.27  # TeX points -> inches
}

textwidth_in <- get_textwidth_in()
message(sprintf("Book textwidth: %.3f in (krantz class probe)", textwidth_in))

# ── 2. Find every images/*.png|jpg|jpeg reference reachable in the PDF ─────
# Tracks pandoc fenced-div nesting (:::/::::/:::::) to skip content inside
# when-format="html" blocks, and the nearest preceding `#| out-width:` in
# the current code chunk.

qmd_files <- list.files(".", pattern = "\\.qmd$", recursive = TRUE, full.names = TRUE)
qmd_files <- qmd_files[!str_detect(qmd_files, "^\\./(docs|test|_freeze)/")]

extract_used_images <- function(path) {
  lines <- readLines(path, warn = FALSE)
  fence_stack <- list()
  in_chunk <- FALSE
  pending_width <- NA_character_
  out <- list()

  is_html_only <- function() {
    length(fence_stack) > 0 && any(vapply(fence_stack, `[[`, logical(1), "html_only"))
  }

  for (ln in lines) {
    if (str_detect(ln, "^:{3,}\\s*\\{")) {
      fence_len <- str_length(str_extract(ln, "^:{3,}"))
      html_only <- str_detect(ln, "content-visible") &&
        str_detect(ln, 'when-format\\s*=\\s*"html"')
      fence_stack[[length(fence_stack) + 1]] <-
        list(len = fence_len, html_only = html_only || is_html_only())
      next
    }
    if (str_detect(ln, "^:{3,}\\s*$") && length(fence_stack) > 0) {
      fence_stack[[length(fence_stack)]] <- NULL
      next
    }
    if (str_detect(ln, "^```\\{r")) { in_chunk <- TRUE; pending_width <- NA_character_; next }
    if (in_chunk && str_detect(ln, "^```\\s*$")) { in_chunk <- FALSE; next }

    if (in_chunk) {
      w <- str_match(ln, '#\\|\\s*out-width:\\s*"?([0-9.]+[a-z%]*)"?')[, 2]
      if (!is.na(w)) pending_width <- w
    }

    if (is_html_only()) next  # never reaches the PDF

    m <- str_match(ln, 'include_graphics\\("(images/[^"]+)"\\)')[, 2]
    if (!is.na(m)) {
      out[[length(out) + 1]] <- list(file = m, source = path, out_width = pending_width)
      next
    }
    m2 <- str_match(ln, "\\\\includegraphics(?:\\[[^]]*\\])?\\{(images/[^}]+)\\}")[, 2]
    if (!is.na(m2)) {
      out[[length(out) + 1]] <- list(file = m2, source = path, out_width = NA_character_)
    }
  }
  out
}

used <- qmd_files |> map(extract_used_images) |> flatten() |> bind_rows()

used <- used |>
  mutate(ext = str_to_lower(str_extract(file, "(?<=\\.)[a-zA-Z]+$"))) |>
  filter(ext %in% c("png", "jpg", "jpeg"))  # gif/webp/svg/pptx exempt per CMYK-colors.md

# ── 3. Resolve each image's largest used print width (worst case for DPI) ──

parse_width_in <- function(w, textwidth_in) {
  if (is.na(w)) return(textwidth_in)          # no out-width -> assume full textwidth
  if (str_detect(w, "%$")) {
    return(textwidth_in * as.numeric(str_remove(w, "%")) / 100)
  }
  if (str_detect(w, "in$")) {
    return(as.numeric(str_remove(w, "in")))
  }
  textwidth_in  # unrecognized unit -> conservative full-textwidth default
}

used <- used |>
  rowwise() |>
  mutate(print_width_in = parse_width_in(out_width, textwidth_in)) |>
  ungroup()

worst_case <- used |>
  group_by(file) |>
  slice_max(print_width_in, n = 1, with_ties = FALSE) |>
  ungroup() |>
  arrange(file)

# ── 4. Pixel dimensions + colorspace via ImageMagick ────────────────────────

identify_image <- function(file) {
  if (!file.exists(file)) {
    return(list(width_px = NA_real_, height_px = NA_real_, colorspace = "MISSING"))
  }
  res <- system2("magick", c("identify", "-format", shQuote("%w %h %[colorspace]"), shQuote(file)),
                  stdout = TRUE, stderr = TRUE)
  parts <- str_split(res[1], "\\s+")[[1]]
  list(width_px = as.numeric(parts[1]), height_px = as.numeric(parts[2]), colorspace = parts[3])
}

meta <- worst_case$file |> map(identify_image) |> bind_rows()

report <- bind_cols(worst_case, meta) |>
  mutate(
    effective_dpi = round(width_px / print_width_in, 1),
    flag = case_when(
      colorspace == "MISSING" ~ "MISSING FILE",
      is.na(effective_dpi) ~ "UNKNOWN",
      effective_dpi < 300 ~ "LOW-DPI",
      TRUE ~ "ok"
    )
  ) |>
  select(file, colorspace, width_px, height_px, print_width_in, effective_dpi, flag, out_width, source)

# ── 5. Report ────────────────────────────────────────────────────────────

outfile <- "issues/cmyk-image-audit-results.csv"
write.csv(report, outfile, row.names = FALSE)

cat(sprintf("\n%d unique raster images used in the PDF build.\n", nrow(report)))
cat(sprintf("  %d already CMYK\n", sum(report$colorspace == "CMYK")))
cat(sprintf("  %d sRGB/RGB/Gray (need colorspace conversion)\n",
             sum(report$colorspace %in% c("sRGB", "RGB", "Gray", "sGray"))))
cat(sprintf("  %d flagged LOW-DPI (effective dpi < 300 at largest used size)\n",
             sum(report$flag == "LOW-DPI")))
cat(sprintf("  %d missing file(s)\n", sum(report$flag == "MISSING FILE")))
cat(sprintf("\nFull report -> %s\n\n", outfile))

low_dpi <- report |> filter(flag == "LOW-DPI") |> arrange(effective_dpi)
if (nrow(low_dpi) > 0) {
  cat("LOW-DPI images (need manual review):\n")
  print(low_dpi, n = Inf)
} else {
  cat("No images flagged LOW-DPI.\n")
}
