# Notes for the copyediting team — *Visualizing Multivariate Data and Models in R*

*Draft — 2026-07-10. To be finalized (page count, date) against the actual PDF sent.*

---

## 1. Status of the manuscript

This PDF represents the complete book: 15 chapters across four parts, front matter,
references, and both a subject index and an author index. [Confirm final page count
and chapter/reference/index page breakdown once the submission PDF is built —
see the June interim figures below for the shape of this.]

A few things worth knowing about where things stand:

- **No placeholder or TODO content remains visible in the text.** Author working notes
  (`<!-- TODO: ... -->`) exist in the source but are all HTML-comment-hidden and do not
  appear in this PDF.
  
- **A detailed chapter-by-chapter content review** (by me, along with a research assistant, covering
  the General Issues and Chapters 4–14, 21) has been incorporated: prose edits,
  typographic fixes, cross-reference repairs, code-formatting consistency.
  
- **Style consistency pass completed**: section headings use sentence case; dollar
  amounts, statistical symbols ($F$, $t$), and package/function name formatting have
  been made consistent throughout.
  
- **Structure**: *Case Studies* (formerly a print chapter) and *Exercises* are now
  online-only appendices; *Discriminant Analysis* (formerly an appendix) is now
  Chapter 15 in the print edition. An R Code Appendix (online-only) lists the source
  script for nearly every figure/analysis in the book.
  
- **A small number of additional minor prose/citation fixes are still being finalized**
  by my research assistant (a citation-formatting cleanup — some narrative citations
  render with doubled parentheses, e.g. "(Costelloe (1915))" instead of "(Costelloe,
  1915)" — and a few remaining image-resolution replacements, see below). None of these
  affect content or structure; I don't expect them to overlap with anything the
  copyeditor flags, but wanted to flag the timing.
  
- **Print image resolution/color**: all figures generated directly from the book's R
  code are already print-ready (CMYK, 300dpi+, vector where possible). A separate,
  independent pass is converting the ~90 externally-sourced diagrams/photos to CMYK at
  print resolution, per your production team's specifications (US Web Coated SWOP
  profile). **This is a color/resolution concern for printing only, not a content one** — please
  disregard image color/DPI when copyediting; it's being handled separately before
  final print files are generated.

## 2. Notes on working with this PDF

This book is authored in [Quarto](https://quarto.org) (R + Markdown) and compiled via
LaTeX to PDF — there is no underlying Word document. A few practical notes so markup
comes back in a form I can act on efficiently:

- **Please mark up directly on the PDF** (Adobe Acrobat comments — highlights, sticky
  notes, or inline text edits are all fine). I'll incorporate every change by hand into
  the source files and recompile; there's no "accept all changes" step on my end, so
  there's no need to worry about formatting a redline the way you might for a Word
  manuscript.
  
- **Page numbers will shift** between this PDF and the final typeset version (at minimum
  from the image-resolution pass above, possibly from other fixes). For anything that
  might need to be found again later, a chapter/section number or a nearby heading is
  more durable than a page reference — though for straightforward inline edits, an
  Acrobat comment anchored to the text itself doesn't need anything extra.
  
- **Figure/table/equation numbers, cross-references, citations, and both indexes are
  all generated automatically** from the source (not hand-numbered), so there's no need
  to check or renumber any of these — if something looks wrong (a miscitation, a
  duplicate-looking index entry, a cross-reference to the wrong figure), flagging it is
  all that's needed; I'll track down the cause in the source.
  
- **Code blocks and inline code** (anything in a monospace/shaded box, or
  `` `like this` `` in running text) are R syntax and case-/punctuation-sensitive —
  please don't apply house style (smart quotes, spacing, capitalization) to these; flag
  a suspected typo rather than correcting it directly, since a wrong correction there
  would break working code.
  
- **Numbered footnotes citing a URL are intentional, not an error.** In the online HTML
  edition, web links are inline clickable hyperlinks; obviously that doesn't work in
  print, so for the PDF each linked URL currently becomes a numbered footnote showing
  the address. That's the convention I've seen used in other books, so it's what I've
  defaulted to — but I'd welcome your guidance if CRC has a house style for this (e.g.
  URL spelled out in running text instead, a different footnote/endnote format, or
  something else entirely). Happy to adjust if the current approach isn't what you'd
  prefer.
  
- A few minor figure/layout items were already reviewed and consciously left as-is
  (e.g., some axis-label crowding in a couple of dense multi-panel figures) — if
  something looks like a rough edge rather than an error, it's likely one of these; no
  need to flag purely cosmetic figure-density issues.

Happy to adjust any of the above to fit how your team prefers to work — just let me know.
