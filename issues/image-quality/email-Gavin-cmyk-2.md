Subject: Re: Vis-MLM: RGB to CMYK conversion of images, next steps

Hi Gavin,

This looks very good. The conversion is correct (SWOP v2, full resolution, PNGs wrapped as PDF, neutral images sent to grayscale), and the contact sheet makes the review easy. The colour shifts are what SWOP always does to saturated violets, blues and reds (iris-diagram, corrgram, inverse are the most visible), and I'm happy to accept them.

To save you a step, I've done two of the remaining pieces on master:

- The Lua filter is in filters/cmyk-images.lua and wired into _quarto.yml (format: pdf: filters:). For PDF output it swaps each image for its images-cmyk/ copy: .jpg stays .jpg, .png becomes your .pdf wrapper (or the grayscale .png), and figs/ch04/fig-peng-ggpairs1-1.png is covered too. Anything without a CMYK copy falls back to the RGB original, and HTML is never touched. I tested it on a small document with all the ways the book includes images.
  https://github.com/friendly/Vis-MLM-book/blob/master/filters/cmyk-images.lua

- The two title-page images in latex/preamble.tex turn out to be the vector part/chapter diagrams (figs/diagrams/*.pdf). They have no raster images and no RGB, so there's nothing to do there.

What's left for you, on the convert-CMYK branch:

1. Merge master into convert-CMYK, to pick up the filter.
2. Do a full PDF build.
3. Check that:
   - pdfimages -list on the new PDF shows no rgb, index or icc images (except the cover);
   - the .log has no "Missing character" lines;
   - pdffonts shows all fonts embedded.

Once that passes, open a PR from convert-CMYK with the pdfimages summary, and I'll review and merge.

Updated notes: https://github.com/friendly/Vis-MLM-book/blob/master/issues/image-quality/cmyk-next-steps.md

Thanks,
Michael
