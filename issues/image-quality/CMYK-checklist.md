# CMYK conversion — LOW-DPI image checklist

Manual review checklist for the **69 images flagged `LOW-DPI`** in [cmyk-image-audit-results.csv](cmyk-image-audit-results.csv) (effective print resolution below CRC's 300 dpi minimum at the size the image is printed).
Updated 2026-11-20: 8 rows removed (no longer printed) and 8 added (printed but missed by the audit); see *Progress*.
Generated 2026-07-10 from the audit results; background in [Gavin-SummerWork.md](Gavin-SummerWork.md) (*RGB -> CMYK*), [CMYK-colors.md](CMYK-colors.md), and [cmyk-conversion-plan.md](cmyk-conversion-plan.md).

## How to use this checklist

For each image, in order of preference:

1. **REPLACE** — find or re-export a higher-resolution original (original photo, vector/PDF version, larger export from the tool that made it, better download of a historical figure). Overwrite the file in `images/` (same filename), or note the new filename and which `.qmd` needs updating.
2. **SHRINK** — if no better source exists but the image still reads at a smaller size, reduce `out-width` in the source `.qmd`. The **Max `out-width` @300** column is the largest print size the current pixels support at 300 dpi — if the current and max values are close, this is an easy fix; if max is tiny, shrinking isn't realistic.
3. **ACCEPT** — no better source and can't shrink: mark it to be flagged to CRC as accepted-as-is.

Mark the **Done** column with `X` (or ✓) once resolved, put `REPLACE` / `SHRINK` / `ACCEPT` in **Action**, and use **Notes** for details (new source URL, new filename, chosen `out-width`, etc.).
The RGB→CMYK colorspace conversion itself is a separate scripted step (ImageMagick + SWOP profile → `images-cmyk/`) that runs after this checklist is worked through — don't convert by hand.

**Column reference:** *Pixels* = current image width×height. *Eff. DPI* = pixel width ÷ printed width. *Printed at* = `out-width` in the `.qmd` and resulting physical width. *Px needed @300* = pixel width required to print at the current size at 300 dpi. *Max `out-width` @300* = largest `out-width` the current pixels support at 300 dpi.

## Front matter (`index.qmd`) — 2 images

| Done | Image | Pixels | Eff. DPI | Printed at | Px needed @300 | Max `out-width` @300 | Action | Notes |
|------|-------|--------|----------|------------|----------------|----------------------|--------|-------|
| [X] | [`icons/books.jpg`](../../images/icons/books.jpg) | 1187×369 | 217 | 100% (5.5″) | 1644 px | 72% | REPLACE | Used source `.pptx`, converted -> `.pdf`, used `magick` to create high-res `.png`, cropped `.png` and saved as `.jpg` |
| [X] | [`fig-book-parts.png`](../../images/fig-book-parts.png) | 1307×145 | 251 | 95% (5.2″) | 1562 px | 79% | REPLACE | 2026-07-10: was a frozen raster of a smartdiagram; source recreated as `latex/diagrams/fig-book-parts.tex` (build instructions inside). Print now uses a **vector CMYK PDF** (`images/fig-book-parts.pdf` — no DPI limit, no RGB→CMYK raster conversion needed); PNG re-rendered at 600 dpi for HTML (2729×323 px, eff. 524 dpi). `index.qmd` picks PDF for LaTeX, PNG for HTML. |

## About the Author (`00-Author.qmd`) — 1 image

| Done | Image | Pixels | Eff. DPI | Printed at | Px needed @300 | Max `out-width` @300 | Action | Notes |
|------|-------|--------|----------|------------|----------------|----------------------|--------|-------|
| [ ] | [`MF-gray.jpg`](../../images/MF-gray.jpg) | 172×225 | 105 | 30% (1.6″) | 494 px | 10% |  |  |

## Ch. 1: Prelude (`01-Prelude.qmd`) — 9 images

| Done | Image | Pixels | Eff. DPI | Printed at | Px needed @300 | Max `out-width` @300 | Action | Notes |
|------|-------|--------|----------|------------|----------------|----------------------|--------|-------|
| [X] | [`1D-4D.png`](../../images/1D-4D.png) | 482×305 | 98 | 90% (4.9″) | 1480 px | 29% | REPLACE | 2026-07-10: was an unattributed web graphic (circulating online since ≥2015; no hi-res original found). Redrawn as an exact author TikZ replica, source `latex/diagrams/fig-1D-4D.tex` (geometry traced programmatically from the raster). Print uses **vector CMYK PDF** (`images/1D-4D.pdf`); PNG re-rendered at 600 dpi for HTML (2846×1801 px, eff. 577 dpi). `01-Prelude.qmd` picks PDF for LaTeX, PNG for HTML. Also resolves the permission question in `fig-permission-list.md`. |
| [X] | [`flatland-spheres.jpg`](../../images/flatland-spheres.jpg) | 660×208 | 134 | 90% (4.9″) | 1480 px | 40% | REPLACE | `.pdf` retrieved from https://archive.org/details/flatlandromanceo00abbouoft/page/70/mode/2up , then used `magick` to create high-res `.png`, cropped `.png` and saved as `.jpg` |
| [X] | [`history/discoveries.jpg`](../../images/history/discoveries.jpg) | 1007×367 | 184 | 100% (5.5″) | 1644 px | 61% | REPLACE | Used source `.pptx`, converted -> `.pdf`, used `magick` to create high-res `.png`, cropped `.png` and saved as `.jpg` |
| [ ] | [`pollen-eureka1.png`](../../images/pollen-eureka1.png) | 535×531 | 195 | 50% (2.7″) | 822 px | 32% |  | Added 2026-11-20: missed by the July audit (included via markdown `![](images/...)`). One panel of a 2×2 layout, so it prints in a half-width column; the `{width=40%}` in the `.qmd` doesn't apply in the PDF. |
| [ ] | [`pollen-eureka2.png`](../../images/pollen-eureka2.png) | 535×531 | 195 | 50% (2.7″) | 822 px | 32% |  | Added 2026-11-20; same as `pollen-eureka1.png`. |
| [ ] | [`pollen-eureka3.png`](../../images/pollen-eureka3.png) | 535×531 | 195 | 50% (2.7″) | 822 px | 32% |  | Added 2026-11-20; same as `pollen-eureka1.png`. |
| [ ] | [`pollen-eureka4.png`](../../images/pollen-eureka4.png) | 535×531 | 195 | 50% (2.7″) | 822 px | 32% |  | Added 2026-11-20; same as `pollen-eureka1.png`. |
| [X] | [`ReavenMiller-3d-annotated.png`](../../images/ReavenMiller-3d-annotated.png) | 833×667 | 217 | 70% (3.8″) | 1151 px | 50% | REPLACE | Took non-annotated version from source journal article `.pdf`, added annotations in same exact style as the original `ReavenMiller-3d-annotated.png` file (via Pixelmator Pro). |
| [ ] | [`tesseract-frames.png`](../../images/tesseract-frames.png) | 1280×256 | 234 | 100% (5.5″) | 1644 px | 77% |  |  |

## Ch. 2: Introduction (`02-intro.qmd`) — 2 images

| Done | Image | Pixels | Eff. DPI | Printed at | Px needed @300 | Max `out-width` @300 | Action | Notes |
|------|-------|--------|----------|------------|----------------|----------------------|--------|-------|
| [X] | [`Cover-GEB.png`](../../images/Cover-GEB.png) | 456×489 | 139 | 60% (3.3″) | 987 px | 27% | REPLACE | Book is actually **GEB** (*Gödel, Escher, Bach An Eternal Golden Braid*)! I went ahead fixed all occurrences of the wrong title within the `.qmd` files. This file was also renamed to `Cover-GEB.png`. See [`issues/solved/GBE-to-GEB-switch.md`](../solved/GBE-to-GEB-switch.md). Source retrieved from the Internet Archive https://archive.org/details/godel-escher-bach-an-eternal-golden-braid-1999 as a `.pdf`; used `magick` to create high-res `.png`; cropped `.png` |
| [ ] | [`heatmap.png`](../../images/heatmap.png) | 1065×902 | 278 | 70% (3.8″) | 1151 px | 64% |  |  |

## Ch. 3: Getting Started (`03-getting_started.qmd`) — 3 images

| Done | Image | Pixels | Eff. DPI | Printed at | Px needed @300 | Max `out-width` @300 | Action | Notes |
|------|-------|--------|----------|------------|----------------|----------------------|--------|-------|
| [ ] | [`datasaurus-dozen.jpg`](../../images/datasaurus-dozen.jpg) | 680×425 | 124 | 100% (5.5″) | 1644 px | 41% |  |  |
| [X] | [`anscombe1.png`](../../images/anscombe1.png) | 650×480 | 132 | 90% (4.9″) | 1480 px | 39% | REGENERATE | Regenerated at 3611×2666 (400 dpi, eff. ~737 dpi at 4.9″) via `ggsave()` from the faceted plot in `R/anscombe.R` (the `fig-anscombe1` chunk in `03-getting_started.qmd` shows the same code minus the gridline-removing `theme()` line); canvas 650/72 × 480/72 in matches the original export's proportions |
| [X] | [`1969_draft_lottery_photo.jpg`](../../images/1969_draft_lottery_photo.jpg) | 1024×690 | 234 | 80% (4.4″) | 1316 px | 62% | REPLACE | Higher-res version retrieved from https://commons.wikimedia.org/wiki/File:1969_draft_lottery_photo.jpg |

## Ch. 4: Multivariate Plots (`04-multivariate_plots.qmd`) — 18 images

| Done | Image | Pixels | Eff. DPI | Printed at | Px needed @300 | Max `out-width` @300 | Action | Notes |
|------|-------|--------|----------|------------|----------------|----------------------|--------|-------|
| [ ] | [`tours/peng-tour-anomalies-final.png`](../../images/tours/peng-tour-anomalies-final.png) | 460×460 | 84 | 100% (5.5″) | 1644 px | 27% |  |  |
| [ ] | [`tours/peng-tour-lda-final.png`](../../images/tours/peng-tour-lda-final.png) | 460×460 | 84 | 100% (5.5″) | 1644 px | 27% |  |  |
| [ ] | [`tours/peng-tour-grand-lbls-split/frame_00.png`](../../images/tours/peng-tour-grand-lbls-split/frame_00.png) | 480×480 | 88 | 100% (5.5″) | 1644 px | 29% |  |  |
| [ ] | [`tours/peng-tour-grand-lbls-split/frame_10.png`](../../images/tours/peng-tour-grand-lbls-split/frame_10.png) | 480×480 | 88 | 100% (5.5″) | 1644 px | 29% |  |  |
| [ ] | [`tours/peng-tour-grand-lbls-split/frame_26.png`](../../images/tours/peng-tour-grand-lbls-split/frame_26.png) | 480×480 | 88 | 100% (5.5″) | 1644 px | 29% |  |  |
| [ ] | [`mahalanobis.png`](../../images/mahalanobis.png) | 332×334 | 121 | 50% (2.7″) | 822 px | 20% |  |  |
| [ ] | [`corrgram-renderings.png`](../../images/corrgram-renderings.png) | 656×245 | 150 | 80% (4.4″) | 1316 px | 39% |  |  |
| [ ] | [`projection.png`](../../images/projection.png) | 336×247 | 153 | 40% (2.2″) | 658 px | 20% |  |  |
| [X] | [`tours/peng-tour-demo-all.png`](../../images/tours/peng-tour-demo-all.png) | 992×356 | 181 | 100% (5.5″) | 1644 px | 60% | REPLACE | Used source `.pptx`, converted -> `.pdf`, used `magick` to create high-res `.png`; cropped `.png` |
| [ ] | [`crime-pvPlot-1-2.png`](../../images/crime-pvPlot-1-2.png) | 1000×500 | 182 | 100% (5.5″) | 1644 px | 60% |  |  |
| [ ] | [`big5-qgraph-rodrigues.png`](../../images/big5-qgraph-rodrigues.png) | 910×627 | 184 | 90% (4.9″) | 1480 px | 55% |  |  |
| [ ] | [`galton-corr.jpg`](../../images/galton-corr.jpg) | 745×631 | 194 | 70% (3.8″) | 1151 px | 45% |  |  |
| [ ] | [`proj-P2-vec.png`](../../images/proj-P2-vec.png) | 532×468 | 194 | 50% (2.7″) | 822 px | 32% |  |  |
| [ ] | [`peng-colors.png`](../../images/peng-colors.png) | 577×480 | 211 | 50% (2.7″) | 822 px | 35% |  |  |
| [ ] | [`proj-combined.png`](../../images/proj-combined.png) | 1193×464 | 218 | 100% (5.5″) | 1644 px | 72% |  |  |
| [ ] | [`peng-tourr-diagram.png`](../../images/peng-tourr-diagram.png) | 997×505 | 227 | 80% (4.4″) | 1316 px | 60% |  |  |
| [ ] | [`proj-vectors-labels.png`](../../images/proj-vectors-labels.png) | 1264×436 | 231 | 100% (5.5″) | 1644 px | 76% |  |  |
| [ ] | [`galton-ellipse-r.jpg`](../../images/galton-ellipse-r.jpg) | 1083×622 | 247 | 80% (4.4″) | 1316 px | 65% |  |  |

## Ch. 5: PCA & Biplots (`05-pca-biplot.qmd`) — 12 images

| Done | Image | Pixels | Eff. DPI | Printed at | Px needed @300 | Max `out-width` @300 | Action | Notes |
|------|-------|--------|----------|------------|----------------|----------------------|--------|-------|
| [ ] | [`mona-pca.png`](../../images/mona-pca.png) | 630×912 | 144 | 80% (4.4″) | 1316 px | 38% |  |  |
| [ ] | [`Pearson1901_2.png`](../../images/Pearson1901_2.png) | 632×539 | 144 | 80% (4.4″) | 1316 px | 38% |  |  |
| [ ] | [`image-compression-SVD.png`](../../images/image-compression-SVD.png) | 720×402 | 146 | 90% (4.9″) | 1480 px | 43% |  |  |
| [X] | [`peng-out-biplot-12.png`](../../images/peng-out-biplot-12.png) | 1803×1665 | 470 | 70% (3.8″) | 1151 px | 109% | REGENERATE | 2026-10-03: DPI resolved. Existing file is now 1803×1665 px (previously 577×533), giving about 470 effective DPI at the current 70% print width, above CRC’s 300-DPI minimum. Source: [R/penguin/peng-out-biplot.R](../../R/penguin/peng-out-biplot.R), which exports at 300 DPI with a canvas of 577/96 × 533/96 inches. No further resolution increase needed. The overlapping flipper-length/body-mass labels are a separate placement issue, also visible in HTML; they do not affect this DPI resolution. |
| [X] | [`peng-out-biplot-34.png`](../../images/peng-out-biplot-34.png) | 1803×1665 | 470 | 70% (3.8″) | 1151 px | 109% | REGENERATE | 2026-10-03: DPI resolved. Existing file is now 1803×1665 px (previously 577×533), giving about 470 effective DPI at the current 70% print width, above CRC’s 300-DPI minimum. Source: [R/penguin/peng-out-biplot.R](../../R/penguin/peng-out-biplot.R), which exports at 300 DPI with a canvas of 577/96 × 533/96 inches. No further resolution increase needed. |
| [ ] | [`Pearson1901.png`](../../images/Pearson1901.png) | 524×427 | 159 | 60% (3.3″) | 987 px | 31% |  |  |
| [X] | [`outlier-demo.png`](../../images/outlier-demo.png) | 916×433 | 167 | 100% (5.5″) | 1644 px | 55% | REGENERATE | 2026-11-20: Re-rendered from [R/outlier-demo.R](../../R/outlier-demo.R) lines 1–67 (script unchanged; fixed seed) at 3× the original size (`png(width = 2748, height = 1299, res = 288)`; the original was a 916×433 export at 96 dpi). Now 2748×1299, eff. ~502 dpi at 5.5″. Checked against the old image: same data, labels and layout; only the font rendering differs slightly (rendered on macOS). |
| [ ] | [`pca4ds-figure-2-11.png`](../../images/pca4ds-figure-2-11.png) | 880×416 | 178 | 90% (4.9″) | 1480 px | 53% |  |  |
| [X] | [`pca-animation-combined.jpg`](../../images/pca-animation-combined.jpg) | 1078×365 | 197 | 100% (5.5″) | 1644 px | 65% | REPLACE | 2026-11-20: Rebuilt from the full-size frames already in the repo, `images/pca-animation-split/frame_00.jpg` and `frame_32.jpg` (946×594 each; pixel-identical to the two pictures in `pca-animation-split/pca-animation-combined.pptx`). Placed with `magick` at the same positions and relative sizes as on the slide, then cropped to the old framing. Now 1744×590, eff. ~318 dpi at 5.5″. Checked against the old image: same content and framing. |
| [X] | [`diabetes-3d-both.png`](../../images/diabetes-3d-both.png) | 1143×497 | 209 | 100% (5.5″) | 1644 px | 69% | REPLACE | Used source `.pptx`, converted -> `.pdf`, used `magick` to create high-res `.png`; cropped `.png` |
| [ ] | [`pca-rotation.png`](../../images/pca-rotation.png) | 884×357 | 230 | 70% (3.8″) | 1151 px | 53% |  |  |
| [ ] | [`pca-springs-frames.jpg`](../../images/pca-springs-frames.jpg) | 1349×411 | 246 | 100% (5.5″) | 1644 px | 82% |  |  |

## Ch. 6: Linear Models (`06-linear_models.qmd`) — 1 image

| Done | Image | Pixels | Eff. DPI | Printed at | Px needed @300 | Max `out-width` @300 | Action | Notes |
|------|-------|--------|----------|------------|----------------|----------------------|--------|-------|
| [X] | [`techniques-table.png`](../../images/techniques-table.png) | 981×573 | 224 | 80% (4.4″) | 1316 px | 59% | REPLACE | Used source `.pptx`, converted -> `.pdf`, used `magick` to create high-res `.png`; cropped `.png` |

## Ch. 6 child: Linear Combinations (`child/06-linear-combinations.qmd`) — 4 images

| Done | Image | Pixels | Eff. DPI | Printed at | Px needed @300 | Max `out-width` @300 | Action | Notes |
|------|-------|--------|----------|------------|----------------|----------------------|--------|-------|
| [X] | [`lin-comb-pca.png`](../../images/lin-comb-pca.png) | 684×468 | 125 | 100% (5.5″) | 1644 px | 41% | REPLACE | Used source `.pptx`, converted -> `.pdf`, used `magick` to create high-res `.png`; cropped `.png` |
| [X] | [`lin-comb3.png`](../../images/lin-comb3.png) | 301×425 | 137 | 40% (2.2″) | 658 px | 18% | REPLACE | Used source `.pptx`, converted -> `.pdf`, used `magick` to create high-res `.png`; cropped `.png` |
| [X] | [`lin-comb4.png`](../../images/lin-comb4.png) | 332×489 | 152 | 40% (2.2″) | 658 px | 20% | REPLACE | Used source `.pptx`, converted -> `.pdf`, used `magick` to create high-res `.png`; cropped `.png` |
| [X] | [`lin-comb-mra.png`](../../images/lin-comb-mra.png) | 873×542 | 159 | 100% (5.5″) | 1644 px | 53% | REPLACE | Used source `.pptx`, converted -> `.pdf`, used `magick` to create high-res `.png`; cropped `.png` |

## Ch. 7: Linear Model Plots (`07-linear_models-plots.qmd`) — 1 image

| Done | Image | Pixels | Eff. DPI | Printed at | Px needed @300 | Max `out-width` @300 | Action | Notes |
|------|-------|--------|----------|------------|----------------|----------------------|--------|-------|
| [X] | [`duncan-av-influence.png`](../../images/duncan-av-influence.png) | 1300×650 | 237 | 100% (5.5″) | 1644 px | 79% | REGENERATE | 2026-11-20: Re-rendered from [R/Duncan/duncan-av-influence.R](../../R/Duncan/duncan-av-influence.R) (script unchanged) at 3× the original size (`png(width = 3900, height = 1950, res = 288)`; the original was a 1300×650 export at 96 dpi). Now 3900×1950, eff. ~712 dpi at 5.5″. Checked against the old image: same data, lines, arrows and labels; only the font rendering differs slightly (rendered on macOS). |

## Ch. 8: Linear Model Topics (`08-lin-mod-topics.qmd`) — 2 images

| Done | Image | Pixels | Eff. DPI | Printed at | Px needed @300 | Max `out-width` @300 | Action | Notes |
|------|-------|--------|----------|------------|----------------|----------------------|--------|-------|
| [X] | [`coffee-data-beta-both.png`](../../images/coffee-data-beta-both.png) | 917×439 | 186 | 90% (4.9″) | 1480 px | 55% | REPLACE | Used source `.pptx`, converted -> `.pdf`, used `magick` to create high-res `.png`; cropped `.png` |
| [X] | [`dual-points-lines.png`](../../images/dual-points-lines.png) | 965×520 | 196 | 90% (4.9″) | 1480 px | 58% | REGENERATE | 2026-11-20: Re-rendered from [R/dual-points-lines.R](../../R/dual-points-lines.R) lines 1–105 (script unchanged) at 3× the original size (`png(width = 2895, height = 1560, res = 288)`; the original was a 965×520 export at 96 dpi). Line 33's `intersections()` call errors outside the original session, but it isn't part of the figure. Now 2895×1560, eff. ~587 dpi at 4.9″. Checked against the old image: identical apart from slightly different font rendering (rendered on macOS). |

## Ch. 9: Collinearity & Ridge (`09-collinearity-ridge.qmd`) — 3 images

| Done | Image | Pixels | Eff. DPI | Printed at | Px needed @300 | Max `out-width` @300 | Action | Notes |
|------|-------|--------|----------|------------|----------------|----------------------|--------|-------|
| [ ] | [`collinearity-diagnostics-SPSS.png`](../../images/collinearity-diagnostics-SPSS.png) | 927×257 | 169 | 100% (5.5″) | 1644 px | 56% |  |  |
| [X] | [`collin-demo.png`](../../images/collin-demo.png) | 1190×422 | 217 | 100% (5.5″) | 1644 px | 72% | REPLACE | Used source `.pptx`, converted -> `.pdf`, used `magick` to create high-res `.png`; cropped `.png` |
| [ ] | [`wheres-waldo.png`](../../images/wheres-waldo.png) | 1474×569 | 299 | 90% (4.9″) | 1480 px | 89% |  |  |

## Ch. 10: Hotelling's T² (`10-hotelling.qmd`) — 1 image

| Done | Image | Pixels | Eff. DPI | Printed at | Px needed @300 | Max `out-width` @300 | Action | Notes |
|------|-------|--------|----------|------------|----------------|----------------------|--------|-------|
| [ ] | [`T2-diagram.png`](../../images/T2-diagram.png) | 451×410 | 118 | 70% (3.8″) | 1151 px | 27% |  |  |

## Ch. 11: MLM Review (`11-mlm-review.qmd`) — 4 images

| Done | Image | Pixels | Eff. DPI | Printed at | Px needed @300 | Max `out-width` @300 | Action | Notes |
|------|-------|--------|----------|------------|----------------|----------------------|--------|-------|
| [ ] | [`manova-diagram-anno.png`](../../images/manova-diagram-anno.png) | 413×219 | 108 | 70% (3.8″) | 1151 px | 25% |  | Added 2026-11-20: missed by the July audit (included via `here::here("images", ...)`). |
| [X] | [`VisualizingSSP.png`](../../images/VisualizingSSP.png) | 830×311 | 152 | 100% (5.5″) | 1644 px | 50% | REPLACE | 2026-10-08: The plot panels in source `.pptx` are 480×480 rasters, so a straight `.pptx` -> `.pdf` -> `magick` pass would only upsample them. Instead: re-rendered the three panels at 2400×2400 from `R/mathscore/mathscore-SS.R` (scratch copy, only change `png(..., res = 72*5)` at 5× size); exported slide 2 of the `.pptx` -> `.pdf` (intermediate, not kept); used `magick` at `-density 250` to render it and composited the hi-res panels over the originals at their exact slide positions; cropped `.png` (now 2218×845, eff. 405 dpi). `.pptx` and R script unchanged. Thin `Between` ellipse differs very slightly (script uses unseeded `jitter()`). |
| [ ] | [`manova-response-dimensions-anno.png`](../../images/manova-response-dimensions-anno.png) | 975×630 | 178 | 100% (5.5″) | 1644 px | 59% |  | Added 2026-11-20: missed by the July audit (included via `here::here("images", ...)`). |
| [ ] | [`ANCOVA-ex.png`](../../images/ANCOVA-ex.png) | 1034×493 | 210 | 90% (4.9″) | 1480 px | 62% |  |  |

## Ch. 12: MLM Visualization (`12-mlm-viz.qmd`) — 4 images

| Done | Image | Pixels | Eff. DPI | Printed at | Px needed @300 | Max `out-width` @300 | Action | Notes |
|------|-------|--------|----------|------------|----------------|----------------------|--------|-------|
| [ ] | [`dogfood-quartet.png`](../../images/dogfood-quartet.png) | 621×604 | 126 | 90% (4.9″) | 1480 px | 37% |  |  |
| [ ] | [`iris-diagram.jpg`](../../images/iris-diagram.jpg) | 550×410 | 154 | 65% (3.6″) | 1068 px | 33% |  | Added 2026-11-20: missed by the July audit (included via `here::here("images/...")`). |
| [ ] | [`HE-framework.png`](../../images/HE-framework.png) | 971×700 | 177 | 100% (5.5″) | 1644 px | 59% |  |  |
| [ ] | [`iris-HE2.png`](../../images/iris-HE2.png) | 1000×500 | 203 | 90% (4.9″) | 1480 px | 60% |  |  |

## Ch. 14: Influence & Robust Estimation (`14-infl-robust.qmd`) — 1 image

| Done | Image | Pixels | Eff. DPI | Printed at | Px needed @300 | Max `out-width` @300 | Action | Notes |
|------|-------|--------|----------|------------|----------------|----------------------|--------|-------|
| [ ] | [`weight-functions.jpg`](../../images/weight-functions.jpg) | 999×612 | 260 | 70% (3.8″) | 1151 px | 60% |  | Added 2026-11-20: missed by the July audit (included via `here::here("images", ...)`). |

## Ch. 15: Discriminant Analysis (`21-discrim.qmd`) — 1 image

| Done | Image | Pixels | Eff. DPI | Printed at | Px needed @300 | Max `out-width` @300 | Action | Notes |
|------|-------|--------|----------|------------|----------------|----------------------|--------|-------|
| [X] | [`discrim-demo-both.jpg`](../../images/discrim-demo-both.jpg) | 684×689 | 178 | 70% (3.8″) | 1151 px | 41% | REPLACE | Used source `.pptx`, converted -> `.pdf`, used `magick` to create high-res `.png`, cropped `.png` and saved as `.jpg` |

## Comments

### GK

- I cannot find a higher-res `images/MF-gray.jpg`
- I cannot find a higher-res `images/tesseract.gif` to make a higher-res `images/tesseract-frames.png`
- Do you have the source for `images/heatmap.png`?
- I am not sure if a higher-res `images/datasaurus-dozen.jpg` exists
  + Should we try to recreate this figure?

## Progress

- Images flagged LOW-DPI in the original audit: **69**.
- 2026-11-20, rows **removed** (no longer printed; checked against the current print sources and the
  2026-10-26 PDF build): `MV-juicer.png` (replaced by `MV-juicer-gpt.png`, about 350 dpi),
  `Duncan-beta-diff.png`, `arcmanov.png`, `crime-cor.png` (the printed figure is now an R chunk),
  `iris-HE1.png`, and `tours/peng-tour-demo1`/`2`/`3.png` (`peng-tour-demo-all.png` prints instead).
  All of these chunks are commented out.
- 2026-11-20, rows **added** (printed, but missed by the July audit, whose script only matches
  `include_graphics("images/...")`): `pollen-eureka1`–`4.png` (markdown `![]()`),
  `manova-diagram-anno.png`, `manova-response-dimensions-anno.png`, `weight-functions.jpg`
  (`here::here("images", ...)`), and `iris-diagram.jpg` (`here::here("images/...")`).
  No other printed image was missed.
- Rows now: **69** (69 − 8 + 8).
- Resolved: **26** as of 2026-11-20 (**20 REPLACE**, **6 REGENERATE**). Added 2026-11-20:
  `duncan-av-influence.png`, `dual-points-lines.png`, `outlier-demo.png` (REGENERATE) and
  `pca-animation-combined.jpg` (REPLACE).
- Unchecked: **43** (35 from the audit + 8 added).
- Resolved (SHRINK): **0**.
- Resolved (ACCEPT / flag to CRC): **0**.
