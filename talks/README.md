# talks/

Slide decks for talks based on the book.

## Utrecht, 5 November 2026

**Title:** Visualizing Multivariate Data and Models in R: A Romance in Many Dimensions

**Slot:** 45 minutes + discussion

| File | What it is |
|---|---|
| `Vis-MLM-talk3.pptx` | The deck: 88 slides, 16:9. **This is the working copy; edit it directly in PowerPoint.** Started on 2026-10-11 from `Vis-MLM-talk2.pptx`, re-arranged into a thematic arc rather than chapter order, with some slides brought in from the CARME 2023 talk. Hidden slides at the end are backup. |
| `Vis-MLM-talk2.pptx` | The previous version (74 slides, in chapter order), kept for comparison. |
| `outline.md` | Topics, the organizer's seven requested figures (with file names), and rough timing |
| `build-talk.py` | Generator for the *initial* draft. It no longer matches the deck (hand edits, plus the "R packages" slide added later). Don't run it with `--force`; use `-o other.pptx` if a fresh copy is ever wanted. Needs `pip install python-pptx Pillow`. |
| `base-16x9.pptx` | Empty 16:9 file with the standard Office layouts, used by the generator |
| `slide-fixes.md` | Checklist of figures that need fixing, from a slide-by-slide review on 2026-10-06. Its slide numbers, and those in the notes below, refer to the original 70-slide `Vis-MLM-talk.pptx`, since deleted (the last version is in the git history). |
| `images/` | Figures not in the book, or re-drawn for the talk. Two older ones have their script alongside (`prestige-allEffects.R`, `peng-simpsons-split.py`). |
| `R/` | R scripts that draw the talk-only figures in `images/` (run from the project root). `peng-talk-figs.R` and `peng-HE-overview.R` re-draw the CARME penguin figures in the book's penguin colors. `peng-HE-plots.R` draws the penguin HE plots that replace the iris examples (Figs 12.5, 12.7, 12.8). |

## Status (2026-10-06)

First full draft, including all optional sections. Slides that are optional for a 45-minute talk have speaker notes starting `[OPTIONAL for a 45-minute talk]`; nothing is hidden yet. Slide 3, "R packages" (Theory → Practice: Making tools accessible), was added after the first draft.

## Next steps

- **Cut to length.** Hiding all 24 optional slides still leaves about 45, which is too many for 45 minutes. Decide which sections to keep. Figure 9.13 (bivariate ridge traces), one of the organizer's requests, is in the optional ridge section.

- **Layout and style.** The deck is deliberately plain. Titles and bullets sit in the layout placeholders, so page background, fonts, colors and bullet style can be set once in View > Slide Master. The only style change so far is smaller text on the master (36 pt titles, 24 pt body).

- **Read the slide text.** Bullets, takeaway lines and speaker notes were drafted from the figure captions and chapter text; check them for accuracy and voice.

- **Check the animations** [DONE] in slide show mode: pollen "EUREKA", the grand tour, PCA by springs (Fig 5.5), and PCA to t-SNE (Fig 5.26). The pollen GIF has toolbar icons baked into its frames.

- **Cover image.** The "The book" and closing slides (2 and 69) now show `images/cover/cover-peng.jpg`, uncropped. It still carries the older title ("Visualization of ..."), and is only 638 x 878 px; swap in a current cover when there is one.

- **Figures to revisit:**
  - DONE: the effect-display slide (32, Fig 7.17) now uses `images/prestige-allEffects.png`, re-drawn by `images/prestige-allEffects.R` with the three plots in one row.
  
  - The biplot slide uses the basic crime biplot (Fig 5.13), because the enhanced one (Fig 5.14, `figs/ch05/fig-crime-biplot2-1.png`) has its legend clipped in the image file. That probably affects the book figure too.
  - The Duncan added-variable image (Fig 7.27, `images/duncan-av-influence.png`) is only 1300 x 650 px and may look soft when projected.

- **Closing slide** "Book, code and packages" still lists the four packages now shown on slide 3; trim it.

- **Title slide** says only "Utrecht, 5 November 2026"; add the venue or host.
