# Copy editing note, 11/19/2026

Thank you for sending the updated AI statement, that’s perfect! In addition to this, the information on the AI use in the figure would need to be include in the caption for the figure itself, but that can be done at proof stage. 

I just heard back from the production team, who have highlighted a couple of things in the manuscript. I have asked if these can be addressed at proof stage to avoid further delays, but please let me know if you have any concerns about that. Their list is as follows:

•	There are undefined glyphs on pp. 224, 238, 240, and 360.
•	There are 162 pages containing non-embedded font.
•	Various figures use RGB color will need to be converted to CMYK.
•	Prelims will need to be inserted into front matter
•	The x-axis of the bottom graph in figure 7.17 contains overlapping text


---

# Notes: where the problems arise, and fixes (2026-11-23)

Checked against `pdf/Vis-MLM.pdf` (Oct. 26 build) and its log `pdf/index.log`. The page numbers in the note don't exactly match that build's page numbers (the production team may have a slightly different PDF), but the log shows exactly four pages with missing glyphs, matching their four pages in order.

**To do after these fixes:** rebuild the PDF (`Build -> All Formats`, or recompile `Vis-MLM.tex` in TeXStudio), then check that `index.log` has no `Missing character` lines and that `pdffonts index.pdf` shows `emb = yes` for every font.

## 1. Undefined glyphs (pp. 224, 238, 240, 360)

- [x] **pp. 224, 238, 240: bold β.** The source wrote $\vec{\beta}$, and our `latex/latex-commands` defines `\vec{x}` as `\mathbf{x}`. `\mathbf` selects the bold *upright text* font (Latin Modern Roman Bold), which has no Greek lowercase, so the β came out blank (log: `Missing character: There is no 𝛽 (U+1D6FD) in font [lmroman10-bold]`). Other `\mathbf{}` uses on Greek capitals (e.g. `\mathbf{\Sigma}`) are fine, because those glyphs do exist in the font. Changed to `\boldsymbol{\beta}` (as used elsewhere in the book):

    - `07-linear_models-plots.qmd:1430`: "precision of our estimates of β" (Ch. 7, section on leverage)

    - `08-lin-mod-topics.qmd:141`: "In the dual β space, ..." (Ch. 8)

    - `08-lin-mod-topics.qmd:319`: the equation $\widehat{\beta} \oplus \sqrt{d F} \ldots$ (Ch. 8)

    These were the only `\vec{}` uses on Greek letters in the book.

- [x] **p. 360: check mark ✓ in R output.** In Ch. 11 (`11-mlm-review.qmd`, chunk `school-mvn`), the printed output of `MVN::mvn()` marks each test with "✓ Normal". The code font (Latin Modern Mono) has no ✓ (log: `There is no ✓ (U+2713) in font [lmmono10-regular]`), so 4 marks were blank. Fix in `R/common.R`: the knitr output hook now replaces ✓/✔ with `+` and ✗/✘ with `x` in PDF output only (one character each, so the columns stay aligned). The HTML version is unchanged.

- [x] Also patched `Vis-MLM.tex` directly (the same 3 β's and 4 ✓'s), so a TeXStudio-only recompile picks up these fixes without re-rendering.

## 2. Non-embedded fonts (162 pages)

- [x] **Cause:** R's `pdf()` graphics device (the default knitr `dev` for PDF output) never embeds the PostScript base fonts Helvetica, Helvetica-Bold and Symbol. `pdffonts` found 223 of the 261 figure PDFs in `figs/` (all chapters) with un-embedded fonts, and these carry through to the pages they appear on in the book. Static images in `images/` and the LaTeX text fonts are all embedded.

- [x] **Existing figures:** `issues/embed-fig-fonts.R` rewrites each affected `figs/**/*.pdf` with Ghostscript (`grDevices::embedFonts()`). This substitutes the metrically identical URW fonts (Nimbus Sans for Helvetica, Standard Symbols for Symbol) and embeds subsets of them, so the figures look the same. Safe to re-run: it skips files that are already OK.

