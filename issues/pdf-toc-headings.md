# PDF TOC heading issues

Status: resolved

Date: 2026-05-31

## Observed issues

Inspection of the built PDF TOC (`docs/Vis-MLM.pdf`) shows two clear TOC-heading/layout defects:

1. Part headings are repeated before every chapter in the same part.
   - Example: `I Orienting Ideas` appears before Chapters 1, 2, and 3.
   - Example: `III Univariate Linear Models` appears before Chapters 6, 7, 8, and 9.
   - Example: `IV Multivariate Linear Models` appears before Chapters 10, 11, and 12.

2. Section numbers with two-digit terminal components are too wide for the current TOC number box.
   - Example: `12.10Canonical correlation analysis`
   - Example: `12.11MANCOVA models.`
   - Example: `12.12What have we learned?`

Headings and subheadings in the TOC also need to preserve the formatting carried in the source headings, such as Markdown italics and inline math. The `.toc` file already contains those commands, for example `\emph {Flatland}` and `\(T^2\)`, so the fix should not sanitize or stringify the heading argument.

The PDF text extraction also shows typography artifacts such as `T able`, `W arm-up`, `T opics`, and `ANOV A`. Those appear to be from PDF text extraction / font spacing in headings rather than malformed `.toc` entries: `index.toc` contains the correct source text (`Table of contents`, `Warm-up Exercises`, `Topics in Linear Models`, `ANOVA`, etc.).

## Cause

The current patch in `latex/preamble.tex` fixes the old krantz part-placement bug by calling `\toc@draw` at the top of `\l@chapter`.

That flushes the delayed part heading before the first chapter of the part, but it does not consume/reset `\toc@draw`. As a result, the same pending part heading remains armed and is flushed again before every later chapter until the next `\l@part` overwrites it.

The section-number collision comes from the krantz default section TOC number width:

```tex
\newcommand*\l@section{\@dottedtocline{1}{1.5em}{2.3em}}
```

`2.3em` is enough for labels like `9.10`, but too narrow for labels like `12.10`.

## Fix plan

1. Update the `latex/preamble.tex` TOC patch so chapter entries call the pending `\toc@draw` once and then reset it:

```tex
\toc@draw
\let\toc@draw\relax
```

2. Preserve the existing direct chapter-entry rendering. The goal is not to restore krantz's fully delayed chapter renderer; it is only to consume the delayed part heading once.

3. Override the section TOC dimensions after the chapter patch:

```tex
\renewcommand*\l@section{\@dottedtocline{1}{1.5em}{3.0em}}
\renewcommand*\l@subsection{\@dottedtocline{2}{4.5em}{3.8em}}
\renewcommand*\l@subsubsection{\@dottedtocline{3}{8.3em}{4.6em}}
```

4. Rebuild the PDF and inspect the TOC text:
   - Part headings should appear once per part.
   - `12.10`, `12.11`, and `12.12` entries should have visible space before their titles.
   - Headings/subheadings with source formatting should keep their italics/math commands in the generated `.toc` and render them normally in the PDF.
   - The PDF should still exclude online-only appendices.

## Implementation notes

Implemented in `latex/preamble.tex`:

- `\l@chapter` now consumes the pending krantz `\toc@draw` once and immediately resets it with `\let\toc@draw\relax`.
- Section, subsection, and subsubsection TOC number boxes are wider, so entries such as `12.10` no longer collide with their titles.
- The section/subsection title argument is still passed directly to `\@dottedtocline`; no string conversion or sanitization is added, so Quarto-emitted formatting such as `\emph{}` and inline math is preserved.

Post-render checks:

- `docs/Vis-MLM.pdf` was rebuilt successfully and passed the PDF appendix check.
- PDF text extraction now shows part headings only at part transitions: `I Orienting Ideas`, `II Exploratory Methods`, `III Univariate Linear Models`, and `IV Multivariate Linear Models` appear once before their first chapters in the TOC scan.
- PDF text extraction now shows the Chapter 12 entries with separation: `12.10 Canonical correlation analysis`, `12.11 MANCOVA models`, and `12.12 What have we learned?`.
- `index.toc` still contains formatted heading tokens, including `\emph {Flatland}`, `\emph {Spaceland}`, and inline math entries such as `\(T^2\)`.
- A full dual build with `./build.sh --full` also completed after the fix. It archived `pdf/Vis-MLM.pdf`, rebuilt the HTML output, restored `pdf/Vis-MLM.pdf` to `docs/Vis-MLM.pdf`, and passed the HTML output check.

## Work completed since 4:19pm

After the 4:19pm request to inspect the built PDF TOC, document a fix plan here, and implement it, I did the following:

1. Inspected the built PDF TOC and confirmed the visible heading defects:
   - delayed part headings were being repeated before multiple chapters in the same part;
   - long section numbers such as `12.10`, `12.11`, and `12.12` collided with their titles;
   - formatted headings needed to retain source italics and math in TOC entries.

2. Wrote the initial analysis and fix plan in this file before changing the implementation.

3. Updated `latex/preamble.tex` so the pending krantz part heading is flushed once at the first chapter of a part and then reset with `\let\toc@draw\relax`. This fixed repeated part headings in the PDF TOC.

4. Widened the PDF TOC number boxes for section, subsection, and subsubsection entries in `latex/preamble.tex`. This fixed title collisions for long labels while leaving Quarto's heading argument intact, preserving italics and inline math in TOC entries.

5. Rebuilt and inspected the PDF after the TOC changes. The PDF appendix check passed, part headings appeared only at part transitions, and Chapter 12 TOC entries showed proper separation between numbers and titles.

6. Investigated the missing author index found after the TOC work. `make-authorindex.sh` was hard-coded to Michael's Windows paths, so on this machine it generated an empty `index.ain`.

7. Made `make-authorindex.sh` portable by deriving `BIBINPUTS` from the repository root and preserving default BibTeX search paths.

8. Updated `build.sh` so when authorindex regenerates `index.ain` after the first PDF render, the script automatically re-renders the PDF and re-runs the PDF appendix check before archiving. This ensures the regenerated author index is actually included in `docs/Vis-MLM.pdf`.

9. Ran `./build.sh --pdf` and verified the author index was included. The resulting PDF had 541 pages, with `Author Index` beginning near the end and populated from `index.ain`.

10. Ran the final dual build with `./build.sh --full`. It completed successfully, archived the PDF to `pdf/Vis-MLM.pdf`, rebuilt HTML through both passes, restored the downloadable PDF to `docs/Vis-MLM.pdf`, and passed both the PDF appendix check and HTML output check.
