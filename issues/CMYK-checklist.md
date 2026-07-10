# CMYK conversion — LOW-DPI image checklist

Manual review checklist for the **69 images flagged `LOW-DPI`** in [cmyk-image-audit-results.csv](cmyk-image-audit-results.csv) (effective print resolution below CRC's 300 dpi minimum at the size the image is printed).
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
| [X] | [`icons/books.jpg`](../images/icons/books.jpg) | 1187×369 | 217 | 100% (5.5″) | 1644 px | 72% | REPLACE | Used source `.pptx`, converted -> `.pdf`, used `magick` to create high-res `.png`, cropped `.png` and saved as `.jpg` |
| [X] | [`fig-book-parts.png`](../images/fig-book-parts.png) | 1307×145 | 251 | 95% (5.2″) | 1562 px | 79% | REPLACE | 2026-07-10: was a frozen raster of a smartdiagram; source recreated as `latex/diagrams/fig-book-parts.tex` (build instructions inside). Print now uses a **vector CMYK PDF** (`images/fig-book-parts.pdf` — no DPI limit, no RGB→CMYK raster conversion needed); PNG re-rendered at 600 dpi for HTML (2729×323 px, eff. 524 dpi). `index.qmd` picks PDF for LaTeX, PNG for HTML. |

## About the Author (`00-Author.qmd`) — 1 image

| Done | Image | Pixels | Eff. DPI | Printed at | Px needed @300 | Max `out-width` @300 | Action | Notes |
|------|-------|--------|----------|------------|----------------|----------------------|--------|-------|
| [ ] | [`MF-gray.jpg`](../images/MF-gray.jpg) | 172×225 | 105 | 30% (1.6″) | 494 px | 10% |  |  |

## Ch. 1: Prelude (`01-Prelude.qmd`) — 5 images

| Done | Image | Pixels | Eff. DPI | Printed at | Px needed @300 | Max `out-width` @300 | Action | Notes |
|------|-------|--------|----------|------------|----------------|----------------------|--------|-------|
| [X] | [`1D-4D.png`](../images/1D-4D.png) | 482×305 | 98 | 90% (4.9″) | 1480 px | 29% | REPLACE | 2026-07-10: was an unattributed web graphic (circulating online since ≥2015; no hi-res original found). Redrawn as an exact author TikZ replica, source `latex/diagrams/fig-1D-4D.tex` (geometry traced programmatically from the raster). Print uses **vector CMYK PDF** (`images/1D-4D.pdf`); PNG re-rendered at 600 dpi for HTML (2846×1801 px, eff. 577 dpi). `01-Prelude.qmd` picks PDF for LaTeX, PNG for HTML. Also resolves the permission question in `fig-permission-list.md`. |
| [ ] | [`flatland-spheres.jpg`](../images/flatland-spheres.jpg) | 660×208 | 134 | 90% (4.9″) | 1480 px | 40% |  |  |
| [X] | [`history/discoveries.jpg`](../images/history/discoveries.jpg) | 1007×367 | 184 | 100% (5.5″) | 1644 px | 61% | REPLACE | Used source `.pptx`, converted -> `.pdf`, used `magick` to create high-res `.png`, cropped `.png` and saved as `.jpg` |
| [ ] | [`ReavenMiller-3d-annotated.png`](../images/ReavenMiller-3d-annotated.png) | 833×667 | 217 | 70% (3.8″) | 1151 px | 50% |  |  |
| [ ] | [`tesseract-frames.png`](../images/tesseract-frames.png) | 1280×256 | 234 | 100% (5.5″) | 1644 px | 77% |  |  |

## Ch. 2: Introduction (`02-intro.qmd`) — 2 images

| Done | Image | Pixels | Eff. DPI | Printed at | Px needed @300 | Max `out-width` @300 | Action | Notes |
|------|-------|--------|----------|------------|----------------|----------------------|--------|-------|
| [ ] | [`Cover-GBE.png`](../images/Cover-GBE.png) | 456×489 | 139 | 60% (3.3″) | 987 px | 27% |  |  |
| [ ] | [`heatmap.png`](../images/heatmap.png) | 1065×902 | 278 | 70% (3.8″) | 1151 px | 64% |  |  |

## Ch. 3: Getting Started (`03-getting_started.qmd`) — 3 images

| Done | Image | Pixels | Eff. DPI | Printed at | Px needed @300 | Max `out-width` @300 | Action | Notes |
|------|-------|--------|----------|------------|----------------|----------------------|--------|-------|
| [ ] | [`datasaurus-dozen.jpg`](../images/datasaurus-dozen.jpg) | 680×425 | 124 | 100% (5.5″) | 1644 px | 41% |  |  |
| [ ] | [`anscombe1.png`](../images/anscombe1.png) | 650×480 | 132 | 90% (4.9″) | 1480 px | 39% |  |  |
| [ ] | [`1969_draft_lottery_photo.jpg`](../images/1969_draft_lottery_photo.jpg) | 1024×690 | 234 | 80% (4.4″) | 1316 px | 62% |  |  |

## Ch. 4: Multivariate Plots (`04-multivariate_plots.qmd`) — 22 images

| Done | Image | Pixels | Eff. DPI | Printed at | Px needed @300 | Max `out-width` @300 | Action | Notes |
|------|-------|--------|----------|------------|----------------|----------------------|--------|-------|
| [ ] | [`tours/peng-tour-anomalies-final.png`](../images/tours/peng-tour-anomalies-final.png) | 460×460 | 84 | 100% (5.5″) | 1644 px | 27% |  |  |
| [ ] | [`tours/peng-tour-lda-final.png`](../images/tours/peng-tour-lda-final.png) | 460×460 | 84 | 100% (5.5″) | 1644 px | 27% |  |  |
| [ ] | [`tours/peng-tour-grand-lbls-split/frame_00.png`](../images/tours/peng-tour-grand-lbls-split/frame_00.png) | 480×480 | 88 | 100% (5.5″) | 1644 px | 29% |  |  |
| [ ] | [`tours/peng-tour-grand-lbls-split/frame_10.png`](../images/tours/peng-tour-grand-lbls-split/frame_10.png) | 480×480 | 88 | 100% (5.5″) | 1644 px | 29% |  |  |
| [ ] | [`tours/peng-tour-grand-lbls-split/frame_26.png`](../images/tours/peng-tour-grand-lbls-split/frame_26.png) | 480×480 | 88 | 100% (5.5″) | 1644 px | 29% |  |  |
| [ ] | [`tours/peng-tour-demo1.png`](../images/tours/peng-tour-demo1.png) | 568×514 | 104 | 100% (5.5″) | 1644 px | 34% |  |  |
| [ ] | [`tours/peng-tour-demo2.png`](../images/tours/peng-tour-demo2.png) | 568×514 | 104 | 100% (5.5″) | 1644 px | 34% |  |  |
| [ ] | [`tours/peng-tour-demo3.png`](../images/tours/peng-tour-demo3.png) | 568×514 | 104 | 100% (5.5″) | 1644 px | 34% |  |  |
| [ ] | [`mahalanobis.png`](../images/mahalanobis.png) | 332×334 | 121 | 50% (2.7″) | 822 px | 20% |  |  |
| [ ] | [`crime-cor.png`](../images/crime-cor.png) | 540×540 | 123 | 80% (4.4″) | 1316 px | 32% |  |  |
| [ ] | [`corrgram-renderings.png`](../images/corrgram-renderings.png) | 656×245 | 150 | 80% (4.4″) | 1316 px | 39% |  |  |
| [ ] | [`projection.png`](../images/projection.png) | 336×247 | 153 | 40% (2.2″) | 658 px | 20% |  |  |
| [X] | [`tours/peng-tour-demo-all.png`](../images/tours/peng-tour-demo-all.png) | 992×356 | 181 | 100% (5.5″) | 1644 px | 60% | REPLACE | Used source `.pptx`, converted -> `.pdf`, used `magick` to create high-res `.png`; cropped `.png` |
| [ ] | [`crime-pvPlot-1-2.png`](../images/crime-pvPlot-1-2.png) | 1000×500 | 182 | 100% (5.5″) | 1644 px | 60% |  |  |
| [ ] | [`big5-qgraph-rodrigues.png`](../images/big5-qgraph-rodrigues.png) | 910×627 | 184 | 90% (4.9″) | 1480 px | 55% |  |  |
| [ ] | [`galton-corr.jpg`](../images/galton-corr.jpg) | 745×631 | 194 | 70% (3.8″) | 1151 px | 45% |  |  |
| [ ] | [`proj-P2-vec.png`](../images/proj-P2-vec.png) | 532×468 | 194 | 50% (2.7″) | 822 px | 32% |  |  |
| [ ] | [`peng-colors.png`](../images/peng-colors.png) | 577×480 | 211 | 50% (2.7″) | 822 px | 35% |  |  |
| [ ] | [`proj-combined.png`](../images/proj-combined.png) | 1193×464 | 218 | 100% (5.5″) | 1644 px | 72% |  |  |
| [ ] | [`peng-tourr-diagram.png`](../images/peng-tourr-diagram.png) | 997×505 | 227 | 80% (4.4″) | 1316 px | 60% |  |  |
| [ ] | [`proj-vectors-labels.png`](../images/proj-vectors-labels.png) | 1264×436 | 231 | 100% (5.5″) | 1644 px | 76% |  |  |
| [ ] | [`galton-ellipse-r.jpg`](../images/galton-ellipse-r.jpg) | 1083×622 | 247 | 80% (4.4″) | 1316 px | 65% |  |  |

## Ch. 5: PCA & Biplots (`05-pca-biplot.qmd`) — 13 images

| Done | Image | Pixels | Eff. DPI | Printed at | Px needed @300 | Max `out-width` @300 | Action | Notes |
|------|-------|--------|----------|------------|----------------|----------------------|--------|-------|
| [ ] | [`mona-pca.png`](../images/mona-pca.png) | 630×912 | 144 | 80% (4.4″) | 1316 px | 38% |  |  |
| [ ] | [`Pearson1901_2.png`](../images/Pearson1901_2.png) | 632×539 | 144 | 80% (4.4″) | 1316 px | 38% |  |  |
| [ ] | [`image-compression-SVD.png`](../images/image-compression-SVD.png) | 720×402 | 146 | 90% (4.9″) | 1480 px | 43% |  |  |
| [ ] | [`peng-out-biplot-12.png`](../images/peng-out-biplot-12.png) | 577×533 | 150 | 70% (3.8″) | 1151 px | 35% |  |  |
| [ ] | [`peng-out-biplot-34.png`](../images/peng-out-biplot-34.png) | 577×533 | 150 | 70% (3.8″) | 1151 px | 35% |  |  |
| [ ] | [`Pearson1901.png`](../images/Pearson1901.png) | 524×427 | 159 | 60% (3.3″) | 987 px | 31% |  |  |
| [ ] | [`outlier-demo.png`](../images/outlier-demo.png) | 916×433 | 167 | 100% (5.5″) | 1644 px | 55% |  |  |
| [ ] | [`pca4ds-figure-2-11.png`](../images/pca4ds-figure-2-11.png) | 880×416 | 178 | 90% (4.9″) | 1480 px | 53% |  |  |
| [ ] | [`MV-juicer.png`](../images/MV-juicer.png) | 836×427 | 191 | 80% (4.4″) | 1316 px | 50% |  |  |
| [ ] | [`pca-animation-combined.jpg`](../images/pca-animation-combined.jpg) | 1078×365 | 197 | 100% (5.5″) | 1644 px | 65% |  |  |
| [X] | [`diabetes-3d-both.png`](../images/diabetes-3d-both.png) | 1143×497 | 209 | 100% (5.5″) | 1644 px | 69% | REPLACE | Used source `.pptx`, converted -> `.pdf`, used `magick` to create high-res `.png`; cropped `.png` |
| [ ] | [`pca-rotation.png`](../images/pca-rotation.png) | 884×357 | 230 | 70% (3.8″) | 1151 px | 53% |  |  |
| [ ] | [`pca-springs-frames.jpg`](../images/pca-springs-frames.jpg) | 1349×411 | 246 | 100% (5.5″) | 1644 px | 82% |  |  |

## Ch. 6: Linear Models (`06-linear_models.qmd`) — 1 image

| Done | Image | Pixels | Eff. DPI | Printed at | Px needed @300 | Max `out-width` @300 | Action | Notes |
|------|-------|--------|----------|------------|----------------|----------------------|--------|-------|
| [ ] | [`techniques-table.png`](../images/techniques-table.png) | 981×573 | 224 | 80% (4.4″) | 1316 px | 59% |  |  |

## Ch. 6 child: Linear Combinations (`child/06-linear-combinations.qmd`) — 4 images

| Done | Image | Pixels | Eff. DPI | Printed at | Px needed @300 | Max `out-width` @300 | Action | Notes |
|------|-------|--------|----------|------------|----------------|----------------------|--------|-------|
| [ ] | [`lin-comb-pca.png`](../images/lin-comb-pca.png) | 684×468 | 125 | 100% (5.5″) | 1644 px | 41% |  |  |
| [ ] | [`lin-comb3.png`](../images/lin-comb3.png) | 301×425 | 137 | 40% (2.2″) | 658 px | 18% |  |  |
| [ ] | [`lin-comb4.png`](../images/lin-comb4.png) | 332×489 | 152 | 40% (2.2″) | 658 px | 20% |  |  |
| [ ] | [`lin-comb-mra.png`](../images/lin-comb-mra.png) | 873×542 | 159 | 100% (5.5″) | 1644 px | 53% |  |  |

## Ch. 7: Linear Model Plots (`07-linear_models-plots.qmd`) — 2 images

| Done | Image | Pixels | Eff. DPI | Printed at | Px needed @300 | Max `out-width` @300 | Action | Notes |
|------|-------|--------|----------|------------|----------------|----------------------|--------|-------|
| [ ] | [`Duncan-beta-diff.png`](../images/Duncan-beta-diff.png) | 598×536 | 156 | 70% (3.8″) | 1151 px | 36% |  |  |
| [ ] | [`duncan-av-influence.png`](../images/duncan-av-influence.png) | 1300×650 | 237 | 100% (5.5″) | 1644 px | 79% |  |  |

## Ch. 8: Linear Model Topics (`08-lin-mod-topics.qmd`) — 2 images

| Done | Image | Pixels | Eff. DPI | Printed at | Px needed @300 | Max `out-width` @300 | Action | Notes |
|------|-------|--------|----------|------------|----------------|----------------------|--------|-------|
| [X] | [`coffee-data-beta-both.png`](../images/coffee-data-beta-both.png) | 917×439 | 186 | 90% (4.9″) | 1480 px | 55% | REPLACE | Used source `.pptx`, converted -> `.pdf`, used `magick` to create high-res `.png`; cropped `.png` |
| [ ] | [`dual-points-lines.png`](../images/dual-points-lines.png) | 965×520 | 196 | 90% (4.9″) | 1480 px | 58% |  |  |

## Ch. 9: Collinearity & Ridge (`09-collinearity-ridge.qmd`) — 3 images

| Done | Image | Pixels | Eff. DPI | Printed at | Px needed @300 | Max `out-width` @300 | Action | Notes |
|------|-------|--------|----------|------------|----------------|----------------------|--------|-------|
| [ ] | [`collinearity-diagnostics-SPSS.png`](../images/collinearity-diagnostics-SPSS.png) | 927×257 | 169 | 100% (5.5″) | 1644 px | 56% |  |  |
| [X] | [`collin-demo.png`](../images/collin-demo.png) | 1190×422 | 217 | 100% (5.5″) | 1644 px | 72% | REPLACE | Used source `.pptx`, converted -> `.pdf`, used `magick` to create high-res `.png`; cropped `.png` |
| [ ] | [`wheres-waldo.png`](../images/wheres-waldo.png) | 1474×569 | 299 | 90% (4.9″) | 1480 px | 89% |  |  |

## Ch. 10: Hotelling's T² (`10-hotelling.qmd`) — 1 image

| Done | Image | Pixels | Eff. DPI | Printed at | Px needed @300 | Max `out-width` @300 | Action | Notes |
|------|-------|--------|----------|------------|----------------|----------------------|--------|-------|
| [ ] | [`T2-diagram.png`](../images/T2-diagram.png) | 451×410 | 118 | 70% (3.8″) | 1151 px | 27% |  |  |

## Ch. 11: MLM Review (`11-mlm-review.qmd`) — 2 images

| Done | Image | Pixels | Eff. DPI | Printed at | Px needed @300 | Max `out-width` @300 | Action | Notes |
|------|-------|--------|----------|------------|----------------|----------------------|--------|-------|
| [ ] | [`VisualizingSSP.png`](../images/VisualizingSSP.png) | 830×311 | 152 | 100% (5.5″) | 1644 px | 50% |  |  |
| [ ] | [`ANCOVA-ex.png`](../images/ANCOVA-ex.png) | 1034×493 | 210 | 90% (4.9″) | 1480 px | 62% |  |  |

## Ch. 12: MLM Visualization (`12-mlm-viz.qmd`) — 5 images

| Done | Image | Pixels | Eff. DPI | Printed at | Px needed @300 | Max `out-width` @300 | Action | Notes |
|------|-------|--------|----------|------------|----------------|----------------------|--------|-------|
| [ ] | [`dogfood-quartet.png`](../images/dogfood-quartet.png) | 621×604 | 126 | 90% (4.9″) | 1480 px | 37% |  |  |
| [ ] | [`HE-framework.png`](../images/HE-framework.png) | 971×700 | 177 | 100% (5.5″) | 1644 px | 59% |  |  |
| [ ] | [`iris-HE1.png`](../images/iris-HE1.png) | 1000×500 | 182 | 100% (5.5″) | 1644 px | 60% |  |  |
| [ ] | [`iris-HE2.png`](../images/iris-HE2.png) | 1000×500 | 203 | 90% (4.9″) | 1480 px | 60% |  |  |
| [ ] | [`arcmanov.png`](../images/arcmanov.png) | 1503×1603 | 274 | 100% (5.5″) | 1644 px | 91% |  |  |

## Ch. 15: Discriminant Analysis (`21-discrim.qmd`) — 1 image

| Done | Image | Pixels | Eff. DPI | Printed at | Px needed @300 | Max `out-width` @300 | Action | Notes |
|------|-------|--------|----------|------------|----------------|----------------------|--------|-------|
| [X] | [`discrim-demo-both.jpg`](../images/discrim-demo-both.jpg) | 684×689 | 178 | 70% (3.8″) | 1151 px | 41% | REPLACE | Used source `.pptx`, converted -> `.pdf`, used `magick` to create high-res `.png`, cropped `.png` and saved as `.jpg` |

## Progress

- Total LOW-DPI images: **69**
- Resolved (REPLACE): 
- Resolved (SHRINK): 
- Resolved (ACCEPT / flag to CRC): 
