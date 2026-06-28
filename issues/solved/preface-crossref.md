# Cross-references from unnumbered Preface render differently in HTML vs. PDF

Something weird started happening with the rendering of cross-references to later chapters in my Preface
(`index.qmd`) in the HTML version compared to the PDF.

## Setup

Quarto book with `crossref: chapters: true` in `_quarto.yml`. The entry point `index.qmd`
contains the Preface, declared as:

```markdown
# Preface {.unnumbered}
```

Inside the Preface, chapter-level cross-references like `@sec-introduction` are used
to guide readers through the book structure.

## Observed behavior

**PDF:** References render as expected: `Chapter 1`, `Chapter 2`, `Chapter 3`.

**HTML:** References render as the heading's display string: `1 Warm-up Exercises`,
`2 Introduction`, `3 Getting Started` (hyperlinked).

Screenshots: `preface-crossref-pdf.png`, `preface-crossref-html.png`.

## Expected behavior

`@sec-label` references to chapter-level sections should produce `Chapter N` in HTML,
consistent with PDF and with behavior in all other (numbered) chapters of the same book.

## Notes

- From any *numbered* chapter, `@sec-introduction` renders as `Chapter 2` in both HTML
  and PDF — the inconsistency is specific to the `{.unnumbered}` source context.
- `crossref: chapters: true` is set globally.
- Quarto version: 1.9.36; R/knitr rendering.

## Workaround

None elegant. Conditional content blocks with hardcoded anchor links for HTML and `@sec-`
references for PDF work, but are impractical for a preface with a dozen references.
