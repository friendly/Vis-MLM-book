# convert-images-cmyk.R
#
# Convert the raster images used in the print PDF from RGB to CMYK (US Web
# Coated SWOP v2), writing them to images-cmyk/. Step 5 of
# issues/image-quality/cmyk-conversion-plan.md, as revised in
# issues/image-quality/cmyk-next-steps.md.
#
# The PDF build picks up images-cmyk/ through filters/cmyk-images.lua; the
# HTML build keeps using images/. images-cmyk/ is committed, so building the
# print PDF does not need ImageMagick or the ICC profile. Only re-running this
# script does.
#
# Which images: every images/... or figs/... PNG/JPG path that appears in the
# book's sources: the chapters listed in _quarto.yml plus the child documents
# they pull in (```{r child=...}``` and {{< include >}}), leaving out HTML
# comments, R comment lines and HTML-only fenced divs
# (content-visible when-format="html" / unless-format="pdf",
# content-hidden when-format="pdf"). Paths are mapped as
#     images/<path>  ->  images-cmyk/<path>
#     figs/<path>    ->  images-cmyk/figs/<path>
# (figs/ matters for frozen figures included by path, e.g.
# figs/ch04/fig-peng-ggpairs1-1.png). If Vis-MLM.tex exists it is used as a
# cross-check only: differences are reported, since the .tex can be stale.
#
# What it does, per image:
#
#   colour PNG  -> flatten onto white -> sRGB -> SWOP -> lossless CMYK PDF
#                  <name>.pdf  (PNG cannot store CMYK)
#   colour JPG  -> sRGB -> SWOP -> CMYK JPG, quality 95, no chroma subsampling
#                  <name>.jpg
#   gray content (no pixel's R, G, B differ by more than 2/255) that is
#   stored as RGB, or has an ICC profile, alpha or 16 bits
#               -> plain 8-bit grayscale <name>.png / <name>.jpg
#                  (prints in black ink only, not as 4-colour gray)
#   already 8-bit Gray (or CMYK) with no ICC profile or alpha
#               -> skipped; the PDF uses the original
#
# Embedded profiles and metadata are removed from every output (PNG keeps its
# resolution chunk), so the PDF shows the images as DeviceCMYK / DeviceGray:
# `pdfimages -list` reports "cmyk" / "gray", not "icc".
#
# Safe to re-run: <out>/manifest.csv records the MD5 of each source and of the
# CMYK profile. An image is converted again only when its source or the
# profile changed, or its output is missing. ImageMagick stamps a creation
# date into each PDF, so --force rewrites every PDF even if nothing changed.
# Outputs that no longer belong to any image are reported, never deleted.
#
# Requires ImageMagick 7 (`magick`) on PATH and the yaml package, plus two
# ICC profiles:
#   CMYK: USWebCoatedSWOP.icc. Looked for in the project root (git-ignored,
#         Adobe's licence restricts redistribution), then the usual Adobe and
#         ColorSync folders. Override with env var CMYK_PROFILE.
#   sRGB: the OS's own sRGB profile (macOS, Windows or Linux location).
#         Override with env var SRGB_PROFILE.
#
# Usage, from the project root:
#   Rscript issues/image-quality/convert-images-cmyk.R            # convert
#   Rscript issues/image-quality/convert-images-cmyk.R --dry-run  # list only
# Options:
#   --dry-run        show what would be done, write nothing
#   --force          reconvert everything, ignoring the manifest
#   --only=REGEX     only images whose path matches REGEX (for testing)
#   --out=DIR        output directory (default images-cmyk)
#   --tex=FILE       .tex to cross-check against (default Vis-MLM.tex)

# ── Options ─────────────────────────────────────────────────────────────────

args <- commandArgs(trailingOnly = TRUE)
opt_value <- function(name, default) {
  hit <- grep(paste0("^--", name, "="), args, value = TRUE)
  if (length(hit)) sub(paste0("^--", name, "="), "", hit[1]) else default
}
dry_run <- "--dry-run" %in% args
force   <- "--force" %in% args
only    <- opt_value("only", NA_character_)
out_dir <- opt_value("out", "images-cmyk")
tex     <- opt_value("tex", "Vis-MLM.tex")

known <- c("--dry-run", "--force")
bad <- args[!(args %in% known | grepl("^--(only|out|tex)=", args))]
if (length(bad)) stop("Unknown option(s): ", paste(bad, collapse = " "))

