# Figures to fix in Vis-MLM-talk.pptx

Review of 2026-10-06. All 70 slides were exported from PowerPoint at 1280 x 720 and inspected, and each picture's resolution was measured at the size it is shown on the slide. Animations were judged from their first frame only.

Slide numbers are those of the deck on that date. "(opt)" marks slides whose notes start `[OPTIONAL for a 45-minute talk]`. "Organizer" marks the seven figures the organizer asked for.

Suggested order: the three organizer figures in section 1 (slides 42, 46, 52), then the three low-resolution diagrams on core slides (47, 20, 45). Most of the label problems in section 3 are on optional slides, so they can wait until the deck is cut to length.

## Already done

- [x] Slides 2, 69: cover image is now `images/cover/cover-peng.jpg` (still carries the older title, "Visualization of ...", and is only 638 x 878 px).
- [x] Slide 32, Fig 7.17 effect displays: re-drawn as three plots in one row, `talks/images/prestige-allEffects.png` from `talks/images/prestige-allEffects.R`.

## 1. Too small on the slide

Slides 42 and 46 were re-laid out on 2026-10-06: figure at the left at full height (5.7 in), takeaway line at the right in 24 pt, figure-number tag removed. The same pattern can be used for the others.

Slide 64 was given the same layout, and the figures on slides 65-67 were enlarged by about 20% (65, 67: 10.3 x 5.2 in with the takeaway line underneath; 66: a 5.7-inch square), with the figure-number tags removed. The label problems on slides 65-67 listed in section 3 remain.

The image file is fine; only the layout needs changing (e.g., drop the bullets or the takeaway line and give the figure the full slide height).

- [x] **Slide 42 (opt), Fig 9.13 bivariate ridge traces** -- Organizer. `figs/ch09/fig-longley-pairs-1.png`. Shown as a 4.3-inch square; the panels are unreadable. Needs the full slide height.
- [x] **Slide 46, Fig 10.9 HE framework** -- Organizer. `images/HE-framework.png`. Shown 6 inches wide with tiny inner text; also only 163 dpi at that size (971 x 700 px).
- [ ] **Slide 52, Fig 12.17 school HE plot** -- Organizer. `figs/ch12/fig-school-heplot1-1.png`. Squeezed beside four bullets; the predictor labels are small.
- [ ] **Slide 14, Fig 4.31 penguin scatterplot matrix** -- `figs/ch04/fig-peng-spm-1.png`. A 4.8-inch square beside bullets; axis text is illegible.
- [ ] **Slide 29, Fig 7.2 regression quartet** -- `figs/ch07/fig-duncan-plot-model-1.png`. Four panels in a 5.7-inch box; point labels and axes are tiny.
- [ ] **Slide 50, Fig 12.8 HE plot matrix** -- `figs/ch12/fig-iris-pairs-1.png`. Same problem as slide 14.
- [ ] **Slide 61 (opt), Fig 13.4 covariance ellipses** -- `figs/ch13/fig-peng-covEllipse-pairs-1.png`. Same problem as slide 14.
- [ ] **Slide 58, Figs 14.2, 14.3 Case 9** -- `figs/ch14/fig-toy-inflplots-1.png`, `figs/ch14/fig-toy-inflplot-mlm-stres-1.png`. The left pair is much smaller than the right plot, so the contrast the slide is about is lopsided.
- [ ] **Slide 26 (opt), Fig 5.33 Mona Lisa** -- `images/mona-pca.png`. Only 3 inches wide.

## 2. Low resolution

These will look soft when projected. Effective dpi is the image's pixel width divided by its width on the slide.

