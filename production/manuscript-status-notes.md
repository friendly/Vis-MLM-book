# Notes for the copyediting team — *Visualizing Multivariate Data and Models in R*

---

## What is included here

- Vis-MLM.pdf: The full PDF of the book, rendered 07/17/26.
- Notes for the copyeditor.doc: Answers to questions regarding copyedit preferences

## 1. Status of the manuscript

This PDF represents the complete book: 15 chapters across four parts, front matter,
references, and both a subject index and an author index. The total page count
is 548, which includes front matter (27 pg), main text (508 pg), subject index (8 pg), and author index (5 pg)
In the PDF everything is hyperlinked: references to figures, sections, equations, and the indexes back to
where those terms occur in the text.


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
  
<!--
- **A small number of additional minor prose/citation fixes are still being finalized**
  by my research assistant (a citation-formatting cleanup — some narrative citations
  render with doubled parentheses, e.g. "(Costelloe (1915))" instead of "(Costelloe,
  1915)" — and a few remaining image-resolution replacements, see below). None of these
  affect content or structure; I don't expect them to overlap with anything the
  copyeditor flags, but wanted to flag the timing.
-->
  
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
  
- **Page numbers will shift** between this PDF and the final typeset version. For anything that
  might need to be found again later, a chapter/section number or a nearby heading is
  more durable than a page reference. For straightforward inline edits, an
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
  
- **Hyperlinks in the print PDF, and a question on house style.** In the online HTML
  edition, every web link (inline text, citations, everything) is a clickable
  hyperlink. In the print PDF that obviously doesn't work the same way: a small number
  of URLs are deliberately set as numbered footnotes showing the address (that's
  intentional, not an error), but most inline links (e.g. "the [package
  documentation](...)") currently just render as plain text in print, with the
  underlying URL not shown anywhere on the page. I'd welcome your guidance on how CRC
  prefers to handle this — options I can think of include: converting all such links to
  footnotes showing the URL (used consistently, this could mean quite a few footnotes,
  since some URLs recur across chapters), spelling the URL out in running text instead,
  a different footnote/endnote convention, or simply leaving it as-is since the digital
  PDF itself remains clickable even though a printed page wouldn't be. Happy to
  implement whichever approach you prefer.
  
- A few minor **figure/layout** items were already reviewed and consciously left as-is
  (e.g., some axis-label crowding in a couple of dense multi-panel figures) — if
  something looks like a rough edge rather than an error, it's likely one of these; no
  need to flag purely cosmetic figure-density issues.

Happy to adjust any of the above to fit how your team prefers to work — just let me know.
