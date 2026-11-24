# cmyk-contact-sheet.R
#
# Before/after contact sheet of the CMYK conversions made by
# convert-images-cmyk.R, for checking colours that shift too much in SWOP
# (suggestion 4 in issues/image-quality/cmyk-next-steps.md).
#
# For each image converted to CMYK (manifest action "cmyk"), one row shows:
#   left   the original, as it looks on screen now (flattened onto white,
#          embedded profile honoured)
#   middle the soft proof: the actual CMYK pixels from images-cmyk/ (for a PDF
#          output, the image extracted losslessly with pdfimages), converted
#          back to sRGB through the SWOP profile (relative colorimetric), i.e.
#          an on-screen preview of how it should print
#   right  a shift map: darker = bigger colour difference (Delta E 1976,
#          black at 20 or more)
# Rows are sorted by mean colour shift, biggest first. Gray conversions are
# left out (no colour to shift).
#
# Delta E is computed on copies scaled to at most 600 px. As a guide, a mean
# Delta E under about 2-3 is hard to see; dark images score high partly because
# SWOP's deepest black is lighter than screen black, which is expected in print.
#
# Output (in --out, default issues/image-quality/cmyk-contact-sheet/):
#   cmyk-contact-sheet.pdf   the sheet, 5 images per page
#   cmyk-shift-scores.csv    per-image scores
#
# Requires ImageMagick 7 (`magick`), pdfimages (poppler), the SWOP profile
# (same lookup as convert-images-cmyk.R) and the OS's sRGB profile.
#
# Usage, from the project root, after convert-images-cmyk.R:
#   Rscript issues/image-quality/cmyk-contact-sheet.R [--out=DIR] [--cmyk=DIR]

args <- commandArgs(trailingOnly = TRUE)
opt_value <- function(name, default) {
  hit <- grep(paste0("^--", name, "="), args, value = TRUE)
  if (length(hit)) sub(paste0("^--", name, "="), "", hit[1]) else default
}
cmyk_dir <- opt_value("cmyk", "images-cmyk")
out_dir  <- opt_value("out", "issues/image-quality/cmyk-contact-sheet")

if (!file.exists("_quarto.yml")) stop("Run this from the project root.")
manifest_file <- file.path(cmyk_dir, "manifest.csv")
if (!file.exists(manifest_file)) stop(manifest_file, " not found: run convert-images-cmyk.R first.")

magick    <- Sys.which("magick")
pdfimages <- Sys.which("pdfimages")
if (!nzchar(magick))    stop("ImageMagick 7 (`magick`) not found on PATH.")
if (!nzchar(pdfimages)) stop("pdfimages (poppler) not found on PATH.")

first_existing <- function(paths) {
  paths <- paths[nzchar(paths)]
  hit <- paths[file.exists(paths)]
  if (length(hit)) normalizePath(hit[1], winslash = "/") else NA_character_
}
cmyk_profile <- first_existing(c(
  Sys.getenv("CMYK_PROFILE"), "USWebCoatedSWOP.icc",
  "C:/Program Files/Common Files/Adobe/Color/Profiles/Recommended/USWebCoatedSWOP.icc",
  "/Library/Application Support/Adobe/Color/Profiles/Recommended/USWebCoatedSWOP.icc",
  path.expand("~/Library/ColorSync/Profiles/USWebCoatedSWOP.icc"),
  "/Library/ColorSync/Profiles/USWebCoatedSWOP.icc"))
srgb_profile <- first_existing(c(
  Sys.getenv("SRGB_PROFILE"),
  "/System/Library/ColorSync/Profiles/sRGB Profile.icc",
  "C:/Windows/System32/spool/drivers/color/sRGB Color Space Profile.icm",
  "/usr/share/color/icc/colord/sRGB.icc", "/usr/share/color/icc/sRGB.icc"))
if (is.na(cmyk_profile) || is.na(srgb_profile)) stop("ICC profile(s) not found.")