if (!file.exists("_quarto.yml"))
  stop("Run this from the project root (no _quarto.yml here).")

# Normalise the output dir so the manifest is the same however it was typed:
# "./images-cmyk/" -> "images-cmyk"; an absolute path inside the project is
# made relative.
out_dir <- gsub("\\\\", "/", out_dir)
out_dir <- sub("/+$", "", sub("^(\\./)+", "", out_dir))
root <- normalizePath(".", winslash = "/")
if (startsWith(out_dir, paste0(root, "/")))
  out_dir <- substring(out_dir, nchar(root) + 2)

# ── Tools and profiles ──────────────────────────────────────────────────────

magick <- Sys.which("magick")
if (!nzchar(magick)) stop("ImageMagick 7 (`magick`) not found on PATH.")

first_existing <- function(paths) {
  paths <- paths[nzchar(paths)]
  hit <- paths[file.exists(paths)]
  if (length(hit)) normalizePath(hit[1], winslash = "/") else NA_character_
}

cmyk_profile <- first_existing(c(
  Sys.getenv("CMYK_PROFILE"),
  "USWebCoatedSWOP.icc",
  "C:/Program Files/Common Files/Adobe/Color/Profiles/Recommended/USWebCoatedSWOP.icc",
  "/Library/Application Support/Adobe/Color/Profiles/Recommended/USWebCoatedSWOP.icc",
  path.expand("~/Library/ColorSync/Profiles/USWebCoatedSWOP.icc"),
  "/Library/ColorSync/Profiles/USWebCoatedSWOP.icc"
))
if (is.na(cmyk_profile))
  stop("USWebCoatedSWOP.icc not found. Put it in the project root or set CMYK_PROFILE.")

srgb_profile <- first_existing(c(
  Sys.getenv("SRGB_PROFILE"),
  "/System/Library/ColorSync/Profiles/sRGB Profile.icc",
  "C:/Windows/System32/spool/drivers/color/sRGB Color Space Profile.icm",
  "/usr/share/color/icc/colord/sRGB.icc",
  "/usr/share/color/icc/sRGB.icc"
))
if (is.na(srgb_profile))
  stop("No sRGB ICC profile found. Set SRGB_PROFILE to one.")

cmyk_md5 <- unname(tools::md5sum(cmyk_profile))

# Run magick; returns stdout lines, or NULL on failure. stderr is dropped
# unless keep_err, because some -format properties (e.g. %[profiles] on an
# image with none) print harmless warnings that must not be read as output.
run_magick <- function(argv, keep_err = FALSE) {
  out <- suppressWarnings(system2(magick, shQuote(argv), stdout = TRUE,
                                  stderr = keep_err))
  status <- attr(out, "status")
  if (!is.null(status) && status != 0) {
    attr(out, "failed") <- TRUE
  }
  out
}
failed_run <- function(out) isTRUE(attr(out, "failed"))

# ── Image list from the sources ─────────────────────────────────────────────

yml <- yaml::read_yaml("_quarto.yml")
chapter_files <- function(x) {
  if (is.character(x)) return(x[grepl("\\.qmd$", x)])
  if (is.list(x)) return(unlist(lapply(x, chapter_files), use.names = FALSE))
  character(0)
}
chapters <- unique(chapter_files(list(yml$book$chapters, yml$book$appendices)))
if (!length(chapters)) stop("No chapters found under book: in _quarto.yml")

