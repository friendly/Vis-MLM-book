# GBE → GEB switch (Hofstadter cover image and title)

**Date:** 2026-07-10
**Status:** Done — all source files updated and verified; generated outputs pick up the changes on the next `Build -> All Formats`.

## Background

The book twice uses the cover photograph from Douglas Hofstadter's *Gödel, Escher, Bach: An Eternal Golden Braid* (the "trip-let" blocks casting G/E/B shadows) to illustrate projection. The book's title was misordered as "*Gödel, Bach and Escher*" throughout the text, and the image file, figure labels, and chunk labels all carried the matching acronym typo **GBE** instead of **GEB**. Separately, the image was flagged `LOW-DPI` in the CMYK audit (456×489 px, 139 effective dpi at 60% width; see `CMYK-checklist.md`).

Both problems were fixed together: a high-resolution replacement image was brought in under the corrected filename, and every textual occurrence of the typo was corrected.

## Changes

### 1. Image file replaced and renamed

- `images/Cover-GBE.png` (456×489 px) **deleted** (`git rm`; recoverable from history).
- `images/Cover-GEB.png` (2956×3282 px, sRGB) **added**. Effective print resolution: **899 dpi** at the Ch. 2 usage (`out-width: 60%`), ~1350 dpi at the Ch. 4 grand-tour usage (40%) — both far above CRC's 300 dpi minimum.
- Permission status is unchanged by the swap: still copyrighted cover art, rightsholder Basic Books / Hachette, tracked in `fig-permission-list.md` (used twice).

### 2. Filename references updated (`Cover-GBE.png` → `Cover-GEB.png`)

- `02-intro.qmd` (chunk `fig-cover-GEB`)
- `04-multivariate_plots.qmd` (chunk `fig-cover-GEB2`)
- `child/04-grand-tour.qmd` (child copy of the same chunk)
- `Vis-MLM.tex` (kept compilable for the manual TeXStudio workflow)
- `issues/fig-permission-list.md`, `issues/CMYK-checklist.md`, `issues/cmyk-image-audit-results.csv` (the CSV row still shows the *old* file's audit metrics — only the path was updated so links resolve)

### 3. Title corrected ("Gödel, Bach and Escher" → "Gödel, Escher, Bach")

Per MF's convention here, the subtitle (*An Eternal Golden Braid*) was **not** added where the text uses the short title. Fixed in:

- `02-intro.qmd`: prose (line ~187), commented-out figure block (~193), and `fig-cap` (~199)
- `04-multivariate_plots.qmd`: prose (~2755)
- `child/04-grand-tour.qmd`: prose (~50)
- `Vis-MLM.tex`: the four corresponding generated lines

`bib/references.bib` (`Hofstadter1979`) already had the correct title; no change needed.

### 4. Chunk labels renamed (`fig-cover-GBE`/`fig-cover-GBE2` → `fig-cover-GEB`/`fig-cover-GEB2`)

All definitions and cross-references updated in: `02-intro.qmd`, `04-multivariate_plots.qmd`, `child/04-grand-tour.qmd`, `child/04-3D-scat.qmd` (`@fig-cover-GEB` reference only), `Vis-MLM.tex` (`\label`/`\ref` pairs), and the mention in `issues/fig-permission-list.md`.

## Deliberately left untouched

- `docs/` — self-contained HTML output (has its own copy of the old image), regenerated wholesale on the next render.
- `pdf/index.tex`, `pdf/index.log` — archived snapshots of a past build; editing them would falsify the archive.
- `.quarto/` caches (`_freeze`, `idx`) — invalidate automatically because the source `.qmd` files changed.

## Verification performed

- Case-insensitive repo sweep: zero remaining occurrences of the title typo or of `Cover-GBE.png` / `fig-cover-GBE` in any source file.
- Label bookkeeping balanced: `fig-cover-GEB` defined once, referenced from `02-intro.qmd` and `child/04-3D-scat.qmd`; `fig-cover-GEB2` defined in chapter + child copy, referenced from each.
- `Vis-MLM.tex`: exactly one `\label` and one matching `\ref` per figure; both `\includegraphics` lines point at the existing `images/Cover-GEB.png`.
- No sed artifacts (`GEB22`, doubled extensions, etc.).
- `git status` contains exactly the expected file set.
