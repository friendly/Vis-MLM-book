# Chapter-opening block quotes, à la Navarro's *Learning Statistics with R*

Notes from digging into how Danielle Navarro's book does the styled quote at
the top of each chapter (e.g. the W.H. Auden epigraph at the start of
<https://learningstatisticswithr.com/01-whystats.html>), for possible use in
Vis-MLM.

## Source

- Site repo: <https://github.com/djnavarro/rbook> — but per its `README.md`,
  **this repo only holds the deployed site** (`docs/`, published via GitHub
  Pages from `main`); *"Source files for the book are not currently part of
  this repository."* No `.qmd`/`.Rmd` source to inspect.
- So the notes below come from reverse-engineering the **rendered HTML +
  linked CSS** in `docs/`, which is complete enough to fully reproduce it:
  - Page: `docs/01-whystats.html`
  - Stylesheet: `docs/styles.css`
- The book itself is built with **Quarto** (not classic bookdown — note the
  `quarto-section-identifier`/`quarto-title-meta` classes in the HTML), so
  this is a Quarto pattern, directly applicable to Vis-MLM.

## How it's built

Two different things are both loosely "block quotes" on that page, and it's
worth keeping them distinct:

**1. The chapter-opening epigraph** — a custom `<div class="pullquote">`,
written directly in the `.qmd` as raw HTML (not a Quarto callout, not a
Pandoc `>` blockquote):

```html
<div class="pullquote">
<p><em>"Thou shalt not answer questionnaires<br>
Or quizzes upon World Affairs,<br>
&nbsp;&nbsp;&nbsp;&nbsp;Nor with compliance<br>
Take any test. Thou shalt not sit<br>
With statisticians nor commit<br>
&nbsp;&nbsp;&nbsp;&nbsp;A social science"</em></p>
<p>— W.H. Auden</p>
<p>The quote comes from Auden's 1946 poem <em>Under Which Lyre...</em> ...</p>
</div>
```

Three `<p>` children, each styled by position (`:nth-of-type`):
1. the quote itself (italic, larger, with a decorative opening quote mark)
2. the attribution line ("— W.H. Auden"), right-aligned, smaller, upright
3. optional plain-text source/citation, right-aligned, smaller still

**2. Ordinary in-text quotations** (e.g. the belief-bias syllogisms further
down the same page) — just a plain Pandoc `>` blockquote, rendered as
Bootstrap's stock `<blockquote class="blockquote">` with no custom styling.
So the fancy treatment is reserved for chapter epigraphs specifically, not
applied to every blockquote in the book.

## The CSS (`docs/styles.css`, in full — it's a short, self-contained file)

```css
/* Custom callout-style block for chapter epigraphs and pull quotes.
   Deliberately not named `callout-*` so Quarto's callout Lua filter
   doesn't try to attach title/collapse machinery to it.

   Citation/source info is written as a third plain paragraph inside the
   div rather than as a footnote - a footnote reference here would make
   Quarto tag this div `page-columns page-full` so the note can escape to
   the margin, and that promotion drags in a viewport-relative internal
   grid that fights any attempt to size/align this box to the body-text
   column (see PLAN.md notes on this if revisiting). Keeping citations
   inline avoids that fight entirely. */

.pullquote {
  position: relative;
  margin: 1.5rem 0;
  padding: 1rem 1.25rem 1rem 3rem;
  border-left: 4px solid #7d5a68;
  background-color: rgba(125, 90, 104, 0.06);
  font-style: italic;
}

.pullquote::before {
  content: "\201C";
  position: absolute;
  left: 0.35rem;
  top: -0.1rem;
  font-family: Georgia, "Times New Roman", serif;
  font-style: normal;
  font-size: 2.75rem;
  line-height: 1;
  color: rgba(125, 90, 104, 0.45);
}

/* Attribution line, e.g. "--- W.H. Auden" */
.pullquote p:nth-of-type(2) {
  margin-top: 0.75rem;
  margin-bottom: 0;
  font-style: normal;
  font-size: 0.9rem;
  text-align: right;
  color: rgba(0, 0, 0, 0.65);
}

/* Source/citation line, e.g. "Presidential Address to the..." */
.pullquote p:nth-of-type(3) {
  margin-top: 0.25rem;
  margin-bottom: 0;
  font-style: normal;
  font-size: 0.8rem;
  text-align: right;
  color: rgba(0, 0, 0, 0.5);
}
```

Design notes worth keeping, straight from her comment:
- The class is deliberately **not** named `callout-*` so Quarto's callout
  Lua filter leaves it alone (no auto-injected title bar/collapse widget).
- The citation is a plain third paragraph, **not a footnote** — a footnote
  here would get the div auto-promoted to `page-columns page-full` (for
  margin-note escape), and that grid fights any attempt to align/size the
  box to the normal text column width. Inline citation sidesteps it.
- The big serif opening quote mark (`\201C` = `"`) is a `::before`
  pseudo-element, not literal text — keeps it out of the copy-pasted text
  and lets it be sized/positioned independently of the quote's own font size.

## Applicability to Vis-MLM

- `styles.scss` currently has `.blockquote { color: #0000FF; }` (just a
  color override on Bootstrap's default class, no box/border styling) —
  adding a separate `.pullquote` class as above wouldn't collide with that.
- No chapter currently uses either a pullquote-style div or the plain
  Pandoc `>` blockquote for an opening epigraph — this would be a new
  pattern across all chapters if adopted.
- **The catch for us specifically**: Vis-MLM renders to both HTML *and*
  print PDF (via `krantz.cls` + LaTeX — see `Vis-MLM.tex`, `build.sh`).
  Navarro's book is HTML/Quarto-only (the repo's `docs/` has no PDF/LaTeX
  target), so her CSS-only solution only solves half of what we'd need.
  `krantz.cls` has no built-in epigraph/pullquote command (checked — no
  `epigraph` or `pullquote` macro defined), so the PDF side would need
  either the LaTeX `epigraph` package or a small custom environment,
  written to visually match the CSS version (left rule, serif opening
  quote mark, right-aligned attribution).

## Possible next steps, if we want this

1. Decide whether every chapter gets an opening epigraph, or just some.
2. Add a `.pullquote` rule to `styles.scss` (can copy Navarro's almost
   verbatim, just retune the accent color to match Vis-MLM's palette
   instead of her `#7d5a68`).
3. Write a matching LaTeX environment/macro for the `krantz.cls` PDF build
   so HTML and print stay visually consistent.
4. Pick and format one epigraph as a test case in a single chapter before
   rolling out to all of them.
