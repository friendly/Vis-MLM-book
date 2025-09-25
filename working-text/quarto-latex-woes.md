# Quarto LaTeX Woes

The book is nearly done, but I still have unresolved problems compiling the PDF version.
I set `-interaction=nonstopmode` in my `_quarto.yml` and the first `quarto render` pass completes,
but fails in the second pass to resolve cross-references

```
    pdf-engine: xelatex
    pdf-engine-opts:
      - '-interaction=nonstopmode'
```

The `index.log` file ends with this, trying to produce the table of contents.

```

[11])
\tf@toc=\write6
\openout6 = `index.toc'.


! Undefined control sequence.
<argument> ...@edef \Hy@testname {\Hy@tocdestname 
                                                  }\ifx \Hy@testname \@empty...
l.531 \tableofcontents
                      
The control sequence at the end of the top line
of your error message was never \def'ed. If you have
misspelled it (e.g., `\hobx'), type `I' and the correct
spelling (e.g., `I\hbox'). Otherwise just continue,
and I'll forget about whatever was undefined.
```

Curiously, the output file, `index.pdf` **does** contain the table of contents, but nothing further is produced.

As well, when I use Build -> Render book -> All formats, in the HTML file that results, all of the section cross references
appear as the tags like `sec-anscombe` rather than `Section 1.1`.

## Workaround

I use `TeXStudio` to compile the `index.tex` file. This works, but it unnecessarily complicated.

## Index

I am unable to pass an argument to `makeindex` through my YML config. I tried:

```
    latex-makeindex: makeindex
    latex-makeindex-opts: ["-s", "latex/book.ist"]
 ```

I also tried:

```
    latex-makeindex-opts:
      - "-s latex/book.ist"
```

In both cases this produces an error, and the Quarto render stops.

I configured TeXStudio to use:

```
makeindex.exe -s latex/book.ist %.idx
```

and this works as intended

# Unresolved cross-references

[WARNING] Duplicate note reference 'control' at line 21215 column 1
WARNING (C:/Users/friendly/AppData/Local/Programs/Quarto/share/filters/main.lua:14000) Unable to resolve crossref @fig-tesseract
WARNING (C:/Users/friendly/AppData/Local/Programs/Quarto/share/filters/main.lua:14000) Unable to resolve crossref @fig-datasaurus
WARNING (C:/Users/friendly/AppData/Local/Programs/Quarto/share/filters/main.lua:14000) Unable to resolve crossref @sec-discoveries
WARNING (C:/Users/friendly/AppData/Local/Programs/Quarto/share/filters/main.lua:14000) Unable to resolve crossref @fig-pca-animation
WARNING (C:/Users/friendly/AppData/Local/Programs/Quarto/share/filters/main.lua:14000) Unable to resolve crossref @eq-S-eigen
WARNING (C:/Users/friendly/AppData/Local/Programs/Quarto/share/filters/main.lua:14000) Unable to resolve crossref @sec-discoveries
WARNING (C:/Users/friendly/AppData/Local/Programs/Quarto/share/filters/main.lua:14000) Unable to resolve crossref @fig-outlier-animation
WARNING (C:/Users/friendly/AppData/Local/Programs/Quarto/share/filters/main.lua:14000) Unable to resolve crossref @eq-glm
WARNING (C:/Users/friendly/AppData/Local/Programs/Quarto/share/filters/main.lua:14000) Unable to resolve crossref @eq-OLS-beta-var
WARNING (C:/Users/friendly/AppData/Local/Programs/Quarto/share/filters/main.lua:14000) Unable to resolve crossref @eq-ridge-beta-var
WARNING (C:/Users/friendly/AppData/Local/Programs/Quarto/share/filters/main.lua:14000) Unable to resolve crossref @eq-dfk
WARNING (C:/Users/friendly/AppData/Local/Programs/Quarto/share/filters/main.lua:14000) Unable to resolve crossref @eq-mlm-models
WARNING (C:/Users/friendly/AppData/Local/Programs/Quarto/share/filters/main.lua:14000) Unable to resolve crossref @eq-SSP
WARNING (C:/Users/friendly/AppData/Local/Programs/Quarto/share/filters/main.lua:14000) Unable to resolve crossref @eq-SSP
WARNING (C:/Users/friendly/AppData/Local/Programs/Quarto/share/filters/main.lua:14000) Unable to resolve crossref @eq-SSP
WARNING (C:/Users/friendly/AppData/Local/Programs/Quarto/share/filters/main.lua:14000) Unable to resolve crossref @eq-HE-model