| Done | Slide | Figure | File | Pixels | Effective dpi |
|---|---|---|---|---|---|
| [ ] | 47 | 11.2 SSP decomposition | `images/VisualizingSSP.png` | 830 x 311 | 72 |
| [ ] | 20 | 5.6 PCA as rotation | `images/pca-rotation.png` | 884 x 357 | 83 |
| [ ] | 45 | 10.1 T² diagram | `images/T2-diagram.png` | 451 x 410 | 85 |
| [ ] | 34 | 7.27 Duncan added-variable plots (Organizer) | `images/duncan-av-influence.png` | 1300 x 650 | 151 |
| [ ] | 4 | Book-parts strip | `figs/fig-book-parts-1.png` | 1307 x 145 | 138 |
| [ ] | 21 | 5.5 PCA by springs (Organizer) | `images/pca-springs-cropped.gif` | 412 x 364 | 85 |
| [ ] | 17 | 4.48 grand tour | `images/tours/peng-tourr-grand.gif` | 480 x 480 | 112 |
| [ ] | 24 | 5.26 PCA to t-SNE (Organizer) | `images/diabetes-pca-tsne.gif` | 480 x 480 | 112 |
| [ ] | 7 | 1.5 pollen EUREKA | `images/pollen-eureka.gif` | 538 x 492 | 114 |

- The first three are diagrams, so they need a higher-resolution export from their source.
- The GIFs would have to be re-rendered at a larger size to improve.
- The tour on slide 17 also has its variable labels piled up at the centre.

## 3. Overlapping or unreadable labels inside the figure

These need re-drawing in R. Re-drawn versions for the talk go in `talks/images/`, each with its script.

- [ ] **Slide 51, Fig 12.10 iris canonical HE plot** -- `figs/ch12/fig-iris-HEcan-1.png`. The Sepal.Length, Petal.Width and Petal.Length labels sit on top of each other, and the plot is a thin strip with a lot of empty space.
- [ ] **Slide 55 (opt), Fig 12.25 Rohwer MANCOVA** -- `figs/ch12/fig-rohwer-HE-lohi-1.png`. The predictor labels and the two "Error" labels collide; it is not possible to read which line is which.
- [ ] **Slide 53 (opt), Fig 12.22 school canonical HE plot** -- `figs/ch12/fig-school-hecan-1.png`. The selfesteem, mathematics and reading labels overlap and are tiny.
- [ ] **Slide 22, Fig 5.13 crime biplot** -- `figs/ch05/fig-crime-biplot1-1.png`. The robbery, burglary, larceny and auto labels overlap, and the states are unlabelled, so the "points are states" bullet has nothing to point at. (The enhanced biplot, Fig 5.14, `figs/ch05/fig-crime-biplot2-1.png`, has its legend clipped in the image file.)
- [ ] **Slide 49 (opt), Fig 12.7 iris contrasts** -- `figs/ch12/fig-iris-contrasts-1.png`. virginica and versicolor overlap, and the contrast labels ("V:v", "S:Vv") are cryptic at this size.
- [ ] **Slide 66 (opt), Fig 15.9 discriminant biplot** -- `figs/discrim/fig-peng-LD-biplot-1.png`. The body mass and flipper length labels overlap at the origin.
- [ ] **Slide 41 (opt), Fig 9.10 ridge trace** -- `figs/ch09/fig-longley-traceplot1-1.png`. The GNP.deflator, Population and Armed.Forces labels overlap at the left.
- [ ] **Slide 43 (opt), Fig 9.18 ridge biplot** -- `figs/ch09/fig-longley-pca-biplot-1.png`. The Armed.Forces and Unemployed labels run into the shrinkage values.
- [ ] **Slide 65 (opt), Fig 15.6 prediction regions** -- `figs/discrim/fig-peng-regions-1.png`. In the right panel the Adelie label is hidden behind Chinstrap.
- [ ] **Slide 67 (opt), Fig 15.12 QDA regions** -- `figs/discrim/fig-peng-qda-regions-1.png`. Same hidden Adelie label.

Several of these are in the book's own image files, so they affect the book as well: slides 22, 41, 43, 49, 51, 53, 55 and 66.

## 4. Other

- [ ] **Slide 7, pollen GIF** -- toolbar icons are baked into the frames.
- [ ] **Slide 33, Fig 7.26 influence plot** -- `figs/ch07/fig-duncan-infl-1.png`. The "minister" bubble is cut off by the top of the plot frame.
- [ ] **Slides 23 and 39 (opt)** -- the takeaway line wraps to two lines and runs into the "Figure" tag.
- [ ] **Slide 32** -- the three 95% bands in the income x type panel overlap heavily; the chapter uses 68% bands for that plot. The slide still carries the "Figure 7.17" tag although the figure now differs from the book's.
