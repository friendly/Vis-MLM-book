# Vis-MLM-talk4: where things stand

Status of `Vis-MLM-talk4.pptx` as of 2026-10-17, after the hidden slides were moved to the backup section.
Slide numbers updated 2026-10-20, after MF deleted four backup slides and the new slide 19 ("Thinking about
Penguin variables") moved every later slide down one.
This file replaces `outline.md` as the working summary. `outline.md` is the plan written before there were
any slides; keep it for the organizer's figure list and the original timing, but the deck has moved on.

**Talk:** Methodology & Statistics Group, Utrecht, 6 November 2026. 45 minutes + discussion.

## Deck at a glance

81 slides; **64 visible**. Slides 1-64 are the talk, all visible; 65-81 are hidden backup.

| Section | Slides | Visible |
|---|---|---|
| Introduction | 1-4 | 4 |
| Why a romance in many dimensions? | 5-9 | 5 |
| 1. Ellipses everywhere: seeing multivariate data | 10-23 | 14 |
| 2. Multivariate juicers and Waldo space | 24-31 | 8 |
| 3. Elliptical insights | 32-44 | 13 |
| 4. The HE plot framework | 45-57 | 13 |
| 5. Checking multivariate models | 58-61 | 4 |
| Closing | 62-64 | 3 |
| Backup (hidden) | 65-81 | 0 |

At 1.5-2 minutes a slide, 64 slides is still too many for 45 minutes; something like 35-45 is realistic,
given that several are quick (section dividers, animations, the title and closing slides).

## The story line

The talk is thematic rather than in chapter order. Slide 4 shows both views: the thematic outline of the talk
and the linear road map of the book.

1. **Why many dimensions** (5-9): Flatland, structure hiding in many dimensions, the diabetes discovery,
   and the MLM problem (easy to fit, hard to see).
2. **Ellipses everywhere** (10-23): Galton → data ellipse → penguins → non-normal alternatives (bagplot,
   HDR, slide 17) → Simpson's paradox → bill size & shape (slide 19) → scatterplot matrices, effect ordering, parallel coordinates, tours.
3. **Juicers and Waldo space** (24-31): PCA as rotation and by springs, biplots ("the data juicer"),
   PCA vs. t-SNE.
4. **Elliptical insights** (32-44): outliers (Waar is Wally?, the penguin outliers Cyrano and Hook Nose,
   the smallest dimensions); measurement error with the coffee/stress data (data space and β space);
   collinearity (Waldo space again) and ridge regression.
5. **HE plots** (45-57): data ellipses → H and E ellipses → effect vs. significance scaling → contrasts →
   HE pairs plots → quantitative predictors → canonical discriminant plots ("the MANOVA juicer") → LDA
   prediction regions.
6. **Checking multivariate models** (58-61): school data distance and influence plots; influential and
   down-weighted penguins (Cyrano and Hook Nose return).

Threads that run across sections: the **ellipse**; the **juicer** (slide 25 → 29 → 54); **Waldo space**
(the smallest dimensions: 26, 33, 35, 40, 44); **Cyrano and Hook Nose** (34, 35 → 60, 61).

## Changes in this round (2026-10-15/17)

- Juicer slides moved up to section 2, so the juicer idea comes before "the MANOVA juicer".
- Section 3 reordered: Waar is Wally → penguin outliers → outliers in the smallest dimensions.
- New slide 17, "What if I'm not Normal?": `gggda::geom_bagplot()` (Fig 4.21) beside the
  `ggdensity::geom_hdr()` panel of Fig 4.22 (cropped from `figs/ch04/fig-peng-ggdensity-1.png`;
  the cropped file is embedded in the deck only).
- Slide 10 background now `talks/images/penguin-scene-ellipses.png`.
- Slide 32 lists the section's topics: outliers, measurement error, collinearity, ridge regression.
- "Quantitative predictors: each effect is a line" (school HE plot, now 53) unhidden.
- 2026-10-17: all hidden slides moved to the backup section: "Measurement error for β1 also biases β2"
  (now 71), the AV-plot and Duncan influence slides (now 72-74), "From the t-test to Hotelling's T²" and
  "The Hypothesis-Error plot framework" (both deleted 2026-10-20, see below) and "MANOVA: the same sums of
  squares" (now 75). Deleted earlier: Mona Lisa and Mysterious Case 9 backup slides.
- 2026-10-20: MF deleted four backup slides: "Bias vs. Precision tradeoff", "From the t-test to
  Hotelling's T²", "The Hypothesis-Error plot framework" (Fig 10.9) and "Discriminant analysis" (the last
  versions are in the git history). New slide 19, "Thinking about Penguin variables": length & depth vs.
  size & shape, from the blog post. Section headers redesigned; Closing slides in gold.

