# GK-part-pages.md — DDAR-style part-page and chapter-opener diagrams

**Date:** 2026-07-02
**Branch:** `part-pages-test`
**Author:** Claude (Fable 5), working session with Gavin

## Goal

Michael's previous book, *Discrete Data Analysis with R* (DDAR), opened each part and chapter with a mind-map-style "bubble diagram": a colored center bubble (part or chapter) with satellite bubbles (chapters or sections) connected by tapered, color-blending bands. The Vis-MLM part pages were plain (title only) and chapter openers had no diagram. This work adds equivalent diagrams to the **PDF version** of Vis-MLM, in keeping with the book's existing part accent colors, with **zero changes to any book content** (no `.qmd`, no `_quarto.yml`, nothing in `docs/`).

## What the reader sees

- **Part pages (Parts I–IV):** below the "Part N / Title" heading, a diagram with the part as the center bubble and that part's chapters as satellites (chapter number + title in each bubble).
- **Chapter opening pages (Chapters 1–15):** a diagram at the top right of the page, above the krantz chapter head (big number + rule + title), with the chapter as the center bubble and its numbered sections as satellites ("4.1 Bivariate summaries", etc.) — exactly the DDAR chapter-opener arrangement.
- **End Matter part page and all front matter:** unchanged (no diagram files exist for them, and the hooks are guarded — see below).
- Diagrams use the established part accent colors (partI blue, partII teal, partIII dark green, partIV burnt orange). Center bubble = strong color with white bold sans text; satellites = light tint with black text; connections = tapered bands shading dark → light.

## Files added / changed

| Path | What it is |
|---|---|
| `latex/diagrams/part1.tex` … `part4.tex` | TikZ sources for the four part-page diagrams |
| `latex/diagrams/chap1.tex` … `chap15.tex` | TikZ sources for the 15 chapter-opener diagrams |
| `latex/diagrams/diagram-common.tex` | Shared setup: colors, `\band` connection macro, `rootbubble`/`satbubble` styles, `\bubbletitle` |
| `latex/diagrams/make-diagrams.sh` | Compiles every `part*.tex`/`chap*.tex` with xelatex and moves the PDFs to `figs/diagrams/` |
| `figs/diagrams/*.pdf` | The 19 pre-built diagram PDFs the book actually includes |
| `latex/part-colors.tex` | **New home of the part accent color definitions** (moved out of `preamble.tex`), `\input` by both the preamble and the diagram sources — one place to retheme everything |
| `latex/preamble.tex` (modified) | Color block replaced by `\input{latex/part-colors.tex}`; two new `\pretocmd` hooks insert the diagrams (details below) |
| `issues/make-part-diagrams.py` | The one-off Python generator that wrote the initial `.tex` sources — see "Regenerating from scratch" |
| `memory/project_part_diagrams.md` | Claude session memory of this work |

`git status` after the work shows **only** these files (plus memory notes). No `.qmd` was touched; the committed `Vis-MLM.tex`, `index.pdf`, and `docs/` are untouched. The HTML build is completely unaffected (everything lives on the LaTeX/PDF side).

## How the diagrams get into the book (preamble hooks)

Two `\pretocmd` patches in `latex/preamble.tex`, placed right after the existing `partcol` color-switch hook:

1. **Part pages** — `\pretocmd{\@endpart}` inserts the part diagram between the part title and the page break. It selects the file by the `partnum` counter that the existing `\pretocmd{\@part}` color hook already steps: `figs/diagrams/part\arabic{partnum}.pdf`, included at `width=.9\textwidth, height=.62\textheight, keepaspectratio`.
2. **Chapter openers** — `\pretocmd{\@makechapterhead}` inserts the chapter diagram right-aligned above the chapter head: `figs/diagrams/chap\thechapter.pdf` at `width=.66\textwidth, height=.38\textheight, keepaspectratio`.

Both hooks are wrapped in `\IfFileExists{...}`: any part or chapter without a matching PDF renders exactly as before. That is why the End Matter part (partnum 5) and the unnumbered front-matter chapters are untouched — there simply is no `part5.pdf` or `chap0.pdf`.

**Filename gotcha:** chapter files are **not** zero-padded (`chap4.pdf`, not `chap04.pdf`) because the hook builds the name from `\thechapter`, which expands to `4`. The first integration test failed silently (no diagrams appeared) with padded names.