# Live text of a .qmd, with HTML comments, R comment lines and HTML-only
# fenced divs removed. Returns list(text = lines, children = files).
live_lines <- function(path) {
  lines <- readLines(path, warn = FALSE, encoding = "UTF-8")
  txt <- paste(lines, collapse = "\n")
  txt <- gsub("(?s)<!--.*?-->", "", txt, perl = TRUE)   # (?s): span lines
  lines <- strsplit(txt, "\n", fixed = TRUE)[[1]]

  keep <- logical(length(lines))
  children <- character(0)
  stack <- logical(0)          # one entry per open fenced div: html-only?
  in_chunk <- FALSE
  for (i in seq_along(lines)) {
    ln <- lines[i]
    if (!in_chunk && grepl("^:{3,}\\s*\\{", ln)) {
      html <- (grepl("content-visible", ln) && grepl('when-format\\s*=\\s*"html"', ln)) ||
              (grepl("content-visible", ln) && grepl('unless-format\\s*=\\s*"pdf"', ln)) ||
              (grepl("content-hidden", ln) && grepl('when-format\\s*=\\s*"pdf"', ln))
      stack <- c(stack, html || any(stack))
      next
    }
    if (!in_chunk && grepl("^:{3,}\\s*$", ln) && length(stack)) {
      stack <- stack[-length(stack)]
      next
    }
    if (any(stack)) next                       # HTML-only: never in the PDF
    if (grepl("^\\s*```+\\s*\\{r", ln)) {
      in_chunk <- TRUE
      ch <- regmatches(ln, regexec("child\\s*=\\s*[\"']([^\"']+)[\"']", ln))[[1]]
      if (length(ch)) children <- c(children, ch[2])
      next
    }
    if (in_chunk && grepl("^\\s*```+\\s*$", ln)) { in_chunk <- FALSE; next }
    if (in_chunk && grepl("^\\s*#", ln) && !grepl("^\\s*#\\|", ln)) next
    inc <- regmatches(ln, regexec("\\{\\{<\\s*include\\s+([^ >]+)\\s*>\\}\\}", ln))[[1]]
    if (length(inc)) children <- c(children, inc[2])
    keep[i] <- TRUE
  }
  list(text = lines[keep], children = children)
}

image_refs <- function(lines) {
  pat <- "(?<![A-Za-z0-9_./-])(?:images|figs)/[^\\s\"'(){}<>,\\[\\]]+?\\.(?:png|jpe?g)\\b"
  plain <- unlist(regmatches(lines, gregexpr(pat, lines, perl = TRUE, ignore.case = TRUE)))
  # here::here("images", "foo.png") / here::here("images", "sub", "foo.png")
  hh <- unlist(regmatches(lines, gregexpr(
    "here::here\\(\\s*\"(?:images|figs)\"(?:\\s*,\\s*\"[^\"]+\")+\\s*\\)", lines, perl = TRUE)))
  hh <- vapply(regmatches(hh, gregexpr("\"[^\"]+\"", hh)),
               function(p) paste(gsub("\"", "", p), collapse = "/"), character(1))
  c(plain, hh[grepl("\\.(png|jpe?g)$", hh, ignore.case = TRUE)])
}

seen <- character(0)
refs <- character(0)
queue <- chapters
while (length(queue)) {
  f <- queue[1]; queue <- queue[-1]
  if (f %in% seen) next
  seen <- c(seen, f)
  if (!file.exists(f)) { warning("Source file not found: ", f); next }
  if (!grepl("\\.(qmd|Rmd|md)$", f)) next
  l <- live_lines(f)
  refs <- c(refs, image_refs(l$text))
  queue <- c(queue, setdiff(l$children, seen))
}
refs <- unique(refs)

missing <- refs[!file.exists(refs)]
if (length(missing))
  warning("Referenced in the sources but not found (ignored):\n  ",
          paste(missing, collapse = "\n  "), call. = FALSE)
src <- sort(refs[file.exists(refs)])

# Cross-check against the .tex, if there is one
if (file.exists(tex)) {
  tl <- sub("(^|[^\\\\])%.*$", "\\1", readLines(tex, warn = FALSE))
  ti <- unlist(regmatches(tl, gregexpr(
    "\\\\includegraphics(\\[[^]]*\\])?\\{(images|figs)/[^}]+\\.(png|jpe?g)\\}", tl,
    ignore.case = TRUE)))
  ti <- unique(sub("^.*\\{([^}]+)\\}$", "\\1", ti))
  tex_only <- setdiff(ti, src)
  src_only <- setdiff(src, ti)
  if (length(tex_only) || length(src_only)) {
    cat(sprintf("\nCross-check with %s (may be stale; the sources win):\n", tex))
    if (length(tex_only)) cat("  in .tex, not in sources (NOT converted):\n    ",
                              paste(tex_only, collapse = "\n    "), "\n", sep = "")
    if (length(src_only)) cat("  in sources, not in .tex (converted):\n    ",
                              paste(src_only, collapse = "\n    "), "\n", sep = "")
  }
}

if (!is.na(only)) src <- grep(only, src, value = TRUE)
if (!length(src)) stop("No images found",
                       if (!is.na(only)) paste0(" matching --only=", only))

# ── Decide what to do with each image ──────────────────────────────────────

gray_tol <- 2 / 255   # max R/G/B difference still counted as gray

