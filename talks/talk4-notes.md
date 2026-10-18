# Vis-MLM-talk4: where things stand

Status of `Vis-MLM-talk4.pptx` as of 2026-10-17, after the hidden slides were moved to the backup section.
This file replaces `outline.md` as the working summary. `outline.md` is the plan written before there were
any slides; keep it for the organizer's figure list and the original timing, but the deck has moved on.

**Talk:** Methodology & Statistics Group, Utrecht, 6 November 2026. 45 minutes + discussion.

## Deck at a glance

84 slides; **63 visible**. Slides 1-63 are the talk, all visible; 64-84 are hidden backup.

| Section | Slides | Visible |
|---|---|---|
| Introduction | 1-4 | 4 |
| Why a romance in many dimensions? | 5-9 | 5 |
| 1. Ellipses everywhere: seeing multivariate data | 10-22 | 13 |
| 2. Multivariate juicers and Waldo space | 23-30 | 8 |
| 3. Elliptical insights | 31-43 | 13 |
| 4. The HE plot framework | 44-56 | 13 |
| 5. Checking multivariate models | 57-60 | 4 |
| Closing | 61-63 | 3 |
| Backup (hidden) | 64-84 | 0 |

At 1.5-2 minutes a slide, 63 slides is still too many for 45 minutes; something like 35-45 is realistic,
given that several are quick (section dividers, animations, the title and closing slides).

## The story line

The talk is thematic rather than in chapter order. Slide 4 shows both views: the thematic outline of the talk
and the linear road map of the book.

1. **Why many dimensions** (5-9): Flatland, structure hiding in many dimensions, the diabetes discovery,
   and the MLM problem (easy to fit, hard to see).
2. **Ellipses everywhere** (10-22): Galton → data ellipse → penguins → non-normal alternatives (bagplot,
   HDR, slide 17) → Simpson's paradox → scatterplot matrices, effect ordering, parallel coordinates, tours.
3. **Juicers and Waldo space** (23-30): PCA as rotation and by springs, biplots ("the data juicer"),
   PCA vs. t-SNE.
4. **Elliptical insights** (31-43): outliers (Waar is Wally?, the penguin outliers Cyrano and Hook Nose,
   the smallest dimensions); measurement error with the coffee/stress data (data space and β space);
   collinearity (Waldo space again) and ridge regression.
5. **HE plots** (44-56): data ellipses → H and E ellipses → effect vs. significance scaling → contrasts →
   HE pairs plots → quantitative predictors → canonical discriminant plots ("the MANOVA juicer") → LDA
   prediction regions.
6. **Checking multivariate models** (57-60): school data distance and influence plots; influential and
   down-weighted penguins (Cyrano and Hook Nose return).

Threads that run across sections: the **ellipse**; the **juicer** (slide 24 → 28 → 53); **Waldo space**
(the smallest dimensions: 25, 32, 34, 39, 43); **Cyrano and Hook Nose** (33, 34 → 59, 60).

## Changes in this round (2026-10-15/17)

- Juicer slides moved up to section 2, so the juicer idea comes before "the MANOVA juicer".
- Section 3 reordered: Waar is Wally → penguin outliers → outliers in the smallest dimensions.
- New slide 17, "What if I'm not Normal?": `gggda::geom_bagplot()` (Fig 4.21) beside the
  `ggdensity::geom_hdr()` panel of Fig 4.22 (cropped from `figs/ch04/fig-peng-ggdensity-1.png`;
  the cropped file is embedded in the deck only).
- Slide 10 background now `talks/images/penguin-scene-ellipses.png`.
- Slide 31 lists the section's topics: outliers, measurement error, collinearity, ridge regression.
- "Quantitative predictors: each effect is a line" (school HE plot, now 52) unhidden.
- 2026-10-17: all hidden slides moved to the backup section: "Measurement error for β1 also biases β2"
  (now 70), the AV-plot and Duncan influence slides (71-73), "From the t-test to Hotelling's T²" (75),
  "The Hypothesis-Error plot framework" (76) and "MANOVA: the same sums of squares" (77).
  Deleted earlier: Mona Lisa and Mysterious Case 9 backup slides.

## Open gaps

1. **Section 5 has no univariate lead-in.** With the Duncan influence plot (backup 72) hidden, leverage,
   residuals and Cook's D appear for the first time in their multivariate form on slide 58. A sentence in
   slide 58's notes would cover it, or bring the Duncan plot back.
   **MF:** I'll leave this as is, and add a sentence in slide 58

2. **The HE section shows only MANOVA.** Resolved for now: slide 52 (school HE plot, a quantitative
   predictor) is visible again, so slide 58 no longer introduces the school data from scratch.
   **MF:** I'll unhide that slide for now, but that will be a quick one

3. **Length.** Remaining cut candidates:
   - Section 3, measurement error (35-38): drop slide 35 (text only); or drop the whole strand.
     **Done 2026-10-16:** "Measurement error for β1 also biases β2" merged into 38 and moved to backup (70).
     Slide 38 now shows all three GIFs in a row (data space, β space for Heart ~ Stress, and the
     (βCoffee, βStress) space), with a third bullet on βCoffee moving toward its marginal value; the merged
     slide's text went into 38's speaker notes.
   - Section 3, ridge: drop 40 and 41; slide 42's opening line already sets up the contrast with the
     usual ridge trace.
   - Section 4: 54-56 (LDA, both prediction-region slides) are flagged optional; 53 already makes the
     main point.
   - Slide 32 (Waar is Wally) repeats the demo on slide 25 (same points 101, 102). If cut, move the
     "I call this Waldo space" line into slide 25's notes.

## Organizer's seven figures

| Figure | Slide | Status |
|---|---|---|
| 5.5 PCA by springs | 26 | visible |
| 5.26 PCA → t-SNE animation | 30 | visible |
| 7.27 Duncan AV plots | 73 | **backup** |
| 9.13 bivariate ridge traces | 42 | two of its panels shown, not the full matrix |
| 10.9 HE framework | 76 | **backup** |
| 11.18 school distance plot | 58 | visible |
| 12.17 school HE plot | 52 | visible |

## Smaller to-dos

- **Speaker notes missing** on visible slides 23, 28, 31, 36, 42, 44, 51, 53, 57, 63.
  Slide 42 (generalized ridge trace plots) is the one most worth writing.
- **Still flagged `[OPTIONAL for a 45-minute talk]`** in the notes of visible slides 34, 37, 40, 41, 43,
  50, 54, 55, 56. Remove the flag on the ones that are staying.
- Slide 17 has no takeaway line under the figures (slides 15 and 18 do).
- Backup slide 73 ("Which observations drive the fit?") has a stray "." text box (matters only if it comes back).
- From the README: the cover image on slides 2 and 62 still has the old title; the title slide could
  name the host.
- `slide-fixes.md` lists figure problems by the slide numbers of the original 70-slide deck; many are
  done or no longer in the talk.

## Working notes

- Slide previews: PowerPoint exports slides as images through COM, which closes PowerPoint when it
  finishes. Only do it while the deck is closed. LibreOffice is not installed and is not needed.
- `build-talk.py` generated the first draft only; don't re-run it on this deck.
