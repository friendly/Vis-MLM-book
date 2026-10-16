# Vis-MLM-talk4: where things stand

Status of `Vis-MLM-talk4.pptx` as of 2026-10-16 (commit `38ce60b4`). This file replaces
`outline.md` as the working summary. `outline.md` is the plan written before there were any slides; keep it for
the organizer's figure list and the original timing, but the deck has moved on.

**Talk:** Methodology & Statistics Group, Utrecht, 5 November 2026. 45 minutes + discussion.

## Deck at a glance

84 slides; **63 visible**. Slides 1-70 are the talk, 71-84 are hidden backup.

| Section | Slides | Visible | Hidden in the main flow |
|---|---|---|---|
| Introduction | 1-4 | 4 | |
| Why a romance in many dimensions? | 5-9 | 5 | |
| 1. Ellipses everywhere: seeing multivariate data | 10-22 | 13 | |
| 2. Multivariate juicers and Waldo space | 23-30 | 8 | |
| 3. Elliptical insights | 31-47 | 14 | 40-42 (AV plots, Duncan influence) |
| 4. The HE plot framework | 48-63 | 12 | 49 (T²), 54 (HE framework), 55 (SSP), 59 (school HE plot) |
| 5. Checking multivariate models | 64-67 | 4 | |
| Closing | 68-70 | 3 | |
| Backup (hidden) | 71-84 | 0 | all |

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
4. **Elliptical insights** (31-47): outliers (Waar is Wally?, the penguin outliers Cyrano and Hook Nose,
   the smallest dimensions); measurement error with the coffee/stress data (data space and β space);
   collinearity (Waldo space again) and ridge regression.
5. **HE plots** (48-63): data ellipses → H and E ellipses → effect vs. significance scaling → contrasts →
   HE pairs plots → canonical discriminant plots ("the MANOVA juicer") → LDA prediction regions.
6. **Checking multivariate models** (64-67): school data distance and influence plots; influential and
   down-weighted penguins (Cyrano and Hook Nose return).

Threads that run across sections: the **ellipse**; the **juicer** (slide 23 → 27 → 60); **Waldo space**
(the smallest dimensions: 24, 32, 34, 43, 47); **Cyrano and Hook Nose** (33, 34 → 66, 67).

## Changes in this round (2026-10-15/16)

- Juicer slides moved up to section 2, so the juicer idea comes before "the MANOVA juicer".
- Section 3 reordered: Waar is Wally → penguin outliers → outliers in the smallest dimensions.
- New slide 17, "What if I'm not Normal?": `gggda::geom_bagplot()` (Fig 4.21) beside the
  `ggdensity::geom_hdr()` panel of Fig 4.22 (cropped from `figs/ch04/fig-peng-ggdensity-1.png`;
  the cropped file is embedded in the deck only).
- Slide 10 background now `talks/images/penguin-scene-ellipses.png`.
- Slide 31 lists the section's topics: outliers, measurement error, collinearity, ridge regression.
- Hidden: 40-42 (to move to backup), 54, 59. Deleted: Mona Lisa and Mysterious Case 9 backup slides.

## Open gaps

1. **Section 5 has no univariate lead-in.** With the Duncan influence plot (41) hidden, leverage, residuals
   and Cook's D appear for the first time in their multivariate form on slide 65. A sentence in slide 65's
   notes would cover it, or bring the Duncan plot back.
   **MF:** I'll leave this as is, and add a sentence in slide 65
   
2. **The HE section shows only MANOVA.** With slide 59 hidden, no visible HE plot has a quantitative predictor,
   and slide 65 then introduces the school data (multivariate regression) from scratch. Slide 4 promises
   "the HE plot framework for multivariate models."
   **MF:** I'll unhide slide 59 for now, but that will be a quick one
   .
3. **Length.** Remaining cut candidates:
   - Section 3, measurement error (35-39): drop slide 35 (text only); or drop the whole strand.
     **Done 2026-10-16:** 39 merged into 38 and hidden. Slide 38 now shows all three GIFs in a row
     (data space, β space for Heart ~ Stress, and slide 39's (βCoffee, βStress) space), with a third
     bullet on βCoffee moving toward its marginal value; 39's text went into 38's speaker notes.
   - Section 3, ridge: drop 44 and 45; slide 46's opening line already sets up the contrast with the
     usual ridge trace.
   - Section 4: 61-63 (LDA, both prediction-region slides) are flagged optional; 60 already makes the
     main point.
   - Slide 32 (Waar is Wally) repeats the demo on slide 24 (same points 101, 102). If cut, move the
     "I call this Waldo space" line into slide 24's notes.

## Organizer's seven figures

| Figure | Slide | Status |
|---|---|---|
| 5.5 PCA by springs | 26 | visible |
| 5.26 PCA → t-SNE animation | 30 | visible |
| 7.27 Duncan AV plots | 42 | **hidden** |
| 9.13 bivariate ridge traces | 46 | two of its panels shown, not the full matrix |
| 10.9 HE framework | 54 | **hidden** |
| 11.18 school distance plot | 65 | visible |
| 12.17 school HE plot | 59 | **hidden** |

## Smaller to-dos

- **Speaker notes missing** on visible slides 17, 23, 28, 31, 36, 46, 48, 58, 60, 64, 70
  (38 now has notes; 39 is hidden).
  Slide 46 (generalized ridge trace plots) is the one most worth writing.
- **Still flagged `[OPTIONAL for a 45-minute talk]`** in the notes of visible slides 21, 34, 37, 44,
  45, 47, 57, 61, 62, 63. Remove the flag on the ones that are staying.
- Slide 57 title: "What diffces make H big?"
- Slide 17 has no takeaway line under the figures (slides 15 and 18 do).
- Hidden slide 42 has a stray "." text box (matters only if it comes back).
- From the README: the cover image on slides 2 and 69 still has the old title; the title slide could
  name the host.
- `slide-fixes.md` lists figure problems by the slide numbers of the original 70-slide deck; many are
  done or no longer in the talk.

## Working notes

- Slide previews: PowerPoint exports slides as images through COM, which closes PowerPoint when it
  finishes. Only do it while the deck is closed. LibreOffice is not installed and is not needed.
- `build-talk.py` generated the first draft only; don't re-run it on this deck.
