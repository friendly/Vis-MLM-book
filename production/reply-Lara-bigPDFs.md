# Email to Lara: the print PDF has grown large

Draft, 2026-11-27. Background notes for me follow the email.

---

**Subject:** Vis-MLM: file size of the revised PDF, and the image resolution you need

Dear Lara,

Gavin has now converted the book's figures to CMYK, using the US Web Coated (SWOP) v2
profile, and has replaced the low-resolution images. Apart from the cover, every image in
the PDF is now CMYK or grayscale, and all fonts are embedded.

As a result, the PDF has grown from about 39 MB to about 73 MB. Nearly all of the
increase comes from the images. Many are now at 800–1300 ppi at their printed size, well
above what print needs. Before I send the revised PDF, I have a few questions:

1. **Resolution.** What effective resolution should images be at their printed size? If
   300 ppi (or perhaps 400 ppi for line art and screenshots) is enough, I can downsample the
   larger images, which should bring the PDF back to roughly its old size.

2. **Delivery.** Is there a maximum file size for what you receive, and how would you like
   large files sent? It is too big to email. I could share a download link (OneDrive or
   Dropbox) or upload to a Taylor & Francis file-transfer site, whichever you prefer.

3. **Separate figure files.** Will the production team also want the figures as separate
   files, or is the PDF alone enough?

4. **The cover.** The cover image is still RGB. Will your team produce the cover, or
   should we supply a CMYK version?

Best wishes,
Michael

---

## Notes for me (not part of the email)

**Why the PDF grew.** `pdfimages -list pdf/Vis-MLM.pdf` (after PR #61): 84 images, about
74 MB of image data in total. 66 of them are above 450 ppi at their printed size, and these
make up about 68 MB. The largest are at 800–1350 ppi; the biggest single image is
10.7 MB. When Gavin raised the resolutions (dpi-fixes) he went well past 300 ppi. The CMYK
step then wrapped the converted PNGs losslessly in PDF, which kept them at full size.

**What it means for my work, until Lara answers:**

- **Git repo growth.** `docs/Vis-MLM.pdf` and `pdf/Vis-MLM.pdf` are each about 73 MB. GitHub
  warns over 50 MB and rejects files over 100 MB. Every rebuild I commit adds two more
  full-size copies to the history, so the clone keeps getting bigger. Options:
  - Commit `pdf/Vis-MLM.pdf` only for versions actually sent to CRC, not on every rebuild.
  - Decide whether the online site needs the full print PDF at `docs/Vis-MLM.pdf`. A
    smaller screen-resolution copy would do for readers.
  - Git LFS for the PDFs: possible, but GitHub's free LFS allowance is limited, and
    GitHub Pages does not serve LFS files.
- **Downsampling, once Lara gives a target ppi.** This is the main fix. Best done at the
  source: add a target-ppi step to `issues/image-quality/convert-images-cmyk.R`, based on
  each image's printed width, so `images-cmyk/` holds right-sized copies. Downsampling the
  finished PDF with Ghostscript is quicker but riskier: it may re-encode or colour-convert
  the CMYK images. If I try it, re-run the CRC preflight checks afterwards (pdfimages,
  pdffonts).
- **Images in the repo.** The originals in `images/` stay at high resolution, which is fine
  for the HTML version and for reprints; only the print copies in `images-cmyk/` need to
  shrink. `images-cmyk/` is about 66 MB now.
- **Sending the PDF.** Until we know Lara's preferred route, plan on a share link, not an
  email attachment.
