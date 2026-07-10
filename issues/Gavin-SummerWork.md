# Gavin Summer Work

## Exercises

Extend the coverage of excercises  across chapters, in Appendix C, `31-exercises.qmd`.

See the notes in `working-text/exercise-ideas.md`

**GK: Find my exercise ideas in the mentioned file under "GK:" in each chapter (** `working-text/exercise-ideas.md`**).**

## R code appendix

Add comments indicating the source file for analyses / graphs like `<!-- fig.code: R/Davis-reg.R -->`
for as many more as can be found. Not necessary to find them all; just the ones not listed that
would be helpful to a reader.

These are used by the script `issues/make-rcode-appendix.R` to
create `30-Rcode.qmd`. 

So, that script has to be re-run when changes are made in the chapter files.
TODO: Perhaps update the ./build.sh script to re-run when necessary?

Work on this is summarized in `issues/figcode-gaps.md` (but hasn't been updated)
A lot of my R scripts are messy, because I was trying out alternatives and choosing one that 
worked best for the text.

For every `R/` script added, check that the file begins with a YML `title:` block, used
in the `make-rcode-appendix` script.

## RGB -> CMYK

The final version of the book must use the CMYK rather than RGB color encoding for printing. This
has been done for all figures generated from the text (R figures, LaTeX vector colors), but the
static images under `images/` are still RGB — see `issues/CMYK-colors.md` for full status and
`issues/cmyk-conversion-plan.md` for the conversion plan. CRC confirmed (2026-07-10, in
`issues/email-CRC-cmyk.md`): ICC profile = US Web Coated SWOP, PNG/JPG format is fine (no TIFF),
minimum 300 dpi.

**Your task:** `issues/cmyk-image-audit.R` audited every raster image actually used in the PDF
(85 total) and estimated each one's *effective* print DPI — pixel width divided by how large it's
actually printed in the book, not the (usually meaningless) embedded metadata DPI tag. Results are
in `issues/cmyk-image-audit-results.csv`. **69 of the 85 are flagged `LOW-DPI`** (effective dpi
under 300 at the size they're printed).

For each `LOW-DPI` row, please check whether a higher-resolution original exists (original photo,
a vector/PDF version, a bigger export from whatever tool made the diagram, a higher-res download of
a historical figure, etc.). Where one exists, replace the file in `images/` with it (same filename,
or note the new filename + which `.qmd` to update). Where no better source exists, just flag it —
those will need a size-in-the-book decision (shrinking `out-width`) or a note to CRC accepting the
resolution.

Once a higher-res source is in place (or a `LOW-DPI` image is otherwise resolved), the actual
RGB→CMYK colorspace conversion is a separate, already-scripted step (ImageMagick + the SWOP
profile, into a parallel `images-cmyk/` directory) — no need to do that part by hand.

When I want to check the final PDF's color spaces, I use Adobe Acrobat Pro tools (Print Production, ...) to generate a "pre-flight" report.
An old one is in `pdf\index_preflight_report.pdf`. Ghostscript (now installed) can also report ink
coverage per page: `gswin64c -dBATCH -dNOPAUSE -sDEVICE=inkcov pdf/Vis-MLM.pdf`.

## Indexing

My subject index, for terms not added automatically, uses `\ix{}`, `\ixon{}`, `ixoff{}` and other LaTeX macros sprinkled throughout
the text. But not all of the text has been so marked.

It will take a pass through the book to identify further terms and concepts that need indexing. This is a bit tricky, because `makeindex` 
treats terms as different unless they match exactly.

It might be a good task for Claude to identify sections with little index coverage, but this is mainly a task for a human.
Google: "what are some requirements for a good subject index for an academic book" to for guidance.

In the DDAR book, I used `\usepackage{showidx}` to have LaTeX create marginal notes in the PDF for every index entry, so
I could see them in context. Not sure this will work with the current setup. For DDAR, I simply uncommented that line
in the `book.Rnw` file, and saved the result separately to `book-index.pdf` 

## Other topics

* What could make the book even better? Some things for this release were summarized in `issues/Tasks-Issues.md`, but some
things could still be done.

* `issues/task-code-simpification.md` describes ideas for possibly simplifying the code examples
