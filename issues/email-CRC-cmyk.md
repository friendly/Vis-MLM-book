# Email to CRC Press: Image color model requirements

**To:** [CRC/Chapman & Hall production editor]
**From:** friendly@yorku.ca
**Subject:** Image color space requirements for "Visualizing Multivariate Data and Models in R"

---

Dear [Name],

I am preparing the final manuscript for *Visualizing Multivariate Data and Models in R*
and have a few questions about the details of your CMYK requirements.

For context on what is already in CMYK: all R-generated chapter figures are produced
using `grDevices::pdf.options(colormodel = "cmyk")`, and the book's part accent colors
are specified in CMYK via `\usepackage[cmyk]{xcolor}`. I believe both of these are
sufficient on their end.

The remaining concern is 91 external raster images (JPG and PNG) referenced in the
book that are currently in sRGB. These include statistical diagrams as well as a small
number of photographs and scanned historical figures.

**My questions:**

* Which ICC profile should I use for the RGB→CMYK conversion?
  (e.g., Coated FOGRA39, US Web Coated SWOP, or do you have a house profile?)

* Is there a preferred raster format for submission — e.g., TIFF rather than PNG?

* Is there a minimum DPI requirement? Current images range from 96–300 dpi
  depending on source.

Happy to provide any additional information. Thank you for your help.

Best regards,
Michael Friendly
York University

---

*Drafted 2026-07-04. Waiting for reply before doing any bulk RGB→CMYK conversion.*

---

## Reply received (2026-07-10)

From Shashi (CRC Press production):

> * Which ICC profile should I use for the RGB→CMYK conversion? — **US Web
>   Coated SWOP**
> * Is there a preferred raster format for submission — e.g., TIFF rather
>   than PNG? — **png, jpg**
> * Is there a minimum DPI requirement? — **300dpi**

All three questions answered — no TIFF conversion needed, format stays
PNG/JPG. See `issues/cmyk-conversion-plan.md` for the implementation plan.
