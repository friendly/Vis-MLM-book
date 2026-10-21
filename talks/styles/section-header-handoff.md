# Section-header visuals: handoff

Updated: 2026-10-20

## Files and scope

Working deck: `C:/R/Projects/Vis-MLM-book/talks/Vis-MLM-talk4.pptx`.
Original brief: `../section-headers.md`.
Keep all work for this task under `talks/`; this is not a HistData task. Images placed on header slides go in `talks/images/section-headers/`; design/handoff notes and the COM scripts in `talks/styles/`. Slide renders are not kept in the repo (they go stale as soon as the deck is edited): export them from the deck when needed, previews to the scratchpad. Renders and source images deleted on 2026-10-20 are in commit ca83f118 and earlier.

Do not modify the PowerPoint without approval for the specific change. Slide 5 was approved and updated twice: first on 2026-10-19 (pale solid background), then redesigned on 2026-10-20 (radial background, hearts; see below). Commit the user's own unsaved/uncommitted deck changes separately before applying an approved edit, so each edit is easy to undo.

**Slide numbers below are as of the work on each slide.** On 2026-10-20, after all of it, a new slide 19 ("Thinking about Penguin variables", `add-slide19-altviews.ps1`) was inserted, so every slide after 18 moved down one: the headers are now 5, 10, 24, 32, 45, 58, and the Closing slides 62-64.

## Design preferences established

Section headers must retain their role and existing typography, text positions, and hierarchy. Avoid replacing them with explanatory slides. The user explicitly wants to avoid an obviously AI-generated appearance. Existing illustrations tied to the actual following slides are useful sources.

Rejected for this section: an R-generated heart-shaped point cloud shown in three projections. It took over the layout, changed typography, used anonymous data, and the views were insufficiently distinct. Do not revisit this direction for slide 5. Its exploratory files were deleted 2026-10-19 (last version in commit 48e854c6).

## Approved slide 5

Title: "Why a romance in many dimensions?"

Uses Abbott's Flatland sphere illustration already present on slide 6, centered at the top; title and subtitle positions and fonts unchanged.

History: the 2026-10-19 version had a solid pale `#F2F3F6` background and the illustration faded by a 70%-transparent overlay. The user found it too light. On 2026-10-20 three previews were compared: (A) a vertical slate-to-light linear gradient, (B) a radial gradient, (C) B plus hearts. The user chose C, with the hearts moved up beside the title. The user also found the muted gray subtitle text too faint, on this and probably the other header slides.

Current design (points; slide is 960 x 540):

- Background: radial gradient, `TwoColorGradient(7, 1)` (msoGradientFromCenter): `#F2F3F6` at the center, `#8EA1C2` at the edges. The center is rectangular, not circular; the user accepted this.
- Illustration `Section 0 Flatland illustration`: left 135, top 10, width 690, height 210. Overlay deleted (full strength); 0.75 pt `#3A3A3A` frame; black shadow, blur 8, offset (2, 3), transparency 0.6.
- Subtitles (`Text Placeholder 2`): font color `#2F3B52` (dark slate) instead of the muted gray. Set on this slide directly, and since 2026-10-20 also the default for all header slides (see below).

## Section Header layout: subtitle color

All six header slides (5, 10, 23, 31, 44, 57) use the one "Section Header" layout of the deck's only master. Its subtitle placeholder was the theme text color at 82% tint (muted gray); on 2026-10-20 it was changed to `#2F3B52`, so slides 23, 31, 44 and 57 now get dark slate subtitles. Slide 5 sets `#2F3B52` itself and slide 10 sets black (`tx1`, over its photo), so neither changed. Applied by `section-header-subtitle-color.ps1` (a record, not to be re-run).
- Hearts `Romance heart 1`–`6`: msoShapeHeart, fill `#C8435A`, no line, height 0.9 x width. A trail rising to the upper right of the title, smaller and fainter as it goes, echoing the Sphere rising and vanishing in the drawing. (left, top, width, rotation, transparency): (690, 318, 32, -12, 0.05), (756, 296, 27, 8, 0.20), (813, 276, 22, -10, 0.35), (862, 258, 17, 12, 0.50), (900, 243, 13, -8, 0.65), (930, 232, 9, 10, 0.78).
- Applied by `slide5-header.ps1` (in this folder); a record and template, not to be re-run on the current deck.

Asset: `../images/section-headers/slide6-source-2.jpg`, the original Flatland illustration extracted from slide 6, reused without raster editing.

## Approved slide 23 (and slide 24 title)

Title: "Flatland and Spaceland: dimension reduction"; subtitle "PCA, biplots, and nonlinear methods". Applied 2026-10-20 by `section2-header.ps1` (a record, not to be re-run).

Same structure as slide 5, in the section's teal instead of slate (the teal of the "sec2" title boxes on slides 25-30, `#008080` at 78% transparency, 1.5 pt `#008080` border):