# A font file for labels (ImageMagick can't always resolve font names)
font_file <- first_existing(c(
  "/System/Library/Fonts/Supplemental/Arial.ttf",
  "C:/Windows/Fonts/arial.ttf",
  "/usr/share/fonts/truetype/dejavu/DejaVuSans.ttf",
  "/usr/share/fonts/dejavu/DejaVuSans.ttf"))
font_arg <- if (is.na(font_file)) character(0) else c("-font", font_file)

run <- function(cmd, argv) {
  out <- suppressWarnings(system2(cmd, shQuote(argv), stdout = TRUE, stderr = TRUE))
  s <- attr(out, "status")
  if (!is.null(s) && s != 0) stop(basename(cmd), " failed:\n", paste(out, collapse = "\n"))
  out
}

man <- read.csv(manifest_file, stringsAsFactors = FALSE)
man <- man[man$action == "cmyk", ]
if (!nrow(man)) stop("No CMYK conversions in the manifest.")

work <- tempfile("contact-")
dir.create(work)
dir.create(out_dir, recursive = TRUE, showWarnings = FALSE)

size <- "600x600>"   # working size for scoring and display

# Read an 8-bit sRGB image file into an n x 3 matrix (0-1) plus its size
read_rgb <- function(png) {
  wh <- as.integer(strsplit(run(magick, c("identify", "-format", "%w %h", png)), " ")[[1]])
  raw_file <- file.path(work, "px.rgb")
  run(magick, c(png, "-depth", "8", paste0("rgb:", raw_file)))
  v <- as.integer(readBin(raw_file, "raw", n = file.size(raw_file)))
  list(w = wh[1], h = wh[2], rgb = matrix(v, ncol = 3, byrow = TRUE) / 255)
}

scores <- vector("list", nrow(man))
rows <- character(nrow(man))

for (i in seq_len(nrow(man))) {
  m <- man[i, ]
  cat(sprintf("[%2d/%d] %s\n", i, nrow(man), m$source))
  tag <- sprintf("%03d", i)
  orig  <- file.path(work, paste0(tag, "-orig.png"))
  proof <- file.path(work, paste0(tag, "-proof.png"))
  smap  <- file.path(work, paste0(tag, "-map.png"))

  # Original as seen on screen: flattened, converted to sRGB if tagged
  run(magick, c(paste0(m$source, "[0]"), "-background", "white", "-alpha", "remove",
                "-alpha", "off", "-type", "TrueColor", "-profile", srgb_profile,
                "-resize", size, orig))
  wh <- run(magick, c("identify", "-format", "%wx%h!", orig))

  # The CMYK pixels actually written to images-cmyk/
  cmyk_src <- if (grepl("\\.pdf$", m$output)) {
    prefix <- file.path(work, paste0(tag, "-x"))
    run(pdfimages, c("-tiff", "-f", "1", "-l", "1", m$output, prefix))
    tifs <- Sys.glob(paste0(prefix, "-*.tif"))
    if (length(tifs) != 1) stop("Expected 1 image in ", m$output, ", found ", length(tifs))
    tifs
  } else m$output
  run(magick, c(paste0(cmyk_src, "[0]"), "-intent", "Relative",
                "-profile", cmyk_profile, "-profile", srgb_profile,
                "-resize", wh, proof))

  # Colour difference (Delta E 1976 in CIE Lab, D65)
  a <- read_rgb(orig)
  b <- read_rgb(proof)
  if (a$w != b$w || a$h != b$h) stop("Size mismatch for ", m$source)
  la <- grDevices::convertColor(a$rgb, from = "sRGB", to = "Lab")
  lb <- grDevices::convertColor(b$rgb, from = "sRGB", to = "Lab")
  de <- sqrt(rowSums((la - lb)^2))
  scores[[i]] <- data.frame(
    source = m$source, output = m$output,
    mean_dE = round(mean(de), 1), p95_dE = round(unname(quantile(de, 0.95)), 1),
    pct_over_10 = round(100 * mean(de > 10), 1),
    mean_chroma_loss = round(mean(sqrt(rowSums(la[, 2:3]^2)) - sqrt(rowSums(lb[, 2:3]^2))), 1),
    stringsAsFactors = FALSE)

  # Shift map: white = no change, black = Delta E >= 20
  g <- as.raw(round(255 * (1 - pmin(de, 20) / 20)))
  map_raw <- file.path(work, "map.gray")
  writeBin(g, map_raw)
  run(magick, c("-size", paste0(a$w, "x", a$h), "-depth", "8",
                paste0("gray:", map_raw), smap))

  rows[i] <- tag
}

