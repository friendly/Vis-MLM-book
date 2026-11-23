# Embed all fonts in the R-generated figure PDFs under figs/
#
# Why: the printer's preflight (copy-editing note, 2026-11-19) flagged
# "162 pages containing non-embedded font". R's pdf() device never embeds the
# base-14 fonts (Helvetica, Helvetica-Bold, Symbol), so every figs/**/*.pdf made
# by knitr's default `dev = "pdf"` carries them un-embedded into the book PDF.
#
# This one-off pass rewrites each affected figure with Ghostscript
# (grDevices::embedFonts()), which substitutes the metrically identical URW fonts
# (Nimbus Sans, Standard Symbols PS) and embeds them. Figures re-rendered later
# are handled by the `fig.process` hook in R/common.R.
#
# Usage: source("issues/embed-fig-fonts.R") from the project root.
# Re-running is safe: files with all fonts embedded are skipped.

gs <- c(Sys.which("gswin64c"),
        rev(sort(Sys.glob("C:/Program Files/gs/gs*/bin/gswin64c.exe"))))
gs <- gs[nzchar(gs)][1]
if (is.na(gs)) stop("Ghostscript (gswin64c) not found")
Sys.setenv(R_GSCMD = gs)
pdffonts <- Sys.which("pdffonts")
if (!nzchar(pdffonts))
  pdffonts <- "C:/Users/friendly/AppData/Local/Programs/MiKTeX/miktex/bin/x64/pdffonts.exe"

# TRUE if pdffonts reports any font with emb = "no"
has_unembedded <- function(f) {
  out <- suppressWarnings(system2(pdffonts, shQuote(f), stdout = TRUE, stderr = FALSE))
  if (length(out) <= 2) return(FALSE)
  rows <- out[-(1:2)]
  # columns (from the right): emb sub uni object ID  ->  emb is 5th from last
  emb <- vapply(strsplit(trimws(rows), "\\s+"),
                function(r) r[length(r) - 4], character(1))
  any(emb == "no")
}

files <- list.files("figs", pattern = "\\.pdf$", recursive = TRUE, full.names = TRUE)
todo  <- files[vapply(files, has_unembedded, logical(1))]
cat(length(todo), "of", length(files), "figure PDFs have non-embedded fonts\n")

failed <- character(0)
for (f in todo) {
  tmp <- tempfile(fileext = ".pdf")
  ok <- tryCatch({
    embedFonts(f, outfile = tmp,
               options = "-dPDFSETTINGS=/prepress -dEmbedAllFonts=true -dSubsetFonts=true")
    file.exists(tmp) && file.size(tmp) > 0 && !has_unembedded(tmp)
  }, error = function(e) FALSE)
  if (ok) file.copy(tmp, f, overwrite = TRUE) else failed <- c(failed, f)
  unlink(tmp)
}

cat("Fixed:", length(todo) - length(failed), "  Failed:", length(failed), "\n")
if (length(failed)) print(failed)
