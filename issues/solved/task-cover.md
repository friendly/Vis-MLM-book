# Task: Cover Page in PDF

## Problem summary

The book cover (`images/cover/cover-peng.pdf`) must appear as page 1 of the
compiled PDF, before Quarto's generated title page, correctly sized and positioned
within the 6 × 9 inch trim area (krantz2, letterpaper).

**Status**: DONE

---

## Approaches tried and rejected

| Approach | Outcome |
|---|---|
| `cover-image:` in `_quarto.yml` | HTML only — no effect on PDF |
| `\includepdf` in `before-body.tex` | Cover appeared *after* Quarto's title page |
| `qpdf` / `pdftk` PDF prepending | Broke hyperlinks and bookmarks in the rest of the PDF |
| Adobe Acrobat manual insert | Works but must be repeated after every recompile |

---

## Solution (2026-04-30)

Two sub-problems solved: ordering (A2) and sizing/positioning (A1).

### A2 — ordering: `\AtBeginDocument` in `preamble.tex`

`before-body.tex` is injected *after* Quarto's front matter, so `\includepdf`
placed there appears after the title page. Moving the call into `\AtBeginDocument`
in `preamble.tex` fires it before any Quarto content:

```latex
\AtBeginDocument{%
  \if@filesw\immediate\write\@auxout{%
    \string\bibdata{references,R-refs,pkgs,packages,Rpackages-4.5.1}}\fi
  \includepdf[pages=1]{images/cover/cover-peng-scaled.pdf}%
}
```

The `\bibdata` write is unrelated to the cover — it patches the author-index
Perl script and was already in `\AtBeginDocument`; the `\includepdf` line was
added to the same block.

### A1 — positioning: pre-scaled wrapper PDF

`cover-peng.pdf` is A4 (8.27 × 11.69 in). Using `\includepdf` options such as
`fitpaper=true` or `width=\paperwidth` either changed the output page size or
were unreliable. The robust fix is a one-page wrapper document that places the
cover art at the correct coordinates on a letter-sized page, producing
`images/cover/cover-peng-scaled.pdf`.

The wrapper is `latex/make-cover-scaled.tex`:

```latex
\documentclass{article}
\usepackage[paperwidth=8.5in, paperheight=11in, margin=0pt, noheadfoot]{geometry}
\usepackage{graphicx}
\pagestyle{empty}
\begin{document}
\vspace*{1.3125in}%
\noindent\hspace*{1.875in}%
\includegraphics[width=6in, height=9in, keepaspectratio=false]%
  {images/cover/cover-peng.pdf}%
\end{document}
```

**Positioning logic:**  The cover artwork measures 4.875 × 6.375 in when rendered.
To centre it within the 6 × 9 in trim area:

- vertical offset from trim top: (9 − 6.375) / 2 = 1.3125 in → `\vspace*{1.3125in}`
- horizontal offset from trim left: (6 − 4.875) / 2 = 0.5625 in (theoretical);
  empirically calibrated to `\hspace*{1.875in}` — the ~0.8 in discrepancy is
  internal left padding in the source A4 PDF.

`keepaspectratio=false` forces the A4 source to exactly 6 × 9 in. The A4 page
dimensions are just the PDF carrier; the cover art was designed for the 6 × 9 trim.

**To rebuild** (from project root, after any change to `cover-peng.pdf`):

```bash
xelatex -output-directory=images/cover latex/make-cover-scaled.tex
mv images/cover/make-cover-scaled.pdf images/cover/cover-peng-scaled.pdf
```

**To test positioning without a full book rebuild**, render the minimal test file:

```bash
quarto render cover-test.qmd
```

`cover-test.qmd` (project root) uses the same `documentclass: krantz` and
`classoption: [10pt, krantz2, titlepage, letterpaper]` and includes only the
cover-related preamble (`latex/cover-test-header.tex`). It renders in ~1 minute
vs ~15 minutes for the full book.  The crop marks on the second page show the
trim boundary; the cover on page 1 should align with them.

If the positioning needs further adjustment, measure the artwork offset from the
crop marks and update `\vspace*` (vertical) and `\hspace*` (horizontal) by the
observed difference.

---

## Result

- Cover appears as page 1 of the compiled PDF, before Quarto's title page.
- Artwork centred within the 6 × 9 in trim area on a letter-sized page.
- Bookmarks and hyperlinks throughout the document are unaffected.
- No post-processing in Acrobat needed for review copies.
- `preamble.tex` requires no further changes.

---

## Related files

| File | Role |
|---|---|
| `images/cover/cover-peng.pdf` | Cover source (A4) |
| `images/cover/cover-peng-scaled.pdf` | Generated wrapper — included by `\includepdf` |
| `latex/make-cover-scaled.tex` | Wrapper source; edit to adjust positioning |
| `latex/cover-test-header.tex` | Minimal preamble used by `cover-test.qmd` |
| `cover-test.qmd` | Fast positioning test (renders in ~1 min) |
| `latex/preamble.tex` | Contains `\usepackage{pdfpages}` and `\AtBeginDocument` block |
| `images/cover/cover-peng.jpg` | JPEG version — used for HTML `cover-image:` only |
