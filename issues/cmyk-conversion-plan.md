# Plan: RGB→CMYK conversion of static images for CRC Press submission

## Context

CRC Press (Shashi) replied to the questions drafted in `issues/email-CRC-cmyk.md`:

- ICC profile: **US Web Coated SWOP**
- Raster format: **PNG/JPG is fine** — no TIFF conversion needed
- Minimum resolution: **300 dpi** (current images range 96–300 dpi)

`issues/CMYK-colors.md` already tracks this work and shows R-generated
figures and LaTeX vector colors are done (`pdf.options(colormodel="cmyk")`,
`\usepackage[cmyk]{xcolor}`). The only remaining gap is the ~90 static
raster images in `images/` that are actually embedded in the PDF (referenced
via `knitr::include_graphics("images/...")` across 22 `.qmd` files) — this
was blocked pending CRC's answer and is now unblocked.

Tools confirmed available on this machine:
- **ImageMagick** 7.1.2 (`magick`), already on PATH.
- **Ghostscript** 10.07.1, just installed at `C:\Program Files\gs\gs10.07.1\bin\gswin64c.exe`
  (not yet on PATH). Used here for verification, not conversion.
- The exact profile CRC asked for exists locally:
  `C:\Program Files\Common Files\Adobe\Color\Profiles\Recommended\USWebCoatedSWOP.icc`
- An sRGB source profile for the two-step assign→convert:
  `C:\Windows\System32\spool\drivers\color\sRGB Color Space Profile.icm`

Images are converted **individually** into a parallel `images-cmyk/`
directory — not via a whole-PDF Ghostscript recolor pass. This preserves
per-image control (each image can be reviewed/tweaked) and avoids
recoloring vector content that's already correct (R figures, TikZ/xcolor
elements are already CMYK at the source).

## Getting CMYK images into the PDF without touching the build pipeline

Quarto renders HTML and PDF as separate invocations from the same `.qmd`
source, so there's no need to swap files in `images/` mid-build or add a
build.sh flag. Instead, resolve the path once per include:

Add a small helper to `R/common.R`:

```r
img_path <- function(file) {
  cmyk_file <- file.path("images-cmyk", file)
  if (knitr::is_latex_output() && file.exists(cmyk_file)) cmyk_file
  else file.path("images", file)
}
```

Then mechanically rewrite each call site from:

```r
knitr::include_graphics("images/foo.png")
```

to:

```r
knitr::include_graphics(img_path("foo.png"))
```

across the ~110 call sites in the 22 `.qmd`/child files that use
`knitr::include_graphics("images/...")` (a scripted regex replace — the
pattern is consistent). HTML renders always get `images/` (RGB, unaffected).
PDF renders get `images-cmyk/` automatically for any file that has been
converted, and fall back to the RGB original for anything not yet
converted (e.g. exempt types, or images not yet reached in the conversion
pass) — so this is safe to land incrementally.

A few raw `\includegraphics{images/...}` calls exist in `latex/preamble.tex`
(title-page images) — these are PDF-only already, so just point them
directly at the `images-cmyk/` counterpart once that file is converted; no
conditional needed.

## Steps

### 1. Update tracking docs
- `issues/email-CRC-cmyk.md`: append CRC's reply, mark as answered.
- `issues/CMYK-colors.md`: update the "Static images" section — replace the
  TIFF recommendation with the confirmed PNG/JPG + SWOP profile approach;
  record the local ICC profile paths; replace the "Ghostscript whole-PDF"
  conversion option with a "Ghostscript for verification only" note.

### 2. Quick correctness fix (already scoped, independent of images)
In `latex/preamble.tex`, per "Issues still to fix" in `CMYK-colors.md`:
- Remove `\usepackage{color}` (legacy, superseded by xcolor) and redefine
  `shadecolor` directly in `cmyk`.
- Convert the remaining RGB `\definecolor{darkgreen}...` /
  `\definecolor{mygreen}...` calls to their `cmyk` equivalents (values
  already computed in the doc).

