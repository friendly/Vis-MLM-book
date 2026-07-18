# Blog topic ideas — "The Making of Vis-MLM" series

Working list of candidate posts, collected from `memory/` and `issues/` notes on
the technical work Gavin (GK) and Michael did with Claude while producing the
book. Companion to the outline already published in
`friendly.github.io/blog/posts/2026-04-making-vis-mlm/index.qmd`, which lists
the series' planned scope; this file adds detail and new candidates the public
outline doesn't yet cover, drawn from the actual work logs.

## Already drafted in this folder

- **`blog-author-index.qmd`** — "Making an Author Index with Quarto." Covers
  the `authorindex` package/Perl-script pipeline, why pandoc citeproc breaks
  every step of it (no `\cite{}`, no BibTeX `.aux` infrastructure, `ref-`
  key prefixing, CRLF line endings), and the `\citeproc` redefinition that
  fixed a `\begingroup`/`\endgroup` deadlock inside footnote citations. This
  *is* the "author index disaster" stub from the public outline — just needs
  final review/polish, not new material.
- **`blog-quarto-indexes.qmd`** — "Creating Book Indexes in Quarto." Already
  linked from the public outline. Covers the `pkg()`/`dataset()`/`func()` R
  helpers, the `\ixp`/`\ixd`/`\ixfunc` LaTeX macros, and the underscore
  problem in function names like `stat_ellipse()`.

## New topic candidates

### 1. Part pages and chapter-opener diagrams — the DDAR bubble maps come back

Michael's previous book (DDAR) opened every part and chapter with a
mind-map-style "bubble diagram." Vis-MLM's part pages were plain title-only
and chapter openers had no diagram — this was added back for the PDF only,
with zero `.qmd` changes, via a TikZ + `\pretocmd` hook architecture.

The best story here is the **failed first attempt**: TikZ's built-in
`mindmap` library (the obvious tool for this) produces hairline seam
artifacts at every bubble junction — a long-standing `pgf` rendering quirk
where the connection bars are painted as multiple abutting subpaths. It
reproduced identically under xelatex/pdflatex, RGB/CMYK, and no style option
fixed it. The replacement — plain TikZ circle nodes at explicit polar
coordinates, single-path tapered shading bands, `pgf-blur` for soft shadows —
is a good "the fancy library isn't always the right tool" narrative, plus
concrete gotchas (unpadded chapter filenames like `chap4.pdf` vs `chap04.pdf`
failing silently; the section-list source-of-truth had to be the *built*
`.tex`, not the raw `.qmd`, because some headings are HTML-only/commented out).

*Source:* `memory/project_part_diagrams.md`, `memory/project_part_colors.md`,
`issues/GK-part-pages.md` (the full write-up — architecture, styling
iterations, print/CMYK transparency note, maintenance instructions).

### 2. Fixing citations: the doubled-parenthesis hunt

A systematic audit and fix of narrative citations mistakenly written as
`(@key)` instead of `[@key]` — rendering as doubled parens, e.g.
"(Costelloe (1915))" instead of "(Costelloe, 1915)." 25 instances found across
the book via a multi-pass grep (source `.qmd`, multiline citations, and a
final symptom-grep of the *rendered HTML* — which caught one case the source
grep missed: a hand-written Markdown link, not a `@` citation at all).

The sharper hook is what happened *after* the mechanical fixes: two of the
22 "corrected" citations broke again on rebuild, because `apa.csl` sorts
multi-key citation groups alphabetically by author, and a prose prefix
(`e.g.,`, `following`, `suggested by`) travels with whichever key it was
attached to in the source — not necessarily the one that sorts first. E.g.
`[e.g., @Peddle:1910; @Haskell:1919]` rendered as "(Haskell, 1919; e.g.,
Peddle, 1910)" because Haskell sorts first. Fix: reorder the keys in the
source to match the alphabetical render order. A good "verify the actual
rendered output, not just the diff" lesson.

*Source:* `issues/paren-citations.md` (full row-by-row table with categories
A–E and decisions), `issues/paren-citations-plan.md`, `memory/apa-csl-group-sorting.md`.

### 3. Auditing RGB vs CMYK for print

CRC Press requires the final PDF to use CMYK throughout, not RGB. Three
different layers needed three different fixes: R-generated figures
(`pdf.options(colormodel = "cmyk")` in `R/common.R`), LaTeX named colors
(`\usepackage[cmyk]{xcolor}`), and — the hard part — ~85 static raster images
under `images/`, most sourced externally (photos, historical diagrams) with
no colorspace control at all.

The interesting technical bit: rather than a whole-PDF Ghostscript recolor
pass, images are converted individually into a parallel `images-cmyk/`
directory via ImageMagick + the CRC-specified SWOP ICC profile, and a small
`img_path()` helper in `R/common.R` transparently resolves each
`include_graphics()` call to the CMYK version for PDF output and the RGB
original for HTML — so the same source line serves both formats with no
manual file-swapping. Before any conversion happened, an *effective-DPI*
audit script (pixel width ÷ actual printed size, not the usually-meaningless
embedded metadata DPI tag) found **69 of 85 images were below CRC's 300 dpi
minimum** at their printed size — a good example of "the metadata lies, measure
what actually matters." Verification closes the loop with Ghostscript's
`inkcov` device reporting per-page ink coverage.