sc <- do.call(rbind, scores)
sc$tag <- rows
sc <- sc[order(-sc$mean_dE), ]
write.csv(sc[, setdiff(names(sc), "tag")], file.path(out_dir, "cmyk-shift-scores.csv"),
          row.names = FALSE)

# One panel row per image: label above, three equal-height tiles
panel_h <- 300
label_font <- c(font_arg, "-pointsize", "18")
row_files <- character(nrow(sc))
for (k in seq_len(nrow(sc))) {
  t <- sc$tag[k]
  lab <- sprintf("%d. %s    mean \u0394E %.1f   95%% \u0394E %.1f   %.0f%% of pixels > 10   chroma loss %.1f",
                 k, sub("^images/", "", sc$source[k]), sc$mean_dE[k], sc$p95_dE[k],
                 sc$pct_over_10[k], sc$mean_chroma_loss[k])
  tiles <- file.path(work, paste0(t, c("-orig.png", "-proof.png", "-map.png")))
  row_files[k] <- file.path(work, sprintf("row-%03d.png", k))
  run(magick, c(
    "(", tiles[1], "-resize", paste0("x", panel_h), ")",
    "(", tiles[2], "-resize", paste0("x", panel_h), ")",
    "(", tiles[3], "-resize", paste0("x", panel_h), ")",
    "-bordercolor", "white", "-border", "8", "+append",
    "-resize", "1500x>",
    "(", "-size", "1500x34", "xc:white", label_font, "-gravity", "west",
         "-annotate", "+8+0", lab, ")",
    "+swap", "-background", "white", "-gravity", "west", "-append",
    "+repage", "-alpha", "off",
    row_files[k]))
}

# Pages: header + 5 rows, letter-ish aspect, JPEG-compressed for a sane size
per_page <- 5
pages <- split(row_files, ceiling(seq_along(row_files) / per_page))
header <- "CMYK conversion check (US Web Coated SWOP v2)    left: original on screen    middle: soft proof of the CMYK file    right: shift map (darker = bigger shift)"
page_files <- character(length(pages))
for (p in seq_along(pages)) {
  page_files[p] <- file.path(work, sprintf("page-%02d.png", p))
  run(magick, c(
    "(", "-size", "1500x40", "xc:white", font_arg, "-pointsize", "16",
         "-gravity", "west", "-annotate", "+8+0",
         sprintf("%s    page %d/%d", header, p, length(pages)), ")",
    pages[[p]], "-background", "white", "-gravity", "west", "-append",
    "-gravity", "north", "-extent", "1500x1900",
    # +repage: otherwise the page keeps the header strip's canvas size,
    # and the PDF pages come out 1500x40 px
    "+repage", "-alpha", "off",
    page_files[p]))
}
pdf_out <- file.path(out_dir, "cmyk-contact-sheet.pdf")
run(magick, c(page_files, "+repage", "-units", "PixelsPerInch", "-density", "150",
              "-compress", "JPEG", "-quality", "85", pdf_out))

unlink(work, recursive = TRUE)
cat(sprintf("\n%d images. Contact sheet: %s\nScores: %s\n", nrow(sc), pdf_out,
            file.path(out_dir, "cmyk-shift-scores.csv")))
cat("\nTop 10 by mean colour shift:\n")
print(head(sc[, c("source", "mean_dE", "p95_dE", "pct_over_10", "mean_chroma_loss")], 10),
      row.names = FALSE)