## Why not the TikZ `mindmap` library?

DDAR's diagrams look like TikZ `mindmap` output, and that was the first implementation here. It was abandoned for two reasons, after considerable debugging:

1. **Hairline seam artifacts.** The mindmap library's connection bars (`circle connection bar`, and its `switch color` variant) are constructed from several abutting closed subpaths / paint operations. Rendered output shows thin white hairline gaps and rectangle outlines where the pieces meet — at every bubble junction. This reproduces under xelatex, pdflatex, RGB and CMYK alike (confirmed by reading `tikzlibrarymindmap.code.tex`: the color-switch shading is painted as three separate fills, and the bar itself as three closed subpaths). It is a long-standing pgf quirk, not fixable with style options (`outer sep=0`, `draw=none`, pre-resolved colors were all tried).
2. **Option quirks.** Overriding `sibling angle` / `level distance` only works inside `level 1 concept/.append style`, not in the child-options bracket (the library's own level styles win). This cost an iteration and made the sources fragile.

**The replacement:** plain TikZ (only the `calc` library, plus `pgf-blur` for shadows). Bubbles are ordinary circle nodes placed at explicit polar coordinates; each connection is a **single closed path** filled with one axis shading (dark at the hub → light tint at the satellite), so there is nothing to seam. Bands are drawn first, bubbles after, so band ends tuck underneath. The `\band{color}{angle}{distance}` macro in `diagram-common.tex` does this; the shading angle for a band pointing at angle θ is `θ − 90`.

## Styling (second pass — "make it less bland")

After a first flat-color version, these were added (all in `diagram-common.tex`, so every diagram inherits them):

- **Soft blur shadows** under every bubble (`blur shadow` from the **`pgf-blur`** package; style `softshadow`). Gives depth and makes overlapping satellite rings read as layered.
- **Top-lit vertical gradients:** center bubble `top color=#1!88!white, bottom color=#1!90!black`; satellites `top color=#1!22, bottom color=#1!42` (black text sits on the lightest region).
- **`\bubbletitle{number}{title}`:** the center bubble typography — `\LARGE` number, thin white divider rule (1.05 cm × 0.45 pt), then the title. Part pages use `\bubbletitle{Part IV}{...}`.
- **Band widths** tuned so the light end of each band matches the satellites' rim tint: chapter diagrams half-widths 0.50/0.16/0.28 cm (hub/waist/tip); part pages override to 0.66/0.22/0.38 cm via `\setlength` in each `part*.tex`.
- **No hyphenation** inside bubbles (`\hyphenpenalty=10000` via `execute at begin node`) — earlier drafts showed "Mul-tivariate".

## Content of the diagrams — where the section lists came from

**Source of truth was the built `Vis-MLM.tex` (July 1 build), not the raw `.qmd` files.** The qmds contain headings that do **not** appear in the PDF: `## Principles of graphical display` (ch 3) and `## Regression / ANOVA / ANCOVA` (ch 6) are inside `<!-- -->` comments; `## Repeated measures designs` (ch 11), `## Exercises` (ch 10), and `## Recursive partition methods` (ch 15) likewise don't reach the built book. Parsing qmds naively would have produced wrong section numbers.

Editorial choices made:

- The trailing **"What have we learned?"** section of every chapter is **omitted** from the diagrams (it's in all 14+ chapters, adds no orientation value, and since it is always last, omitting it cannot shift any displayed section number).
- Long section titles are shortened to fit bubbles (e.g., "Simpson's paradox: Marginal and conditional relationships" → "Simpson's paradox"; "Problems in understanding and communicating MLM results" → "Understanding MLM results").
- Chapter 14 has two sections literally titled "Example: Penguin data"; they are disambiguated as **"Penguins: influence"** (14.4) and **"Penguins: robust"** (14.6).
- Chapter numbering: in the PDF build, `21-discrim.qmd` builds as **Chapter 15** (not an appendix), so it gets `chap15.tex` under the Part IV color.
- Part pages show **one level** (part → chapters), unlike DDAR's two-level part pages (chapters + all their sections). Reason: DDAR had ≤ 3 chapters per part; Vis-MLM's Part IV has 6 chapters × ~9 sections ≈ 55 leaf bubbles, which cannot render readably on one page. The section detail lives on each chapter's opener instead, so nothing is lost. If Michael wants two-level pages for the smaller Parts I–III, it's a per-file edit of `part1..3.tex` (at the cost of inconsistency with Part IV).

## Maintenance

### Everyday tweaks (the normal path)

The `.tex` files in `latex/diagrams/` are the **maintained artifacts** — edit them directly:

- Section added/renamed/removed in a chapter → edit the matching `chapN.tex` (labels, and if the count changed, the angles: satellites sit at `clockwise from 90°` in steps of `360/n`; each satellite needs a matching `\band` line at the same angle/distance).
- Then rebuild: `sh latex/diagrams/make-diagrams.sh` (compiles all 19, moves PDFs to `figs/diagrams/`, cleans aux files).
- The book itself needs no special step afterwards — the next **Build → All Formats** just includes the updated PDFs. (The currently committed `index.pdf` / `Vis-MLM.tex` artifacts predate the diagrams; they'll pick them up on the next real build.)

### Retheming colors

Change colors **only** in `latex/part-colors.tex` (this now feeds both the book's headings/running heads via `preamble.tex` and the diagrams), then re-run `make-diagrams.sh`. This preserves the "single place to retheme" property of the partcol design.

### Regenerating from scratch

`issues/make-part-diagrams.py` is the generator that wrote the initial sources; it holds the full data table of parts/chapters/sections/labels/angles. **Re-running it OVERWRITES every `latex/diagrams/*.tex`, discarding hand edits** — only use it for wholesale restructuring, then run `make-diagrams.sh`.

### Dependencies

- `make-diagrams.sh` needs **`pgf-blur`** in the TeX tree: `tlmgr install pgf-blur`. Installed in TinyTeX on the Mac during this session; the **Windows machine will need it too** before regenerating there. The *book* build does not need it (it only `\includegraphics` the pre-built PDFs).
- While test-compiling the book manually (outside Quarto, which auto-installs missing packages), these also had to be installed into TinyTeX: `fvextra`, `tabularray`, plus a `tlmgr update --self`. Harmless/additive; noted here in case the toolchain state matters later.

## Print-production note (CMYK / transparency)

Diagrams are compiled with `\usepackage[cmyk]{xcolor}` to match the CRC CMYK requirement in the preamble. **However, the blur shadows use PDF transparency** (smoothly stepped semi-opaque paths). This flattens fine in normal print workflows, but if CRC production ever demands transparency-free / PDF-X flattened files, the one-line fix is in `diagram-common.tex`: replace the `softshadow` style's `blur shadow={...}` with a plain `drop shadow` (hard-edged, from the standard `shadows` library) or remove it, then re-run `make-diagrams.sh`.

## How it was verified

1. Each diagram PDF inspected individually after every styling iteration (worst cases checked deliberately: ch 4 with 13 satellites, ch 3/ch 8 with only 2, ch 10/13 with math in labels — `$T^2$`, `$\eta^2$`, `$\mathcal{M}$`, `$\boldsymbol{\beta}$` — which required `amsmath` in `diagram-common.tex`).
2. **Full-book integration test:** a scratch copy of the July-1 `Vis-MLM.tex` was patched with the same two preamble hooks and compiled end-to-end with xelatex (524 pages, exit 0). Pages visually verified in context: Part I/II/IV pages, chapter openers 1, 4, and 10, and the End Matter part page (confirmed plain, no errors). The repo's committed `Vis-MLM.tex` was never modified — all test compiles ran in a scratch directory.
3. Confirmed content untouched: `git status` shows only the files listed above.

## Known limitations / possible follow-ups

- **Two-level part pages** (DDAR-exact, with sections under each chapter hub) are feasible for Parts I–III but not Part IV (too many leaves); not done, for cross-part consistency.
- **A whole-book frontispiece** in the same style (center = book title, four part hubs with chapter satellites, like DDAR's cover diagram) would be a natural addition — one more `latex/diagrams/*.tex` plus wherever Michael wants to include it. Not done (out of scope).
- The **HTML side** has no equivalent of these diagrams (the `index.qmd` smartdiagram flow chart is unrelated and untouched); an HTML rendering would be a separate effort — see `issues/task-color-themes.md` for the related HTML color-theming TODO.
- Satellite angles are equally spaced starting at 12 o'clock; if a chapter gains many sections and bubbles crowd, reduce `minimum size`/`text width` in that file's `sat` style or increase the distance in its `\band`/`at (θ:d)` coordinates.
