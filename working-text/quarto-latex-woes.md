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

## Workaround

I use `TeXStudio` to compile the `index.tex` file ...

