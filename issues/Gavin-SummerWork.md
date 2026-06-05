# Gavin Summer Work

## Exercises

Extend the coverage of excercises  across chapters, in Appendix C, `31-exercises.qmd`.

See the notes in `working-text/exercise-ideas.md`

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
has been done for all figures generated from the text, but many of those under `images/` are still RGB.

I'm not sure if there are R tools or utilities to do this easily. It is only necessary to fix those
that are actually used in the book.

When I want to check this, I use Adobe Acrobat Pro tools (Print Production, ...) to generate a "pre-flight" report.
An old one is in `pdf\index_preflight_report.pdf`

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