A nice closing beat: while auditing low-DPI images, a two-decades-old title
typo was found riding along — the book's Hofstadter cover image (*Gödel,
Escher, Bach*) had been mis-titled "*Gödel, Bach and Escher*" everywhere in
the text, alongside the low-res image flag. Both were fixed in the same pass.

*Source:* `issues/CMYK-colors.md`, `issues/cmyk-conversion-plan.md`,
`issues/CMYK-checklist.md`, `issues/cmyk-image-audit.R` +
`cmyk-image-audit-results.csv`, `issues/email-CRC-cmyk.md` (CRC's actual
spec reply), `issues/Gavin-SummerWork.md` (Gavin's task framing),
`issues/GBE-to-GEB-switch.md` (the cover typo).

### 4. The mystery of the duplicated index entries

A `\write`-mechanism gotcha that's almost too small to believe: TeX inserts a
space after any control word ending in a letter, so `\ixp{car}` — meant to
write `\texttt{car}` to the `.idx` file — actually writes `\texttt  {car}`
(two spaces). Meanwhile a separate code path in `R/common.R` was writing
`\index{...\texttt{...}...}` directly (no macro, no extra space). `makeindex`
treats these as two *different* display strings and creates two separate
index entries for the same term — "car package" appearing twice in the
printed index, at different pages, with no visible reason why.

The first source-level fix (route everything through the `\ixp`/`\ixd`
macros) turned out **not sufficient on its own** — verified on a full clean
rebuild months later, the two-space vs. no-space duplicates were still there
for 10 terms. The actual fix requires a post-build normalization pass
(`--fix-index`) every single time: sed-collapse the two-space artifact in
`index.idx`, re-run `makeindex`, one final `xelatex -no-shell-escape` pass
(the `-no-shell-escape` matters — otherwise `imakeidx` re-invokes `makeindex`
and clobbers the fix). A good "the fix looked complete but wasn't" story,
and a nice companion/counterpoint to the `blog-quarto-indexes.qmd` draft.

*Source:* `memory/index_duplicates_fix.md`, `issues/duplicate-index-entries.md`,
`issues/dup-index.txt`.

### 5. Indexing a book with an AI pair, chapter by chapter

Less a bug-fix story, more a workflow/methodology one: rather than a single
sweep, the subject index was built up chapter by chapter in dedicated
sessions, with Claude proposing `\ix{}`/`\ixmain{}`/`\ixon{}`/`\ixoff{}` calls
for a chapter's key terms (statistical concepts, named methods, datasets) for
Michael to accept or reject — roughly 15–30 minutes per chapter. The `issues/subject-index.md`
work log is detailed enough to make a good post on its own: entry counts by
chapter before/after (Ch. 10 went from 1 manual entry to 39; Ch. 12 from 5 to
38), the five different approaches considered (skim the compiled PDF first,
chapter-by-chapter extraction, section-heading audit, a hand-picked key-term
concordance, cross-checking a comparable book's index), and the editorial
judgment calls (disambiguating two sections both titled "Example: Penguin
data"; deciding which terms are worth a `see`-style cross-reference).
Could pair naturally with a short aside on the Zipf-plot / index-density
visualizations Michael made *of* the index itself (`issues/index-plots.R`,
`issues/index-plots/*.png`) — a fun meta-visualization for a data-viz book.

*Source:* `issues/subject-index.md` (the full work log), `issues/index-plots.R`
and `issues/index-plots/` (entries-per-chapter, page-density, Zipf, top-terms
plots), `issues/GK-index-issues.md`.

### 6. Git conflicts in a book that commits its own PDF

A war story from merging a long-running feature branch (`part-pages-test`,
the diagrams work) back into `master`: 187 files in conflict, many "cannot
merge binary files" warnings for PDFs. Every single one turned out to be a
regenerated build artifact (knitr figure PDFs, `Vis-MLM.tex`, `docs/*.html`,
LaTeX aux files) — nothing hand-authored actually conflicted; both branches
had independently committed full rebuilds, so the artifacts diverged
byte-for-byte with no informational content worth reconciling. Resolution was
mechanical (`checkout --theirs` on the whole conflict set, then a full
rebuild from the merged sources) — but it exposes a design question worth
discussing on its own: should a book project track generated PDFs/HTML in git
at all, given they can't be meaningfully diffed or merged?

Bonus material in the same session: two `build.sh` portability bugs found
only by building on a second machine (macOS) — BSD `sed -i -e` silently
consumes `-e` as the backup-file suffix (GNU `sed` doesn't), and TinyTeX's
`makeindex`/`xelatex` binaries aren't on the default non-interactive-shell
PATH on the Mac the way they are on the Windows box. Both are one-line fixes,
but the kind that costs an afternoon to diagnose blind.

*Source:* `issues/index-part-pages-merge.md`.

## Notes for whoever drafts these

- Keep the "Down in the Weeds; TL;DR; Book-geek" tone the intro post
  establishes — these read well as detailed technical postmortems, not
  polished tutorials.
- Several of these share a common thread worth calling out explicitly across
  posts: **the freeze cache and "verify the actual rendered output, not just
  the source diff" lesson** recurs in #2 (apa.csl sorting), #4 (index fix
  looked complete but wasn't), and the already-drafted author-index post
  (footnote deadlock only showed up in specific citation contexts). Might be
  worth a short connecting post or a callout box repeated across all three.
- Topics #1 and #3 are the two Michael explicitly named as wanting to write
  up next (part pages, CMYK audit) — good candidates to draft first.