## Open gaps

1. **Section 5 has no univariate lead-in.** With the Duncan influence plot (backup 73) hidden, leverage,
   residuals and Cook's D appear for the first time in their multivariate form on slide 59. A sentence in
   slide 59's notes would cover it, or bring the Duncan plot back.
   **MF:** I'll leave this as is, and add a sentence in slide 59

2. **The HE section shows only MANOVA.** Resolved for now: slide 53 (school HE plot, a quantitative
   predictor) is visible again, so slide 59 no longer introduces the school data from scratch.
   **MF:** I'll unhide that slide for now, but that will be a quick one

3. **Length.** Remaining cut candidates:
   - Section 3, measurement error (36-39): drop slide 36 (text only); or drop the whole strand.
     **Done 2026-10-16:** "Measurement error for β1 also biases β2" merged into 39 and moved to backup (71).
     Slide 39 now shows all three GIFs in a row (data space, β space for Heart ~ Stress, and the
     (βCoffee, βStress) space), with a third bullet on βCoffee moving toward its marginal value; the merged
     slide's text went into 39's speaker notes.
   - Section 3, ridge: drop 41 and 42; slide 43's opening line already sets up the contrast with the
     usual ridge trace.
   - Section 4: 55-57 (LDA, both prediction-region slides) are flagged optional; 54 already makes the
     main point.
   - Slide 33 (Waar is Wally) repeats the demo on slide 26 (same points 101, 102). If cut, move the
     "I call this Waldo space" line into slide 26's notes.

## Organizer's seven figures

| Figure | Slide | Status |
|---|---|---|
| 5.5 PCA by springs | 27 | visible |
| 5.26 PCA → t-SNE animation | 31 | visible |
| 7.27 Duncan AV plots | 74 | **backup** |
| 9.13 bivariate ridge traces | 43 | two of its panels shown, not the full matrix |
| 10.9 HE framework | - | **deleted** 2026-10-20 (was backup "The Hypothesis-Error plot framework"; in the git history) |
| 11.18 school distance plot | 59 | visible |
| 12.17 school HE plot | 53 | visible |

## Smaller to-dos

- **Section-header designs**: DONE 2026-10-20. Slides 5, 24, 32, 45, 58 each have a radial background
  in their section's color and a banner of framed figures from the section (slide 10 is MF's own);
  slide 25's title box is in the section teal; the Section Header layout's subtitles are dark slate.
  Closing slides 62-64 are gold. Details, colors and geometry: `styles/section-header-handoff.md`.
  Not done: the hidden backup header 68, which uses the same layout.
- **Speaker notes missing** on visible slides 24, 29, 32, 37, 43, 45, 52, 54, 58, 64, and the new 19.
  Slide 43 (generalized ridge trace plots) is the one most worth writing.
- **Still flagged `[OPTIONAL for a 45-minute talk]`** in the notes of visible slides 35, 38, 41, 42, 44,
  51, 55, 56, 57. Remove the flag on the ones that are staying.
- Slide 17 has no takeaway line under the figures (slides 15 and 18 do).
- Slide 19 needs its reveal animation (MF, in PowerPoint): `Size shape plot` and `Reveal text` on one click.
- Backup slide 74 ("Which observations drive the fit?") has a stray "." text box (matters only if it comes back).
- From the README: the cover image on slides 2 and 63 still has the old title; the title slide could
  name the host.
- `slide-fixes.md` lists figure problems by the slide numbers of the original 70-slide deck; many are
  done or no longer in the talk.

## Working notes

- Slide previews: PowerPoint exports slides as images through COM, which closes PowerPoint when it
  finishes. Only do it while the deck is closed. LibreOffice is not installed and is not needed.
- `build-talk.py` generated the first draft only; don't re-run it on this deck.
