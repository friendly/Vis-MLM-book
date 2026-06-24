# GK June 10-11 Issues

This document contains issues initially written in emails to MF on June 10 and 11.

## June 11 email

- Even numbered pages have uncoloured page numbers (while odd #s are coloured) [MF: FIXED by adding \color{partcol} to \PageNumFont in `latex/preamble.tex`; also fixed off-by-one color at part boundaries by patching `\@part` instead of `\part`]

- Do you want to colour div headings for examples (just checking; not sure this is necessary)? [MF: no]

- Do you want to colour “Package” headings at the beginning of each chapter? [MF: no]

- Headings specified with bold face (e.g., "Multivariate tests” on line 1411 of `11-mlm-review.qmd`) are not coloured. 
There are a few such headings in Ch11

- The “End Matter” retains the orange colouration from Part IV [MF: FIXED by adding case 5 (black) to `\ifcase` in `latex/preamble.tex`]

- I am wondering if the orange colour (Part IV) might be a bit too light [MF: FIXED using burnt orange]

- Should the author index have headings for each letter (like the subject index)? [MF: would be nice, but don't know how. Is there a .sty file for authorindex as there is for the main index?]
- Some figures in Ch04 (in `child/04-grand-tour.qmd`) have a bold “title” of sorts after “**Figure x.y**”
  + E.g., "**Figure 4.44: Variable vectors:**"
- Stray tick mark was on line 246 of `child/04-grand-tour.qmd` [*GK: FIXED*]

## June 10 email

- Pg. 411-412 of the PDF has a figure (`fig-rohwer-HE-mod1-pairs`) placed in the middle of a chunk of code. Also see the formatting of the code chunk on pg. 411 (lines 1465-1468 of `12-mlm-viz.qmd`).