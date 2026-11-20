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
| [X] | [`pollen-eureka1.png`](../../images/pollen-eureka1.png) | 535×531 | 195 | 50% (2.7″) | 822 px | 32% | REGENERATE | Added 2026-11-20: missed by the July audit (included via markdown `![](images/...)`). One panel of a 2×2 layout, so it prints in a half-width column; the `{width=40%}` in the `.qmd` doesn't apply in the PDF. **Regenerated 2026-11-20** with new script [R/pollen-eureka-frames.R](../../R/pollen-eureka-frames.R). The old panels were 2023 screenshots of the rgl view in `R/pollen-animation.R`. The new ones use the same view (userMatrix), with each panel's zoom matched to its screenshot (0.87, 0.51, 0.223, 0.084 for panels 1–4) and point size set to match the old ink density. They're rendered at 3× pixel density through webshot2: each panel is now 1605×1593, eff. ~585 dpi at 2.7″. Visible changes, approved by GK: axis titles removed (the old ones read V1/V3), and in panel 1 the NUB tick labels sit on a different box edge (current rgl layout). |
| [X] | [`pollen-eureka2.png`](../../images/pollen-eureka2.png) | 535×531 | 195 | 50% (2.7″) | 822 px | 32% | REGENERATE | Added 2026-11-20; regenerated 2026-11-20. Same as `pollen-eureka1.png`. |
| [X] | [`pollen-eureka3.png`](../../images/pollen-eureka3.png) | 535×531 | 195 | 50% (2.7″) | 822 px | 32% | REGENERATE | Added 2026-11-20; regenerated 2026-11-20. Same as `pollen-eureka1.png`. |
| [X] | [`pollen-eureka4.png`](../../images/pollen-eureka4.png) | 535×531 | 195 | 50% (2.7″) | 822 px | 32% | REGENERATE | Added 2026-11-20; regenerated 2026-11-20. Same as `pollen-eureka1.png`. |
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
| [X] | [`tours/peng-tour-anomalies-final.png`](../../images/tours/peng-tour-anomalies-final.png) | 460×460 | 84 | 100% (5.5″) | 1644 px | 27% | REGENERATE | 2026-11-20: Rebuilt at 3× (1380×1380) with new script [R/penguin/peng-tour-frames.R](../../R/penguin/peng-tour-frames.R). The original came from an unseeded interactive guided tour, so its projection was recovered from the image itself: a 4×2 basis was fitted so that a `display_xy()` render overlays the original, and four different starting points all converged to the same basis. The audit's 84 dpi assumed full width; it actually prints in a half-width panel (was ~168 dpi, now ~505 dpi). Checked against the old image: same projection, points, axes and legend. |
| [X] | [`tours/peng-tour-lda-final.png`](../../images/tours/peng-tour-lda-final.png) | 460×460 | 84 | 100% (5.5″) | 1644 px | 27% | REGENERATE | 2026-11-20: Rebuilt at 3× (1380×1380) the same way as `peng-tour-anomalies-final.png`, with the projection recovered from the original image. Was ~168 dpi as printed (half-width panel), now ~505 dpi. Checked against the old image: same projection, points, axes and legend. The old image's orange and green were slightly off the book's palette (#EA7E1A, #419F30); the new one uses the defined penguin colors. |
| [X] | [`tours/peng-tour-grand-lbls-split/frame_00.png`](../../images/tours/peng-tour-grand-lbls-split/frame_00.png) | 480×480 | 88 | 100% (5.5″) | 1644 px | 29% | REGENERATE | 2026-11-20: Re-rendered at 3× (1440×1440) with new script [R/penguin/peng-tour-frames.R](../../R/penguin/peng-tour-frames.R). These are frames 1, 11 and 27 of the seeded grand tour (`set.seed(1234)`) in `R/penguin/peng-tourr.R`, which made `peng-tourr-grand-lbls.gif`. Settings were matched to that GIF: labels 283/10/35, Chinstrap drawn as diamonds (pch 18), and the cairo device for exact colors. The audit's 88 dpi assumed full width; it actually prints in a one-third-width panel (was ~265 dpi, now ~795 dpi). Checked against the old frame: same projection, points, labels and legend. The other 47 frames in this folder aren't used by the book and are unchanged. |
| [X] | [`tours/peng-tour-grand-lbls-split/frame_10.png`](../../images/tours/peng-tour-grand-lbls-split/frame_10.png) | 480×480 | 88 | 100% (5.5″) | 1644 px | 29% | REGENERATE | 2026-11-20; same as `frame_00.png`. |
| [X] | [`tours/peng-tour-grand-lbls-split/frame_26.png`](../../images/tours/peng-tour-grand-lbls-split/frame_26.png) | 480×480 | 88 | 100% (5.5″) | 1644 px | 29% | REGENERATE | 2026-11-20; same as `frame_00.png`. |
| [X] | [`mahalanobis.png`](../../images/mahalanobis.png) | 332×334 | 121 | 50% (2.7″) | 822 px | 20% | REPLACE | 2026-11-20: Re-exported at 4× from its source, `images/mahalanobis.svg`, Michael's Inkscape redraw. The SVG is fully vector; the copy of Ou Zhang's original embedded in it sits off the page as a tracing guide and doesn't show. An Inkscape 1.4.4 export at 96 dpi is pixel-identical to the old PNG. The new file is `inkscape mahalanobis.svg --export-type=png --export-dpi=384`: 1328×1336, eff. ~485 dpi at 2.7″. Content is unchanged, so the permission row is unaffected. |
| [X] | [`corrgram-renderings.png`](../../images/corrgram-renderings.png) | 656×245 | 150 | 80% (4.4″) | 1316 px | 39% | REGENERATE | 2026-11-20: The old PNG had no source (R base graphics, probably a screenshot of a Windows graphics window). Redrawn with new script [R/corrgram-renderings.R](../../R/corrgram-renderings.R), using the old image's pixel layout as coordinates and its measured colour scale (linear red–white–blue). Rendered at 4×: 2624×980, eff. ~600 dpi at 4.4″. A vector PDF from the same script is kept offline, outside the repo (`Offline-Vis-MLM/images/corrgram-renderings.pdf`). Visible changes, approved by GK: Arial text at a compromise size (the old text was a little taller and bolder), number labels centred exactly over their columns, and no radius line in the −100 pie. Content is unchanged, so the permission row is unaffected. |
| [X] | [`projection.png`](../../images/projection.png) | 336×247 | 153 | 40% (2.2″) | 658 px | 20% | REPLACE | 2026-11-20: Re-exported from its source, slide 1 of `images/projections.pptx` (all vector). Exported to PDF from PowerPoint, rendered with `pdftoppm` at ~419 dpi, and cropped to the old framing (the crop was fitted so a 1× render lines up with the old PNG). Now 1344×988, eff. ~613 dpi at 2.2″. Checked against the old image: same drawing and labels. |
| [X] | [`tours/peng-tour-demo-all.png`](../../images/tours/peng-tour-demo-all.png) | 992×356 | 181 | 100% (5.5″) | 1644 px | 60% | REPLACE | Used source `.pptx`, converted -> `.pdf`, used `magick` to create high-res `.png`; cropped `.png` |
| [X] | [`crime-pvPlot-1-2.png`](../../images/crime-pvPlot-1-2.png) | 1000×500 | 182 | 100% (5.5″) | 1644 px | 60% | REGENERATE | 2026-11-20: Re-rendered at 3× with new script [R/crime/crime-pvPlot-frames.R](../../R/crime/crime-pvPlot-frames.R). The original (Oct. 2024) is two 500×500 panels at 72 ppi, `crime-pvPlot1.png` and `crime-pvPlot2.png` (also regenerated, not printed), drawn with the book's old `pvPlot()` (git `713f707e:R/pvPlot.R`, via `car::scatterplot()`), not the current `heplots::pvPlot()`. The script carries a copy of that drawing code; with current `car` it also turns off the ellipse-centre dot and passes the state labels explicitly. Now 3000×1500, eff. ~548 dpi at 5.5″. Checked against the old image: same content and layout; only the font rendering differs slightly (macOS). **For Michael:** (1) the displayed code chunk `fig-crime-pvPlots-code` (`eval: false`, `ellipse.args = list(col = "red", levels = c(0.68, 0.95))`) does not produce this figure; a render of that code with `heplots::pvPlot()` looks quite different, and its 95% ellipses are clipped by the axes. (2) The text after the figure says "Arkansas (AK)" (AK is Alaska) and has "and and". |
| [ ] | [`big5-qgraph-rodrigues.png`](../../images/big5-qgraph-rodrigues.png) | 910×627 | 184 | 90% (4.9″) | 1480 px | 55% |  |  |
| [ ] | [`galton-corr.jpg`](../../images/galton-corr.jpg) | 745×631 | 194 | 70% (3.8″) | 1151 px | 45% |  |  |
| [X] | [`proj-P2-vec.png`](../../images/proj-P2-vec.png) | 532×468 | 194 | 50% (2.7″) | 822 px | 32% | REGENERATE | 2026-11-20: Re-rendered at 3× from `R/projections.R` lines 93–102, with the `par(mar = c(4, 5, 1, 1) + .1)` margins and a 96-dpi base (`png(1596, 1404, res = 288, type = "cairo")`). Now eff. ~580 dpi. Checked against the old image: same plot. |
| [X] | [`peng-colors.png`](../../images/peng-colors.png) | 577×480 | 211 | 50% (2.7″) | 822 px | 35% | REGENERATE | 2026-11-20: Swatches re-rendered at 3× with `show_col(cols.mat)` from `R/penguin/penguin-colors.R` (`png(1731, 1440, res = 288, type = "cairo")`). The species names had been added afterwards in another program, with a drop shadow; they were redrawn in Arial with a matching soft shadow (ImageMagick) at the measured positions and size. Now eff. ~630 dpi. |
| [X] | [`proj-combined.png`](../../images/proj-combined.png) | 1193×464 | 218 | 100% (5.5″) | 1644 px | 72% | REPLACE | 2026-11-20: Rebuilt from slide 2 of `images/projections.pptx` (PowerPoint PDF, ~288 dpi, cropped to the old framing). Panels (b) and (c) were re-rendered from `R/projections.R` lines 40–48 at their slide frame size with transparent backgrounds, then layered in slide order. **Panel (a)**, the hand-rotated rgl cube screenshot, still uses its original 434 px image, so it stays at ~236 dpi; the rest is ~650 dpi. |
| [ ] | [`peng-tourr-diagram.png`](../../images/peng-tourr-diagram.png) | 997×505 | 227 | 80% (4.4″) | 1316 px | 60% |  |  |
| [X] | [`proj-vectors-labels.png`](../../images/proj-vectors-labels.png) | 1264×436 | 231 | 100% (5.5″) | 1644 px | 76% | REPLACE | 2026-11-20: Rebuilt from slide 3 of `images/projections.pptx` (high-res 4200×3000 panels; PowerPoint PDF at ~314 dpi, cropped to the old framing). The red P1/P2 labels aren't on the slide; they were redrawn in Arial (#FC4242) with a matching soft shadow at the measured positions and size. Now 3792×1308, eff. ~690 dpi. |
| [ ] | [`galton-ellipse-r.jpg`](../../images/galton-ellipse-r.jpg) | 1083×622 | 247 | 80% (4.4″) | 1316 px | 65% |  |  |

## Ch. 5: PCA & Biplots (`05-pca-biplot.qmd`) — 12 images

| Done | Image | Pixels | Eff. DPI | Printed at | Px needed @300 | Max `out-width` @300 | Action | Notes |
|------|-------|--------|----------|------------|----------------|----------------------|--------|-------|
| [X] | [`mona-pca.png`](../../images/mona-pca.png) | 630×912 | 144 | 80% (4.4″) | 1316 px | 38% | REGENERATE | 2026-11-20: Regenerated the nine panels from [R/PCA-MonaLisa.R](../../R/PCA-MonaLisa.R) and the local grayscale Mona Lisa. Rendered at 1890×2736, ~431 effective dpi at the existing 80% width. Same component counts and panel order. |
| [X] | [`Pearson1901_2.png`](../../images/Pearson1901_2.png) | 632×539 | 144 | 80% (4.4″) | 1316 px | 38% | REPLACE | 2026-11-20: Cropped p. 566 of the [Internet Archive black-and-white scan](https://archive.org/download/londonedinburgh621901lond/londonedinburgh621901lond_bw.pdf). Used the native 500-ppi ink layer on white and slightly strengthened the strokes as approved. Now 2002×1724, ~457 effective dpi at 80% width. |
| [X] | [`image-compression-SVD.png`](../../images/image-compression-SVD.png) | 720×402 | 146 | 90% (4.9″) | 1480 px | 43% | REPLACE | 2026-11-20: Retrieved [Kobayashi’s original upload](https://miro.medium.com/v2/1*3Ibw60VZ2-ZfvfjaL0xn-A.png) of the same schematic. Now 2752×1536, ~558 effective dpi at 90% width. |
| [X] | [`peng-out-biplot-12.png`](../../images/peng-out-biplot-12.png) | 1803×1665 | 470 | 70% (3.8″) | 1151 px | 109% | REGENERATE | 2026-10-03: DPI resolved. Existing file is now 1803×1665 px (previously 577×533), giving about 470 effective DPI at the current 70% print width, above CRC’s 300-DPI minimum. Source: [R/penguin/peng-out-biplot.R](../../R/penguin/peng-out-biplot.R), which exports at 300 DPI with a canvas of 577/96 × 533/96 inches. No further resolution increase needed. The overlapping flipper-length/body-mass labels are a separate placement issue, also visible in HTML; they do not affect this DPI resolution. |
| [X] | [`peng-out-biplot-34.png`](../../images/peng-out-biplot-34.png) | 1803×1665 | 470 | 70% (3.8″) | 1151 px | 109% | REGENERATE | 2026-10-03: DPI resolved. Existing file is now 1803×1665 px (previously 577×533), giving about 470 effective DPI at the current 70% print width, above CRC’s 300-DPI minimum. Source: [R/penguin/peng-out-biplot.R](../../R/penguin/peng-out-biplot.R), which exports at 300 DPI with a canvas of 577/96 × 533/96 inches. No further resolution increase needed. |
| [X] | [`Pearson1901.png`](../../images/Pearson1901.png) | 524×427 | 159 | 60% (3.3″) | 987 px | 31% | REPLACE | 2026-11-20: Cropped Pearson’s original diagram from p. 560 of the [scanned paper](https://pca.narod.ru/pearson1901.pdf) at native scan density. Approved crop is 1344×1095, ~409 effective dpi at the existing 60% width. |
| [X] | [`outlier-demo.png`](../../images/outlier-demo.png) | 916×433 | 167 | 100% (5.5″) | 1644 px | 55% | REGENERATE | 2026-11-20: Re-rendered from [R/outlier-demo.R](../../R/outlier-demo.R) lines 1–67 (script unchanged; fixed seed) at 3× the original size (`png(width = 2748, height = 1299, res = 288)`; the original was a 916×433 export at 96 dpi). Now 2748×1299, eff. ~502 dpi at 5.5″. Checked against the old image: same data, labels and layout; only the font rendering differs slightly (rendered on macOS). |
| [X] | [`pca4ds-figure-2-11.png`](../../images/pca4ds-figure-2-11.png) | 880×416 | 178 | 90% (4.9″) | 1480 px | 53% | REPLACE | 2026-11-20: Exported the approved [vector redraw](../../images/pca4ds-figure-2-11.svg) of Aluja et al., Figure 2.11, at 3×. Now 2640×1248, ~535 effective dpi at the existing 90% width. Original attribution retained. |
| [X] | [`pca-animation-combined.jpg`](../../images/pca-animation-combined.jpg) | 1078×365 | 197 | 100% (5.5″) | 1644 px | 65% | REPLACE | 2026-11-20: Rebuilt from the full-size frames already in the repo, `images/pca-animation-split/frame_00.jpg` and `frame_32.jpg` (946×594 each; pixel-identical to the two pictures in `pca-animation-split/pca-animation-combined.pptx`). Placed with `magick` at the same positions and relative sizes as on the slide, then cropped to the old framing. Now 1744×590, eff. ~318 dpi at 5.5″. Checked against the old image: same content and framing. |
| [X] | [`diabetes-3d-both.png`](../../images/diabetes-3d-both.png) | 1143×497 | 209 | 100% (5.5″) | 1644 px | 69% | REPLACE | Used source `.pptx`, converted -> `.pdf`, used `magick` to create high-res `.png`; cropped `.png` |
| [X] | [`pca-rotation.png`](../../images/pca-rotation.png) | 884×357 | 230 | 70% (3.8″) | 1151 px | 53% | REPLACE | 2026-11-20: Re-exported from its source, `images/pca-rotation.pptx`, using the **Dec 2023 version from git** (commit `e84dcc98`), the one that made the old PNG. The current deck was edited in Apr 2024 and has black √λ labels; the book's are red. Exported to PDF from PowerPoint (which draws the √λ equations as vector text), rendered with `pdftoppm` at ~258 dpi, and cropped to the old framing (crop fitted so a 1× render lines up with the old PNG). Now 2652×1071, eff. ~690 dpi at 3.8″. Checked against the old image: same drawing, labels and colors. |
| [X] | [`pca-springs-frames.jpg`](../../images/pca-springs-frames.jpg) | 1349×411 | 246 | 100% (5.5″) | 1644 px | 82% | REGENERATE | 2026-11-20: Regenerated all 100 points and projections in frames 0, 20 and 128 using the seed and equations from [Amoeba’s animation code](https://gist.github.com/anonymous/7d888663c6ec679ea65428715b99bfdd). Exported the [vector frames](../../images/pca-springs/pca-springs-frames.svg) at 4047×1233, ~739 effective dpi at full text width. |

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
| [X] | [`collinearity-diagnostics-SPSS.png`](../../images/collinearity-diagnostics-SPSS.png) | 927×257 | 169 | 100% (5.5″) | 1644 px | 56% | REGENERATE | 2026-11-20: Retypeset the table at 3708×1028 (~677 effective dpi at full width), preserving the seven data rows, headings, shading and footnote. |
| [X] | [`collin-demo.png`](../../images/collin-demo.png) | 1190×422 | 217 | 100% (5.5″) | 1644 px | 72% | REPLACE | Used source `.pptx`, converted -> `.pdf`, used `magick` to create high-res `.png`; cropped `.png` |
| [X] | [`wheres-waldo.png`](../../images/wheres-waldo.png) | 1474×569 | 299 | 90% (4.9″) | 1480 px | 89% | REPLACE | 2026-11-20: Rebuilt the composite from the [original scene](https://x.com/ErrorJustin/status/830205933598879744) and a [larger scan for the inset](https://vuss.io/wp-content/uploads/2025/01/Wheres-Waldo-Ocean-Super-High-Resolution.jpg), retaining the crop, oval and dashed connectors. The 2948×1138 file prints at ~598 dpi at the existing 90% width. The scene supplies ~542 native dpi. GK accepted the inset as shown (~333 source pixels across 1.86″, about 179 native dpi). |

## Ch. 10: Hotelling's T² (`10-hotelling.qmd`) — 1 image

| Done | Image | Pixels | Eff. DPI | Printed at | Px needed @300 | Max `out-width` @300 | Action | Notes |
|------|-------|--------|----------|------------|----------------|----------------------|--------|-------|
| [X] | [`T2-diagram.png`](../../images/T2-diagram.png) | 451×410 | 118 | 70% (3.8″) | 1151 px | 27% | REGENERATE | 2026-11-20: Reconstructed the ellipse, mean vectors, projections, braces and labels from the book image. Approved 1804×1640 render gives ~470 effective dpi at 70% width. |

## Ch. 11: MLM Review (`11-mlm-review.qmd`) — 4 images

| Done | Image | Pixels | Eff. DPI | Printed at | Px needed @300 | Max `out-width` @300 | Action | Notes |
|------|-------|--------|----------|------------|----------------|----------------------|--------|-------|
| [X] | [`manova-diagram-anno.png`](../../images/manova-diagram-anno.png) | 413×219 | 108 | 70% (3.8″) | 1151 px | 25% | REGENERATE | Added 2026-11-20: missed by the July audit (included via `here::here("images", ...)`). 2026-11-20: Reconstructed the three ellipses and mean positions from the bitmap and retained all four slide annotations. Approved 1652×876 render gives ~431 effective dpi at 70% width. |
| [X] | [`VisualizingSSP.png`](../../images/VisualizingSSP.png) | 830×311 | 152 | 100% (5.5″) | 1644 px | 50% | REPLACE | 2026-10-08: The plot panels in source `.pptx` are 480×480 rasters, so a straight `.pptx` -> `.pdf` -> `magick` pass would only upsample them. Instead: re-rendered the three panels at 2400×2400 from `R/mathscore/mathscore-SS.R` (scratch copy, only change `png(..., res = 72*5)` at 5× size); exported slide 2 of the `.pptx` -> `.pdf` (intermediate, not kept); used `magick` at `-density 250` to render it and composited the hi-res panels over the originals at their exact slide positions; cropped `.png` (now 2218×845, eff. 405 dpi). `.pptx` and R script unchanged. Thin `Between` ellipse differs very slightly (script uses unseeded `jitter()`). |
| [X] | [`manova-response-dimensions-anno.png`](../../images/manova-response-dimensions-anno.png) | 975×630 | 178 | 100% (5.5″) | 1644 px | 59% | REGENERATE | Added 2026-11-20: missed by the July audit (included via `here::here("images", ...)`). Regenerated both panels at 4× with the six ellipses, projections, group labels and red arrows. The approved render uses naturally proportioned lettering and matching Calibri numerals in the captions and subscripts. Now 3900×2520, ~712 effective dpi at full text width. |
| [X] | [`ANCOVA-ex.png`](../../images/ANCOVA-ex.png) | 1034×493 | 210 | 90% (4.9″) | 1480 px | 62% | REGENERATE | 2026-11-20: Re-rendered the seeded example from [R/ANCOVA-ex.R](../../R/ANCOVA-ex.R) at 3×, with point size adjusted from 3 to 2.4 in the render copy to match the original markers. Now 3102×1479, ~629 effective dpi at 90% width. |

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
- Recreated the table in Fig. 9.1 from the original screenshot, matching the SPSS layout and typography as closely as possible. Did not take a new SPSS screenshot.

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
- Resolved: **56** as of 2026-11-20 (**30 REPLACE**, **26 REGENERATE**). Added 2026-11-20:
  `duncan-av-influence.png`, `dual-points-lines.png`, `outlier-demo.png`,
  `pollen-eureka1`–`4.png`, the five `tours/` images, `crime-pvPlot-1-2.png`,
  `corrgram-renderings.png`, `proj-P2-vec.png`, `peng-colors.png` (REGENERATE), and
  `pca-animation-combined.jpg`, `mahalanobis.png`, `projection.png`, `pca-rotation.png`,
  `proj-combined.png`, `proj-vectors-labels.png`, `Pearson1901.png`, `pca4ds-figure-2-11.png`, `Pearson1901_2.png`, `image-compression-SVD.png`, `wheres-waldo.png` (REPLACE), and `mona-pca.png`, `pca-springs-frames.jpg`, `T2-diagram.png`, `manova-diagram-anno.png`, `ANCOVA-ex.png`, `manova-response-dimensions-anno.png`, `collinearity-diagnostics-SPSS.png` (REGENERATE).
- Unchecked: **13** (11 from the audit + 2 added).
- Resolved (SHRINK): **0**.
- Resolved (ACCEPT / flag to CRC): **0**.