### 3. Audit script — `issues/cmyk-image-audit.R`
Read-only report, run before any conversion:
- Grep all `.qmd` files for `knitr::include_graphics("images/...")` /
  `\includegraphics{images/...}`, excluding matches inside
  `:::{.content-visible when-format="html"}` blocks (HTML-only, exempt) and
  excluding `.gif`/`.webp`/`.svg`/`.pptx` (already exempt per
  `CMYK-colors.md`).
- For each unique file used in the PDF: get pixel dimensions + current
  colorspace via `magick identify -format "%w %h %[colorspace]"`.
- Parse the `#| out-width: "NN%"` chunk option where present (falls back to
  a full-textwidth default) and multiply against the krantz class's actual
  `\textwidth` (extract via a one-line LaTeX probe, since it isn't logged
  directly) to estimate the image's **effective print DPI** — pixels ÷
  physical inches, not the (often meaningless) embedded metadata DPI tag.
- Output a table: file, colorspace, pixel size, est. print width, effective
  dpi, flag `LOW-DPI` if under 300.

### 4. Review low-DPI images with Michael
Present the flagged list. Upsampling doesn't create real detail, so each
flagged image needs a manual call: re-source a higher-res original, redraw
(for simple diagrams), shrink its print size in the `.qmd`, or accept and
note it to CRC. This step is judgment-based — prepare the list, don't
auto-resolve it.

### 5. Conversion script — `convert-images-cmyk.sh`
For every image the audit lists as used + not already CMYK:
```bash
magick "$src" -profile "C:/Windows/System32/spool/drivers/color/sRGB Color Space Profile.icm" \
              -profile "C:/Program Files/Common Files/Adobe/Color/Profiles/Recommended/USWebCoatedSWOP.icc" \
              -colorspace CMYK "$dst"
```
Output mirrors `images/`'s subfolder structure into `images-cmyk/` (same
filenames, same PNG/JPG format — no TIFF). Add `images-cmyk/` to
`.gitignore` as a regenerable derived asset (rerun the script if a source
image changes).

### 6. Wire up the `.qmd` sources
- Add `img_path()` to `R/common.R`.
- Scripted find/replace of `knitr::include_graphics("images/X")` →
  `knitr::include_graphics(img_path("X"))` across all 22 files.
- Point the handful of raw `\includegraphics{images/...}` calls in
  `latex/preamble.tex` at their `images-cmyk/` counterparts directly.

### 7. Verify
- Spot-check converted files: `magick identify -format "%f: %[colorspace]\n" images-cmyk/*.png`.
- Full-PDF check with the newly-installed Ghostscript (ink coverage per
  page — mixed non-zero C/M/Y/K is correct; all-RGB objects would show up
  as an anomalous pattern):
  ```bash
  "/c/Program Files/gs/gs10.07.1/bin/gswin64c.exe" -dBATCH -dNOPAUSE -sDEVICE=inkcov pdf/Vis-MLM.pdf
  ```
- Acrobat Pro Output Preview → Separations, as a visual cross-check.

### 8. Final submission build
Ordinary `./build.sh --pdf --fix-index --authorindex` now produces a PDF
with CMYK images automatically (via `img_path()`), no separate flag or
submission-only build path needed.

## Files touched
- `issues/email-CRC-cmyk.md`, `issues/CMYK-colors.md` — updated tracking docs
- `latex/preamble.tex` — remove legacy `color` package, fix remaining RGB
  `\definecolor`s, point title-page images at `images-cmyk/`
- `R/common.R` — add `img_path()` helper
- `issues/cmyk-image-audit.R` — new, read-only audit/report
- `convert-images-cmyk.sh` — new, RGB→CMYK conversion via ImageMagick + SWOP profile
- `.gitignore` — add `images-cmyk/`
- ~22 `.qmd`/child files — mechanical `include_graphics()` call-site rewrite