describe <- function(f) {
  fr <- paste0(f, "[0]")
  r <- run_magick(c("identify", "-format", "%[colorspace]|%[type]|%A|%z|%[profiles]", fr))
  if (failed_run(r) || !length(r)) stop("magick identify failed on ", f)
  p <- strsplit(r[length(r)], "|", fixed = TRUE)[[1]]
  if (length(p) < 4 || !nzchar(p[1])) stop("Could not parse identify output for ", f, ": ", r)
  # Largest per-pixel max(R,G,B) - min(R,G,B), after flattening onto white
  # (HCL chroma is exactly that range).
  ch <- run_magick(c(fr, "-background", "white", "-alpha", "remove", "-alpha", "off",
                     "-colorspace", "HCL", "-channel", "G", "-separate",
                     "-format", "%[fx:maxima]", "info:"))
  chroma <- suppressWarnings(as.numeric(ch[length(ch)]))
  if (failed_run(ch) || is.na(chroma)) stop("Could not measure colour of ", f)
  list(colorspace = p[1], type = p[2],
       alpha = !(p[3] %in% c("Undefined", "False", "")),
       depth = as.integer(p[4]),
       icc = length(p) >= 5 && grepl("\\bicc\\b", p[5]),
       chroma = chroma)
}

out_stem <- function(f) {
  rel <- if (startsWith(f, "images/")) sub("^images/", "", f) else f   # figs/... kept
  file.path(out_dir, tools::file_path_sans_ext(rel))
}

plan_one <- function(f) {
  d <- describe(f)
  is_jpg <- tolower(tools::file_ext(f)) %in% c("jpg", "jpeg")
  stem <- out_stem(f)
  # compare in 0-255 steps: magick prints 2/255 as 0.00784314 > 2/255
  gray <- d$colorspace == "Gray" || round(d$chroma * 255) <= round(gray_tol * 255)
  action <- if (d$colorspace == "CMYK") {
    if (d$icc || d$alpha) "strip" else "skip-cmyk"
  } else if (gray) {
    if (d$colorspace == "Gray" && !d$icc && !d$alpha && d$depth <= 8) "skip-gray" else "gray"
  } else {
    "cmyk"
  }
  out <- switch(action,
    "skip-cmyk" = , "skip-gray" = NA_character_,
    "strip" = paste0(stem, ".jpg"),
    "gray"  = paste0(stem, if (is_jpg) ".jpg" else ".png"),
    "cmyk"  = paste0(stem, if (is_jpg) ".jpg" else ".pdf"))
  data.frame(source = f, colorspace = d$colorspace, type = d$type,
             icc = d$icc, alpha = d$alpha, depth = d$depth,
             max_chroma = round(d$chroma * 255, 1),
             action = action, output = out, stringsAsFactors = FALSE)
}

message(sprintf("Checking %d images from %d source files ...", length(src), length(seen)))
plan <- do.call(rbind, lapply(src, plan_one))

# Two sources must never share an output stem (e.g. foo.png and foo.jpg),
# since the Lua filter finds the converted file by stem.
stems <- tools::file_path_sans_ext(na.omit(plan$output))
if (anyDuplicated(stems))
  stop("Output name clash: ", paste(unique(stems[duplicated(stems)]), collapse = ", "))

# ── Up-to-date check against the manifest ──────────────────────────────────

manifest_file <- file.path(out_dir, "manifest.csv")
old <- if (file.exists(manifest_file))
  read.csv(manifest_file, stringsAsFactors = FALSE) else NULL

plan$src_md5 <- unname(tools::md5sum(plan$source))
plan$needs <- !is.na(plan$output)
if (!force && !is.null(old)) {
  for (i in which(plan$needs)) {
    o <- old[old$source == plan$source[i], , drop = FALSE]
    plan$needs[i] <- !(nrow(o) == 1 &&
                       identical(o$output, plan$output[i]) &&
                       identical(o$src_md5, plan$src_md5[i]) &&
                       identical(o$profile_md5, cmyk_md5) &&
                       file.exists(plan$output[i]))
  }
}

# ── Convert ────────────────────────────────────────────────────────────────

flatten <- c("-background", "white", "-alpha", "remove", "-alpha", "off")
# For PNG: drop profiles and metadata chunks but keep pHYs (resolution),
# which -strip would also remove.
png_clean <- c("+profile", "*", "-define",
               "png:exclude-chunk=bKGD,cHRM,EXIF,gAMA,iCCP,iTXt,sRGB,tEXt,zCCP,zTXt,date,tIME")