- [x] **Future renders:** `R/common.R` now sets a knitr `fig.process` hook (PDF output only) that does the same for each figure as it's written. It warns if Ghostscript (`C:/Program Files/gs/gs9.56.0`) isn't found.

- [ ] Verify on the rebuilt PDF: `pdffonts index.pdf` should list no fonts with `emb = no`.

## 3. RGB → CMYK

- [ ] **Gavin is handling this.** (Most figures are drawn in R with RGB colours, and the PNG images are RGB. Ghostscript can convert a whole PDF to CMYK (`-sColorConversionStrategy=CMYK`), but colours shift, so check the result against the printer's profile.)

- [x] **Image resolution (Gavin's `dpi-fixes`, merged 2026-11-23).** Independent check (`issues/image-quality/verify-dpi-fixes.R`): 64 of the 69 low-resolution images are fixed, now ≥ 317 dpi as printed or vector. Four still need a better source (`datasaurus-dozen.jpg`, `iris-diagram.jpg`, `tesseract-frames.png`, `heatmap.png`). The author photo `MF-gray.jpg` (About the Author, ~108 dpi) has no better source: accept as is and tell CRC.

- [ ] The RGB → CMYK conversion step itself (ImageMagick → `images-cmyk/`) hasn't been run yet.

## 4. Prelims in front matter

- [ ] **Nothing for us to fix: CRC supplies the prelims.** `latex/before-body.tex` has only a placeholder copyright page ("Rest of the stuff, ISBN, ... goes here"). The production team inserts the series page, title page and copyright page with ISBN. Ask Lara whether they want us to remove our placeholder or leave blank pages for them to replace.

## 5. Figure 7.17: overlapping x-axis labels

- [x] **Cause:** `fig-prestige-allEffects` (`07-linear_models-plots.qmd`, ~line 1195) is `plot(allEffects(prestige.mod3))`. The `income*type` term got three separate panels squeezed into one quarter of the figure, so the income tick labels (5000, 10000, ..., 25000) ran together. The y-axis labels were also crowded.

- [x] **Fix:** plot the interaction with `lines = list(multiline = TRUE)`, so the three types of occupation are separate curves in one panel (with confidence bands and a legend), and set the income ticks to 5000, 15000, 25000. The other two panels are unchanged. Tried keeping separate panels with fewer/rotated ticks, but they stayed too small to read.

- [x] Text: the paragraph after the figure (~line 1266) said the following figure used one plot "rather than in separate panels as in @fig-prestige-allEffects". Reworded to "... in a single plot (using `multiline = TRUE`), as in the bottom panel of @fig-prestige-allEffects, rather than in separate panels for each type."

- [ ] Re-render Ch. 7 to regenerate `figs/ch07/fig-prestige-allEffects-1.pdf`.


---

# Draft reply to Lara

Dear Lara,

Thanks for passing on the production team's list. We've been able to fix most of it on our side now, so it shouldn't need to wait for proofs:

- **Undefined glyphs (pp. 224, 238, 240, 360):** fixed. On the first three, a bold Greek β was set in a font that has no Greek; on p. 360, a check mark (✓) in printed R output wasn't in the code font.

- **Non-embedded fonts:** fixed. The base fonts (Helvetica, Symbol) in the figures produced by R weren't embedded; all figure fonts are now embedded.

- **Figure 7.17:** fixed. The bottom graph now shows the three curves in a single panel, so the x-axis labels no longer overlap.

- **RGB to CMYK:** Gavin Klorfine is working on converting the figures. He has also replaced or regenerated nearly all of the low-resolution images. The one exception I can't fix is my author photo on the About the Author page: I have no higher-resolution version. Is it acceptable as is, or would you prefer a new photo?

- **Prelims:** we assume your team will insert the series, title and copyright pages. Our PDF currently has a placeholder copyright page. Should we remove it, or leave blank pages for you to replace?

I'll send a revised PDF once it has been rebuilt and checked.

Best wishes,
Michael
