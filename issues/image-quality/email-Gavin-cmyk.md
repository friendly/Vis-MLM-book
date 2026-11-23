Subject: Vis-MLM: RGB to CMYK conversion of images, next steps

Hi Gavin,

Thanks for all the work on the image resolution fixes. I've merged your dpi-fixes branch into master. I also ran an independent check of it, and all 64 images you marked as done now print at 317 dpi or better (or as vector PDFs). The four still below 300 dpi (datasaurus-dozen, iris-diagram, tesseract-frames, heatmap) are special cases we can come back to if there's time. I have no better copy of my author photo (MF-gray.jpg), so that one is accepted as is.

CRC's production team ran a preflight check on the manuscript. I've fixed the undefined glyphs, the non-embedded fonts and Fig. 7.17. The remaining item is "various figures use RGB color will need to be converted to CMYK", and I'd like you to take this on.

The good news is that it's a smaller job than it looked. I checked the October PDF: all the vector content (R figures, LaTeX colors, text) is already CMYK. The RGB that CRC flagged is just the 80 raster images from images/ (68 RGB, 11 palette PNGs, 1 ICC-tagged). So what's left is steps 5 to 7 of your July plan, with a few changes. The details are here:

https://github.com/friendly/Vis-MLM-book/blob/master/issues/image-quality/cmyk-next-steps.md

In short, the tasks are:

1. A conversion script in R (issues/image-quality/convert-images-cmyk.R) that converts the images used in the PDF into images-cmyk/, using the US Web Coated SWOP profile as in your plan. It should skip images that are already CMYK or grayscale, and be safe to re-run.

2. Commit images-cmyk/ to the repo, instead of adding it to .gitignore, so that any machine can build the print PDF without ImageMagick and the profile.

3. A small Quarto Lua filter for PDF output that swaps images/... for images-cmyk/... when a converted file exists, in place of rewriting the ~200 include_graphics() calls. There's a sketch in the notes; please test it on one chapter first. The two title-page images in latex/preamble.tex need to be pointed at images-cmyk/ by hand.

4. A side-by-side before/after contact sheet of the converted images, so I can check for colors that shift too much in SWOP (saturated blues, greens and purples are the usual suspects).

5. A full PDF build, then the acceptance test: pdfimages -list on the new PDF should show no rgb, index or icc images (apart from the cover). Please send me a summary.

6. Optional, if time allows: the low-DPI special cases. datasaurus-dozen could probably be redrawn in R from the datasauRus package.

I'll review the contact sheet and do the final build for CRC.

On Ghostscript: R/common.R now finds whatever version is installed (on PATH or under C:/Program Files/gs/), so 9.56 or 10.07 both work. If you need 10.07.1 on a machine where it's missing, just install it.

Background, if useful:

- Your July plan: https://github.com/friendly/Vis-MLM-book/blob/master/issues/image-quality/cmyk-conversion-plan.md
- Your checklist, updated with my check: https://github.com/friendly/Vis-MLM-book/blob/master/issues/image-quality/CMYK-checklist.md
- The script for my check: https://github.com/friendly/Vis-MLM-book/blob/master/issues/image-quality/verify-dpi-fixes.R
- CRC's preflight list and what I fixed: https://github.com/friendly/Vis-MLM-book/blob/master/production/copy-editing-note-11-19-2026.md

Thanks,
Michael
