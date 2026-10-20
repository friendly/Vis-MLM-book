# Section-header visuals: handoff

Updated: 2026-10-20

## Files and scope

Working deck: `C:/R/Projects/Vis-MLM-book/talks/Vis-MLM-talk4.pptx`.
Original brief: `../section-headers.md`.
Keep all work for this task under `talks/`; this is not a HistData task. Generated assets belong in `talks/images/`, and design/handoff notes in `talks/styles/`.

Do not modify the PowerPoint without approval for the specific change. Slide 5 was approved and updated twice: first on 2026-10-19 (pale solid background), then redesigned on 2026-10-20 (radial background, hearts; see below). Commit the user's own unsaved/uncommitted deck changes separately before applying an approved edit, so each edit is easy to undo.

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

All six header slides (5, 10, 23, 31, 44, 57) use the one "Section Header" layout of the deck's only master. Its subtitle placeholder was the theme text color at 82% tint (muted gray); on 2026-10-20 it was changed to `#2F3B52`, so slides 23, 31, 44 and 57 now get dark slate subtitles. Slide 5 sets `#2F3B52` itself and slide 10 sets black (`tx1`, over its photo), so neither changed. Applied by `section-header-subtitle-color.ps1` (a record, not to be re-run); renders after the change: `../images/section-header-slide23.png`, `...31.png`, `...44.png`, `...57.png`, which also show these slides' plain starting point for their designs.
- Hearts `Romance heart 1`–`6`: msoShapeHeart, fill `#C8435A`, no line, height 0.9 x width. A trail rising to the upper right of the title, smaller and fainter as it goes, echoing the Sphere rising and vanishing in the drawing. (left, top, width, rotation, transparency): (690, 318, 32, -12, 0.05), (756, 296, 27, 8, 0.20), (813, 276, 22, -10, 0.35), (862, 258, 17, 12, 0.50), (900, 243, 13, -8, 0.65), (930, 232, 9, 10, 0.78).
- Applied by `slide5-header.ps1` (in this folder); a record and template, not to be re-run on the current deck.

Assets in `../images/`:

- `slide5-final.png`: current slide 5, rendered through PowerPoint at 1920 x 1080.
- `slide6-source-2.jpg`: original Flatland illustration extracted from slide 6, reused without raster editing.
- `section0-slide6.png` through `section0-slide9.png`: section reference renders.
- `slide6-source-4.png`: other slide 6 picture, penguin scatterplot, not used in the approved design.

## Remaining section headers

The brief's slide numbers have shifted. Current main-talk headers as inspected in this session:

| Slide | Current title | Content to guide the visual |
|---|---|---|
| 10 | Seeing multivariate data | Existing penguin-and-ellipse artwork, created previously by the user |
| 23 | Flatland and Spaceland: dimension reduction | PCA, biplots, nonlinear methods; the brief calls this section Multivariate juicers |
| 31 | Elliptical Insights | Outliers, measurement error, collinearity, ridge regression; brief says slide 30 |
| 44 | The HE plot framework | Seeing multivariate tests as ellipses; brief says slide 40 |
| 57 | Checking multivariate models | Outliers, influence, robust estimation |

Only slide 5 has been changed so far. Work one section at a time, inspect actual slide content rather than relying on the brief's shorthand titles, show a preview, and obtain approval before updating the deck.

## Technical workflow

PowerPoint COM works from Claude Code's PowerShell tool (`New-Object -ComObject PowerPoint.Application`). For previews, open the deck read-only (`Presentations.Open($deck, $true, $false, $false)`), make the changes in memory, `Slide.Export(..., "PNG", 1920, 1080)` to the scratchpad, and close without saving; the real deck is untouched. For an approved edit, open it writable, make the same changes, `Save()`, export the final render to `../images/`, and close. PowerPoint must be closed first (check for a `~$Vis-MLM-talk4.pptx` lock file).

COM colors are BGR integers: R + 256 G + 65536 B. Some slides (e.g. 10) use theme colors, which python-pptx cannot report as RGB; export a render to see them.
