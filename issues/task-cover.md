# Task: Cover Page in PDF

## Problem summary

The book cover (`images/cover/cover-peng.pdf` or `.jpg`) cannot be inserted into the
compiled `index.pdf` automatically via Quarto or standard LaTeX. The cover must currently
be added manually as a post-processing step in Adobe Acrobat.

---

## What is in place

- `images/cover/` contains several versions of the cover:
  - `cover-peng.jpg`, `cover-peng.pdf`, `cover-peng.png`, `cover-peng.pptx`
  - `cover-ellipse.jpg`, `cover-ellipse.pdf`
  - `peng3d-cover.png`, `peng3d-cover-crop.png`, `peng3d-cropped.png`, `peng3d.png`

- `_quarto.yml` has `cover-image: images/cover/cover-peng.jpg` — this works for the
  HTML site (displayed on the book's web page) but has no effect on the PDF output.

- `latex/before-body.tex` has a commented-out attempt:
  ```latex
  # \titlehead{\includegraphics[width=6in]{images/cover-ellipses.png}}
  ```
  (The `\titlehead` command is not available in `krantz` / `book` class.)

---

## Approaches tried

### Approach 1: Quarto `cover-image` front matter — FAILED
`cover-image:` in `_quarto.yml` only affects HTML output. There is no equivalent
Quarto PDF option that inserts a cover page before page 1 of the document.
See: https://github.com/quarto-dev/quarto-cli/discussions/1941

### Approach 2: `pdfpages` `\includepdf` in `before-body.tex` — IN PROGRESS
`\usepackage{pdfpages}` added to `preamble.tex`; `\includepdf[pages=1]{...}\cleardoublepage`
added to top of `before-body.tex`. Cover is inserted but: (a) not scaled/centered to fill
the page, and (b) appears after Quarto's generated title page, not before it.
See Option A above for next steps.

### Approach 3: Command-line PDF prepending (qpdf or similar) — FAILED
Tried prepending `cover-peng.pdf` to `index.pdf` using a command-line PDF tool
(qpdf or pdftk). The resulting file had the cover as page 1, but the rest of the PDF
was broken: hyperlinks, bookmarks, and internal navigation (TOC links, cross-references)
in `index.pdf` were no longer active. The issue is that prepending a foreign PDF
page disrupts the internal PDF structure (cross-reference table, object numbering).

### Approach 4: Adobe Acrobat manual insert — CURRENT WORKAROUND
Open `index.pdf` in Adobe Acrobat and use **Organize Pages → Insert** to:
1. Insert `cover-peng.pdf` as page 1 (before the existing first page)
2. Insert a blank page after the cover (so the copyright page falls on a recto)

This produces a correct PDF with all hyperlinks and bookmarks intact. Downside:
must be repeated after every full recompile.

---

## Possible solutions to investigate

### Option A: Include cover as LaTeX `\includepdf` (pdfpages package)

`\includepdf` inserts the external page into the PDF object stream correctly, so
bookmarks and cross-references in the main document are unaffected.

**Status: PARTIALLY TRIED (2026-04-05) — two problems remain.**

#### Problem A1: Cover is not centered or scaled to fill the page

`\includepdf[pages=1]{...}` inserts the PDF at its natural size with no scaling.
Options to fill the page:

```latex
% Option: fit to paper dimensions
\includepdf[pages=1, fitpaper=true]{images/cover/cover-peng.pdf}

% Option: explicit scale to page (may need to tweak scale factor)
\includepdf[pages=1, scale=1.0, offset=0 0]{images/cover/cover-peng.pdf}

% Option: use width/height (requires recent pdfpages)
\includepdf[pages=1, width=\paperwidth, height=\paperheight]{images/cover/cover-peng.pdf}
```

`fitpaper=true` is the most robust: it sets the output page size to match the
included PDF's page size, which is correct if `cover-peng.pdf` is already trimmed
to the book's trim size.

#### Problem A2: Cover appears AFTER Quarto's generated title page [**FIXED**]

`before-body.tex` is inserted by Quarto after its own front matter (title, author,
date from YAML). So the order is currently:
1. Quarto title page
2. Cover (our `\includepdf`)
3. Copyright page

For a printed book the cover must be first. **Quarto's title page needs to be
suppressed or moved.** Two approaches to try:

- **A2a: Use `\AtBeginDocument` in `preamble.tex`** — runs before any content
  including Quarto's title page:
  ```latex
  \AtBeginDocument{%
    \includepdf[pages=1, fitpaper=true]{images/cover/cover-peng.pdf}
    \cleardoublepage}
  ```
  Move the `\includepdf` line from `before-body.tex` to `preamble.tex` and remove
  it from `before-body.tex`.

- **A2b: Suppress Quarto's title page** — set `title-page: false` (or equivalent)
  in `_quarto.yml` PDF options, then build a full custom title page in `before-body.tex`
  in the correct order: cover → blank → title → copyright.
  Risk: may require recreating the full title layout manually.

#### Also noted (2026-04-05): PDF output location with All Formats

When building with `Build -> All Formats`, the final PDF lands in `docs/Vis-MLM.pdf`,
not `./index.pdf` as expected from a PDF-only build. The initial `./index.pdf` is
created then apparently moved or replaced. **Update `CLAUDE.md`** once this is
confirmed as consistent behaviour.

### Option B: LaTeX title page using `\includegraphics`
Define a custom title page in `before-body.tex` that uses `\includegraphics` to
fill the page with the cover image:

```latex
\thispagestyle{empty}
\begin{titlepage}
  \includegraphics[width=\paperwidth, height=\paperheight, keepaspectratio=false]%
    {images/cover/cover-peng.pdf}
\end{titlepage}
\cleardoublepage
```

This keeps everything in one LaTeX compile pass. The cover would be embedded as
a graphic rather than a PDF page — fine if `cover-peng.pdf` is a single image page.

**Risk:** Geometry may differ slightly from the original cover PDF dimensions.

**Status:** Not yet tried.

### Option C: Post-processing with `pdfpages` + `pdftk` properly
Standard `pdftk` and `qpdf` prepending broke bookmarks. However, there are
techniques to merge PDFs while preserving bookmarks — e.g., using Ghostscript
with the correct flags, or `cpdf` (Coherent PDF tools). Worth investigating if
Option A/B don't work.

### Option D: Continue with Acrobat manual insert
Acceptable for the final camera-ready submission, since that is a one-time step.
Not acceptable for iterative review copies.

---

## Recommendation

Try **Option A** (`pdfpages`) first — add `\usepackage{pdfpages}` to `preamble.tex`
and `\includepdf[pages=1]{images/cover/cover-peng.pdf}\cleardoublepage` to
the top of `before-body.tex`. Recompile and verify links are intact.

---

## Related files

- `images/cover/cover-peng.pdf` — cover as PDF (best source for `\includepdf`)
- `images/cover/cover-peng.jpg` — cover as JPEG (used for HTML)
- `latex/before-body.tex` — natural place for the cover insertion
- `latex/preamble.tex` — where `\usepackage{pdfpages}` would go
- `_quarto.yml` — `cover-image:` (HTML only)
- https://github.com/quarto-dev/quarto-cli/discussions/1941 — prior Quarto discussion
