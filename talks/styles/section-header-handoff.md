# Section-header visuals: handoff

Updated: 2026-10-19

## Files and scope

Working deck: `C:/R/Projects/Vis-MLM-book/talks/Vis-MLM-talk4.pptx`.
Original brief: `../section-headers.md`.
Keep all work for this task under `talks/`; this is not a HistData task. Generated assets belong in `talks/images/`, and design/handoff notes in `talks/styles/`.

Do not modify the PowerPoint without approval for the specific change. Slide 5 was explicitly approved and updated. The user approved its final appearance and requested deletion of the backup; that backup has been deleted.

## Design preferences established

Section headers must retain their role and existing typography, text positions, and hierarchy. Avoid replacing them with explanatory slides. The user explicitly wants to avoid an obviously AI-generated appearance. Existing illustrations tied to the actual following slides are useful sources.

Rejected for this section: an R-generated heart-shaped point cloud shown in three projections. It took over the layout, changed typography, used anonymous data, and the views were insufficiently distinct. Do not revisit this direction for slide 5. Its exploratory files were deleted 2026-10-19 (last version in commit 48e854c6).

## Approved slide 5

Title: "Why a romance in many dimensions?"

Used Abbott's Flatland sphere illustration already present on slide 6. Placed it centered at the top, preserving all existing slide 5 text, formatting, and positions. Added a pale blue-gray background derived from the header fill of slides in this section.

Exact PowerPoint geometry and colors (points):

- Slide: 960 x 540 (13 1/3 x 7 1/2 inches).
- Illustration: left 135, top 10, width 690, height 210. Horizontally centered.
- Background: solid `#F2F3F6`.
- Header source color: PowerPoint RGB integer 6567967, with header fill transparency 0.78. Slide background was calculated as 6% of the underlying header color plus 94% white.
- Illustration softened with a rectangle in the slide background color, directly over the picture: same geometry, no line, fill transparency 0.70 (30% opaque).
- Added picture name: `Section 0 Flatland illustration`.
- Overlay name: `Flatland illustration softening overlay`.
- Existing title, two subtitle paragraphs, and slide number unchanged.

Assets in `../images/`:

- `slide6-source-2.jpg`: original Flatland illustration extracted from slide 6, reused without raster editing.
- `slide5-flatland-final.png`: final approved slide 5 rendered through PowerPoint at 1920 x 1080.
- `section0-slide6.png` through `section0-slide9.png`: section reference renders.
- `slide6-source-4.png`: other slide 6 picture, penguin scatterplot, not used in the approved design.

No backup of the deck should be recreated unless needed for a future approved edit. The user asked to remove the slide 5 backup after acceptance.

## Remaining section headers

The brief's slide numbers have shifted. Current main-talk headers as inspected in this session:

| Slide | Current title | Content to guide the visual |
|---|---|---|
| 10 | Seeing multivariate data | Existing penguin-and-ellipse artwork, created previously by the user |
| 23 | Flatland and Spaceland: dimension reduction | PCA, biplots, nonlinear methods; the brief calls this section Multivariate juicers |
| 31 | Elliptical Insights | Outliers, measurement error, collinearity, ridge regression; brief says slide 30 |
| 44 | The HE plot framework | Seeing multivariate tests as ellipses; brief says slide 40 |
| 57 | Checking multivariate models | Outliers, influence, robust estimation |

Only slide 5 was changed in this conversation. Work one section at a time, inspect actual slide content rather than relying on the brief's shorthand titles, show a preview, and obtain approval before updating the deck.

## Technical workflow

PowerPoint COM was available via an escalated PowerShell command. Read-only opening and slide.Export produced faithful previews with the deck's actual typography. For the approved edit, opened the deck writable, made changes only to slide 5, saved, exported the final slide, and closed the deck. Non-escalated COM failed with logon-session error 80070520; the escalated call worked.

Filesystem permissions in this chat were still rooted in HistData, so writing to the actual book talks directory required escalation. Do not use HistData as a staging directory for future work on this talk.