convert_args <- function(row) {
  f <- paste0(row$source, "[0]")
  ext <- tools::file_ext(row$output)
  switch(row$action,
    "cmyk" = c(f, flatten, "-depth", "8", "-type", "TrueColor",
               "-profile", srgb_profile, "-profile", cmyk_profile, "-strip",
               if (ext == "pdf") c("-compress", "Zip")
               else c("-quality", "95", "-sampling-factor", "1x1"),
               row$output),
    "gray" = c(f, flatten, "-colorspace", "Gray", "-depth", "8", "-type", "Grayscale",
               if (ext == "png") png_clean else c("-strip", "-quality", "95"),
               row$output),
    "strip" = c(f, flatten, "-strip", "-quality", "95", "-sampling-factor", "1x1",
                row$output))
}

expect_cs <- c(cmyk = "CMYK", strip = "CMYK", gray = "Gray")

todo <- plan[plan$needs, , drop = FALSE]
cat(sprintf("\nProfiles:\n  CMYK: %s\n  sRGB: %s\nOutput: %s/\n\n",
            cmyk_profile, srgb_profile, out_dir))
print(table(action = plan$action))
cat(sprintf("\n%d to convert, %d up to date, %d skipped (already Gray/CMYK)%s\n\n",
            nrow(todo), sum(!is.na(plan$output) & !plan$needs),
            sum(is.na(plan$output)), if (dry_run) "  [dry run]" else ""))

failed <- character(0)
for (i in seq_len(nrow(todo))) {
  row <- todo[i, ]
  cat(sprintf("  %-5s %s -> %s\n", row$action, row$source, row$output))
  if (dry_run) next

  # If this image's output name changed (e.g. .pdf -> .png), remove the file
  # this script made for it before, so the filter can't pick up the old one.
  if (!is.null(old)) {
    prev <- old$output[old$source == row$source]
    prev <- prev[!is.na(prev) & prev != row$output & file.exists(prev) &
                 startsWith(prev, paste0(out_dir, "/"))]
    if (length(prev)) { cat("        removing old output", prev, "\n"); unlink(prev) }
  }

  dir.create(dirname(row$output), recursive = TRUE, showWarnings = FALSE)
  r <- run_magick(convert_args(row), keep_err = TRUE)
  ok <- !failed_run(r) && file.exists(row$output)
  if (ok) {
    chk <- run_magick(c("identify", "-format", "%[colorspace]", paste0(row$output, "[0]")))
    ok <- !failed_run(chk) && identical(chk[length(chk)], expect_cs[[row$action]])
    if (!ok) r <- c(r, paste("output colorspace is", chk[length(chk)]))
  }
  if (!ok) {
    failed <- c(failed, row$source)
    unlink(row$output)   # never leave a bad file where the filter would find it
    cat("        FAILED:", paste(r, collapse = "\n        "), "\n")
  }
}

# ── Manifest and orphans ───────────────────────────────────────────────────

if (!dry_run) {
  cols <- c("source", "colorspace", "type", "icc", "alpha", "depth", "max_chroma",
            "action", "output", "src_md5")
  done <- plan[!is.na(plan$output) & !(plan$source %in% failed), cols]
  done$profile_md5 <- rep(cmyk_md5, nrow(done))
  # keep manifest rows for images outside an --only run
  if (!is.null(old) && !is.na(only) && all(names(done) %in% names(old)))
    done <- rbind(old[!(old$source %in% plan$source), names(done)], done)
  done <- done[order(done$source), ]
  dir.create(out_dir, showWarnings = FALSE, recursive = TRUE)
  write.csv(done, manifest_file, row.names = FALSE)
  cat(sprintf("\nManifest: %s (%d images)\n", manifest_file, nrow(done)))

  have <- list.files(out_dir, recursive = TRUE, full.names = TRUE)
  have <- have[basename(have) != "manifest.csv"]
  orphans <- setdiff(normalizePath(have, winslash = "/"),
                     normalizePath(done$output, winslash = "/", mustWork = FALSE))
  if (length(orphans))
    cat("\nNot produced from any current image (check, then delete by hand):\n  ",
        paste(orphans, collapse = "\n  "), "\n", sep = "")
}

if (length(failed)) {
  cat("\nFAILED:", length(failed), "\n  ", paste(failed, collapse = "\n  "), "\n")
  quit(status = 1)
}
cat("\nDone.\n")