- Background: `FollowMasterBackground = 0` (needed: this slide followed the master, unlike slide 5), then radial `TwoColorGradient(7, 1)`, `#F2F6F6` center, `#8EC0C0` edges.
- Banner of three framed plates (same frame and shadow as slide 5), top 14, height 190, gaps 22, centered; left to right they follow the subtitle (rotate, juice, go nonlinear):
  - `Section 2 PCA illustration`, width 190: `../images/section-headers/section2-pca-original.png`, first frame of the slide 25 GIF (original data and its ellipse).
  - `Section 2 biplot illustration`, width 220: `../images/section-headers/section2-peng-biplot.png`, penguin biplot from slide 28.
  - `Section 2 t-SNE illustration`, width 380: `../images/section-headers/section2-pca-tsne.png`, PCA vs. t-SNE from slide 29.
- No motif beside the title (offered: the IN/OUT juicer drawing from slide 24; not used, so as not to pre-empt slide 24).

Slide 24 ("Multivariate Juicers", Blank layout): its title is a text box (`TextBox 9`), formerly white on dark navy `#0B3041`. Now in the sec2 colors: fill `#008080` at 0.78 transparency, 1.5 pt `#008080` line, black text. Still differs from slides 25-30 in square corners (COM cannot change a text box's shape type), position/size (70, 28, 830 x 65 vs. 48, 21.6, 864 x 61.2) and font (Aptos 48 pt vs. Aptos Display 36 pt); the user was offered an exact match (replace it with a copy of slide 25's title shape) and has not asked for it.

## Approved slide 31

Title: "Elliptical Insights"; a subtitle line and four bullets (outlier detection, measurement error, understanding collinearity, ridge regression). Applied 2026-10-20 by `section3-header.ps1` (a record, not to be re-run).

Same structure as slides 5 and 23, in the section's green (the "sec3" title boxes: `#267342` at 78% transparency, 1.5 pt border):

- Background: `FollowMasterBackground = 0`, then radial `TwoColorGradient(7, 1)`, `#F3F6F4` center, `#9DC0AA` edges.
- Banner of three framed plates (same frame and shadow), top 14, height 150 (shorter than slides 5/23: this slide's text starts higher, the visible title at about 196), gaps 22, centered; left to right they follow the bullets:
  - `Section 3 outlier illustration`, width 162: `../images/section-headers/section3-peng-biplot-dim34.png`, penguin biplot of dimensions 3-4 from slide 34 (outliers 283, 35, 10 labeled). Chosen by the user over the Waldo-space plot of slide 32.
  - `Section 3 measurement error illustration`, width 315: `../images/section-headers/section3-data-beta-space.png`, data space and beta space from slide 37.
  - `Section 3 ridge illustration`, width 365: `../images/section-headers/section3-ridge-ellipses.png`, the two generalized ridge trace plots from slide 42, cropped below the text above them (top 34.5% removed).
- `Section 3 Wally`: `../images/section-headers/section3-wally.wmf` (the Wally drawing used on slides 32, 34, 39), at left 500, top 196, 52 x 52, just after the title; white made transparent and a thin border line cropped off (2 pt left/top, 1 pt right/bottom). The user moved him here from the far right end of the title line.

## Approved slide 44

Title: "The HE plot framework"; subtitle "Seeing multivariate tests as ellipses" (the user may add more subtitle points; the subtitle placeholder spans 361-479 pt, below the banner, so two or three more lines fit before PowerPoint shrinks the text). Applied 2026-10-20 by `section4-header.ps1` (a record, not to be re-run).

Same structure as slides 5, 23 and 31, in the section's orange (the "sec4" title boxes: `#CC6600` at 78% transparency):

- Background: `FollowMasterBackground = 0`, then radial `TwoColorGradient(7, 1)`, `#F7F4F1` center, `#E4C09E` edges.
- Banner, the section's own "Data → Data ellipses → HE plot" storyline from slide 46, all penguins in bill length × bill depth; top 14, height 200 (this slide's text sits lower: visible title at about 295), gaps 50, centered:
  - `Section 4 data ellipses illustration`, width 189: `../images/peng-HE-overview-1-ellipses.png` (an existing talk figure).
  - `Section 4 HE plot illustration`, width 200: `../images/section-headers/section4-peng-HE-effect.png`, the left (effect scaling) half of `../images/peng-HE-signif.png`, as on slide 49.
  - `Section 4 canonical HE illustration`, width 250: `../images/peng-candisc-HE.png` (an existing talk figure; as on slide 53).
- `Section 4 arrow 1`, `2`: msoShapeRightArrow in the gaps, 30 x 22, fill `#CC6600`, no line, vertically centered on the plates; echo slide 46's red arrows. They take the place of the hearts and Wally as the slide's motif.

## Approved slide 57

