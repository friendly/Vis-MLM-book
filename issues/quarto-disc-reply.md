# Reply to @mcanouil — Quarto Discussion #14362

---

Thank you @mcanouil — your suggestion to create a minimal reproducible example was 
exactly right and led to a much clearer diagnosis.

## The Test

I created a minimal repro document with three tests, available in the repo:

- [`issues/quarto-pandoc-test.qmd`](https://github.com/friendly/Vis-MLM-book/blob/master/issues/quarto-pandoc-test.qmd)
- [`issues/quarto-pandoc-test-macros.qmd`](https://github.com/friendly/Vis-MLM-book/blob/master/issues/quarto-pandoc-test-macros.qmd)
- Generated: [`issues/quarto-pandoc-test.tex`](https://github.com/friendly/Vis-MLM-book/blob/master/issues/quarto-pandoc-test.tex)

The document is configured with `parse-latex` in `format: html: filters:` only (matching
the book setup), and `keep-tex: true` so the generated `.tex` can be inspected.

Each test defines a multi-line `\providecommand` with `%` at line-ends (the standard
LaTeX style for suppressing whitespace in the expanded output), uses the macro in a raw
inline, and places a Markdown footnote immediately after — the pattern that caused
`! Extra }, or forgotten \endgroup` in the book.

**Test 1** — `\providecommand` defined directly in a `{=latex}` raw block in the document:

```latex
\providecommand{\myone}[1]{%
  \textit{T1: #1}%
}
```
followed by `` `\myone{alpha}`{=tex}.[^fn] ``

**Test 2** — Same definition, but via `{{< include quarto-pandoc-test-macros.qmd >}}`
(simulating how the book includes `latex/latex-commands.qmd` in every chapter).

**Test 3** — The macro emitted by inline R via `cat("\\mythree{gamma}")` followed by
`.[^fn]` on the next line.

## Results (from the generated `.tex`)

**Tests 1 and 2 — macros pass through unexpanded:**

```latex
% Test 1:
\providecommand{\myone}[1]{%
  \textit{T1: #1}%
}
...
Static inline then footnote: \myone{alpha}.\footnote{Test 1 footnote...}

% Test 2 (from {{< include >}}):
\providecommand{\mytwo}[1]{%
  \textit{T2: #1}%
}
...
\mytwo{beta}.\footnote{Test 2 footnote...}
```

Both macros appear **unexpanded** in the `.tex` file, and `\myone{alpha}.\footnote{...}`
is on a single line — exactly what we want. XeLaTeX then expands `\myone{alpha}` natively;
the `%` in the definition body acts as a TeX comment, so the expansion is just
`\textit{T1: alpha}` with no literal `%`. Both tests compiled successfully.

**This confirms your point: `format: html: filters:` correctly prevents parse-latex
from running during PDF builds. It is not the direct cause of the expansion.**

**Test 3 — different issue:**

```latex
\mythree{gamma}

.\footnote{Test 3 footnote...}
```

A knitr code chunk adds `\n\n` after its output, splitting the macro call and the
`.[^fn]` footnote reference into separate paragraphs. This is a formatting problem
(dangling `.` in its own paragraph) but not the `Extra }` error.

## What Was Actually Happening in the Book

The real cause was a combination of two things:

**1. Stale freeze cache with old macro definitions.**

The book's `latex/latex-commands.qmd` (included in every chapter via `{{< include >}}`)
originally defined the index macros with multi-line bodies:

```latex
\providecommand{\ixd}[1]{%
  \index{#1@\texttt{#1} data}%
  \index{datasets!#1@\texttt{#1}}%
}
```

When `parse-latex` was still in the *global* `filters:` list (before we moved it to
`format: html: filters:`), it ran for **both** HTML and PDF pandoc passes. During the
PDF pass, `parse-latex`'s `RawBlock` handler called `pandoc.read(raw.text, 'latex')` on
the block containing `\providecommand{\ixd}`. This registered `\ixd` in pandoc's macro
table. When `\ixd{Prestige}` was subsequently encountered as a raw inline and
`pandoc.read("\ixd{Prestige}", 'latex')` was called, pandoc expanded it using the
registered multi-line definition — inserting the literal `%` characters from the body
into the output. The `%` then commented out the `.\footnote{` that followed.

**2. `{{< include >}}` changes do not invalidate the freeze cache.**

After we moved `parse-latex` to `format: html: filters:` (Fix 3 in the original post),
the filter should have stopped running for PDF — and the simple repro confirms it does.
**But the error persisted in the book.** Why?

Quarto's freeze cache (`tex.json`) stores the *fully resolved* chapter content,
including content from `{{< include >}}`'d files. When we subsequently updated
`latex/latex-commands.qmd` to use single-line definitions, the existing `tex.json`
files were **not invalidated** — because Quarto only tracks changes to the main `.qmd`
file, not to files it includes. The stale caches still embedded the old multi-line
`\providecommand{\ixd}` definitions.

The fix that finally worked required **both**:
1. Updating `latex-commands.qmd` to single-line definitions
2. Manually deleting all `tex.json` freeze caches:
   ```bash
   find .quarto/_freeze -name "tex.json" -delete
   ```

## Remaining Question

Given the above, would it be feasible for Quarto to track `{{< include >}}` file
dependencies when deciding whether to invalidate freeze cache entries? Currently,
any change to an included file is invisible to the freeze mechanism, requiring manual
cache deletion to take effect. This is a significant footgun, especially when included
files define content (like LaTeX macro definitions) that gets embedded in cached output.

I'll also note that the `parse-latex` filter — when it *was* running for PDF (in global
filters) — had an unexpected side effect: `pandoc.read()` calls within the filter share
pandoc's global macro table across invocations within the same pandoc process. A
`\newcommand`/`\providecommand` encountered in one `RawBlock` call is available for
expansion in subsequent `RawInline` calls. Whether this is a pandoc behavior worth
documenting (or guarding against in the filter) is a question for @tarleb.
