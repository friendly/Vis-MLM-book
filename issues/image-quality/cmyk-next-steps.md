# RGB → CMYK: where things stand and next steps (2026-11-23)

Follows `cmyk-conversion-plan.md` (July). Written after CRC's preflight (production note of 2026-11-19, see `production/copy-editing-note-11-19-2026.md`) flagged "various figures use RGB color".

## Where things stand

Checked on the 2026-10-26 PDF (`pdf/Vis-MLM.pdf`):

- **Vector content is already all CMYK.** Decompressed, the PDF has 0 RGB color operators (`rg`/`RG`) and ~10,900 CMYK ones (`k`/`K`). R figures (`pdf.options(colormodel = "cmyk")`) and LaTeX colors (`\usepackage[cmyk]{xcolor}`) are fine. The font-embedding pass of 2026-11-23 (`issues/embed-fig-fonts.R`) keeps the figures CMYK (checked with Ghostscript `inkcov`).

- **The RGB problem is the raster images from `images/`, and only those.** `pdfimages -list` finds 80 non-CMYK images: 68 RGB, 11 indexed (palette PNGs) and 1 ICC-based, plus 3 grayscale, which are fine for print. That matches the 85 `images/...` paths in `Vis-MLM.tex` (a few appear twice, and 2 are the title-page images in `latex/preamble.tex`).

- **Plan steps done:** 1 (tracking docs), 2 (LaTeX colors), 3 (audit), 4 (low-DPI review: 64 of 69 fixed and independently verified, see `CMYK-checklist.md`).

- **Plan steps not started:** 5 (conversion script, `images-cmyk/`), 6 (wiring the build to use the converted files), 7 (verification).

## Remaining low-DPI images: special cases

`datasaurus-dozen.jpg` (124 dpi), `iris-diagram.jpg` (153), `tesseract-frames.png` (233), `heatmap.png` (280), and the author photo `MF-gray.jpg` (108, accepted: no better source). These are noted as special cases. They may be dealt with later if there's time, but there's no guarantee; CRC will be told about any that remain. They don't block the CMYK conversion: convert them as they are.

## Suggested changes to the July plan

1. **Use a Quarto Lua filter instead of rewriting 198 `include_graphics()` calls (step 6).** Every image reaches LaTeX as a pandoc `Image` with a relative `images/...` path, including the `here::here()` and markdown `![]()` cases. A PDF-only filter can swap the path when a converted file exists, with no `.qmd` edits:

    ```lua
    -- filters/cmyk-images.lua  (add under format: pdf: filters:)
    function Image(el)
      if quarto.doc.is_format("pdf") and el.src:match("^images/") then
        local cmyk = el.src:gsub("^images/", "images-cmyk/")
        local f = io.open(cmyk, "r")
        if f then f:close(); el.src = cmyk end
      end
      return el
    end
    ```

    HTML is untouched, and anything not converted falls back to the RGB file, so it can land in stages. Check that it sees images inserted by `knitr::include_graphics()` (it should: knitr emits markdown images), and test on one chapter first. The two title-page images in `latex/preamble.tex` get pointed at `images-cmyk/` by hand.

2. **Commit `images-cmyk/` instead of git-ignoring it.** The build runs on more than one machine, and the conversion needs ImageMagick plus the Adobe SWOP profile at a machine-specific path. Committing the output means any machine can build the print PDF. Size cost is modest (about 80 files).

3. **Write the conversion script in R** (`issues/image-quality/convert-images-cmyk.R`, using `system2("magick", ...)`), not `.sh`, to match the other scripts. It should:

    - take its file list from the `.tex` (all `images/...` paths in `\includegraphics`) or from the audit CSV;
    - skip files already CMYK or grayscale;
    - convert only when the source is newer than the output, so it's safe to re-run;
    - flatten indexed PNGs to truecolor first.

4. **Add a visual check for color shifts.** SWOP's gamut is smaller than sRGB: saturated blues, greens and purples (common in screenshots and R color palettes) can shift visibly. Make a side-by-side contact sheet (`magick montage`, RGB left, CMYK right, soft-proofed back to sRGB for screen) for MF to review before committing.

5. **Acceptance test:** on a fresh PDF build, `pdfimages -list index.pdf` shows **no `rgb`, `index` or `icc` rows** (except the cover, which CRC handles separately). Also, `index.log` has no `Missing character` lines and `pdffonts index.pdf` has no `emb no` rows (from the 2026-11-23 fixes).

**Fallback, if time runs out:** Ghostscript can convert the whole finished PDF to CMYK in one pass (`-sColorConversionStrategy=CMYK -sOutputICCProfile=USWebCoatedSWOP.icc`). It's quick, but it rewrites the entire 536-page PDF and can damage links, bookmarks or transparency, and it gives no per-image control. Keep it as plan B.

## Suggested split of the work

**Gavin:**

- [ ] Conversion script and `images-cmyk/` (suggestion 3), committed (suggestion 2).
- [ ] Lua filter and `_quarto.yml` wiring, tested on one chapter, then the whole book (suggestion 1).
- [ ] Title-page images in `latex/preamble.tex`.
- [ ] Contact sheet of before/after images for MF (suggestion 4).
- [ ] Full PDF build and the acceptance test (suggestion 5); report the `pdfimages -list` summary.
- [ ] *Optional, time-boxed:* the low-DPI special cases. `datasaurus-dozen` can probably be redrawn in R from the **datasauRus** package; `tesseract-frames` might be regenerated from R.

**MF:**

- [ ] Review the contact sheet; decide on any image whose colors shift too much.
- [ ] Final build for submission; send Lara the revised PDF and the reply (`production/reply-Lara-preflight.docx`).