Title: "Checking multivariate models"; subtitle "Outliers, influence and robust estimation". Applied 2026-10-20 by `section5-header.ps1` (a record, not to be re-run).

Same structure as the others, in the section's brick red (the "sec5" title boxes: `#A33B2B` at 78% transparency):

- Background: `FollowMasterBackground = 0`, then radial `TwoColorGradient(7, 1)`, `#F7F3F2` center, `#D5A79F` edges.
- Banner, one plate per word of the subtitle; top 14, height 200 (same text position as slide 44), gaps 22, centered:
  - `Section 5 distance plot illustration`, width 200: `../images/section-headers/section5-distance-plot.png`, school data distance plot from slide 58.
  - `Section 5 influence plot illustration`, width 200: `../images/section-headers/section5-influence-plot.png`, school data influence bubble plot from slide 58.
  - `Section 5 robust weights illustration`, width 280: `../images/section-headers/section5-robust-weights.png`, penguin robust-MLM weights from slide 60 (Cyrano 0, Hook Nose 0.13).
- No motif: the user declined both arrows (as on slide 44) and the mvinfluence/heplots hex logos. School data in two plates and penguins in one mirrors the section itself; the user accepted it.

## Closing section colors (slides 61-63)

Before 2026-10-20 the Closing slides shared section 5's brick red. Now gold, chosen by the user from three previews (A gold `#D4AF37`, B mustard `#B8860B`, too close to section 4's orange; C yellow `#E0C030`). Applied by `closing-colors.ps1` (a record, not to be re-run):

- Slides 61 (Summary) and 62 (Book, code and packages) moved to gold copies of their layouts, "Title and Content · sec6" and "Two Content · sec6" (duplicates of the sec5 ones): title box fill `#D4AF37` at 78% transparency, border `#D4AF37`, as for the other sections.
- Slides 61, 62 and 63 ("Questions? Discussion?", Section Header layout) have a solid very light gold background `#FDF9EF` (about 6% gold over white). Slide 63 has no radial background or banner, unlike the other headers.

## Title slide (slide 1)

Redesigned 2026-10-21 in the style of the section headers, but bright. Three previews: A azure (`#5DADE2` edges), B coral (`#F28C6B`), C gold. MF first chose B, then switched to C the same day; gold also bookends the talk with the Closing slides (a brighter gold than their `#D4AF37`). Applied by `title-slide.ps1` (a record, not to be re-run):

- Background: radial `TwoColorGradient(7, 1)`, `#FFFBEA` center, `#E8C547` edges (the slide already had its own background, so `FollowMasterBackground` was already 0).
- The three existing thumbnails ("Thumbnail: data ellipses", "Thumbnail: biplot", "Thumbnail: HE plot"; sizes unchanged) at top 25, 22 pt gaps, centered, with the slide 5 frame and shadow.
- The www icon (renamed "www icon", was "Picture 7") moved from top 464.7, where it covered "Group" on the venue line, to 488 on the URL line, with its white made transparent (`TransparentBackground`); the white "WWW" letters inside the globe show the background too.

## Remaining section headers

The brief's slide numbers have shifted. Current main-talk headers as inspected in this session:

| Slide | Current title | Content to guide the visual |
|---|---|---|
| 10 | Seeing multivariate data | Existing penguin-and-ellipse artwork, created previously by the user |
| 23 | Flatland and Spaceland: dimension reduction | PCA, biplots, nonlinear methods; the brief calls this section Multivariate juicers |
| 31 | Elliptical Insights | Outliers, measurement error, collinearity, ridge regression; brief says slide 30 |
| 44 | The HE plot framework | Seeing multivariate tests as ellipses; brief says slide 40 |
| 57 | Checking multivariate models | Outliers, influence, robust estimation |

All done as of 2026-10-20: slides 5, 23 (and slide 24's title), 31, 44 and 57; slide 10 is the user's own design. Not done: slide 63 ("Questions? Discussion?") and the hidden backup header slide 67 also use the Section Header layout but were not part of this task. Work one section at a time, inspect actual slide content rather than relying on the brief's shorthand titles, show a preview, and obtain approval before updating the deck.

## Technical workflow

PowerPoint COM works from Claude Code's PowerShell tool (`New-Object -ComObject PowerPoint.Application`). For previews, open the deck read-only (`Presentations.Open($deck, $true, $false, $false)`), make the changes in memory, `Slide.Export(..., "PNG", 1920, 1080)` to the scratchpad, and close without saving; the real deck is untouched. For an approved edit, open it writable, make the same changes, `Save()`, export a render to the scratchpad to check it, and close. PowerPoint must be closed first (check for a `~$Vis-MLM-talk4.pptx` lock file).

COM colors are BGR integers: R + 256 G + 65536 B. Some slides (e.g. 10) use theme colors, which python-pptx cannot report as RGB; export a render to see them.
