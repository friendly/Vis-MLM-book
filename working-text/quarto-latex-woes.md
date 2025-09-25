# Quarto LaTeX Woes

The book is nearly done, but I still have unresolved problems compiling the PDF version.

The first thing is that when I use `Build -> Render book -> PDF format`, all the `docs/*.html` files are deleted
along with the `.png` images under `docs/`


## LaTeX errors

I set `-interaction=nonstopmode` in my `_quarto.yml` and the first `quarto render` pass completes,
but fails in the second pass to resolve cross-references.
I'm using this in my `_quarto.yml` file, which is supposed to continue after an error.

```
    pdf-engine: xelatex
    pdf-engine-opts:
      - '-interaction=nonstopmode'
```

The `index.log` file ends with the error below, trying to produce the table of contents:

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

As well, when I use `Build -> Render book -> All formats`, in the HTML file that results, all of the **section cross references**
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

and this works as intended.

# Unresolved cross-references in aligned equations

Aligned equations, using equation labels, like: `\begin{align*} equation \end{align}{#eq-glm}` work in HTML, _but not in PDF_.
That is, they generate equation numbers which can be cross-referenced in HTML, but generate warnings in PDF and the cross-refs
print as `?@eq-glm`.

An example is:

```
\begin{align*}
\mathbf{y} & = \beta_0 + \beta_1 \mathbf{x}_1 + \beta_2 \mathbf{x}_2 + \cdots + \beta_p \mathbf{x}_p + \mathbf{\epsilon} \\
           & = \left[ \mathbf{1},\; \mathbf{x}_1,\; \mathbf{x}_2,\; \dots ,\; \mathbf{x}_p \right] \; \boldsymbol{\beta} + \boldsymbol{\epsilon} \\
\end{align*} {#eq-glm}
```


The warnings look like this:
```
WARNING (C:/Users/friendly/AppData/Local/Programs/Quarto/share/filters/main.lua:14000) Unable to resolve crossref @eq-glm
WARNING (C:/Users/friendly/AppData/Local/Programs/Quarto/share/filters/main.lua:14000) Unable to resolve crossref @eq-OLS-beta-var
WARNING (C:/Users/friendly/AppData/Local/Programs/Quarto/share/filters/main.lua:14000) Unable to resolve crossref @eq-ridge-beta-var
WARNING (C:/Users/friendly/AppData/Local/Programs/Quarto/share/filters/main.lua:14000) Unable to resolve crossref @eq-dfk
WARNING (C:/Users/friendly/AppData/Local/Programs/Quarto/share/filters/main.lua:14000) Unable to resolve crossref @eq-mlm-models
WARNING (C:/Users/friendly/AppData/Local/Programs/Quarto/share/filters/main.lua:14000) Unable to resolve crossref @eq-SSP
WARNING (C:/Users/friendly/AppData/Local/Programs/Quarto/share/filters/main.lua:14000) Unable to resolve crossref @eq-SSP
WARNING (C:/Users/friendly/AppData/Local/Programs/Quarto/share/filters/main.lua:14000) Unable to resolve crossref @eq-SSP
WARNING (C:/Users/friendly/AppData/Local/Programs/Quarto/share/filters/main.lua:14000) Unable to resolve crossref @eq-HE-model
```

## Figure sizes

I use chunk options `fig-height`, `fig-width` to control the size and shape of figures and then `out-width` to control the overall size.