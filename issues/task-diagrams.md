# Task: Conceptual Diagrams — Mermaid, TikZ, smartdiagram

## Goal

Add conceptual / explanatory diagrams to the book to clarify statistical ideas,
analysis workflows, and relationships among methods. Three main toolchains are
viable in a Quarto + HTML/PDF project:

| Tool | Syntax | HTML | PDF | Effort |
|------|--------|------|-----|--------|
| Mermaid | fenced code block | SVG (built-in) | PNG via knitr | low |
| TikZ | LaTeX / knitr engine | PNG via knitr | native | medium |
| smartdiagram | LaTeX package | PNG via knitr | native | medium |

---

## 1. Mermaid

Quarto renders Mermaid natively to SVG in HTML. For PDF, the `mermaid` chunk
engine is **not** supported by knitr/LaTeX, so diagrams need to be either:

- Wrapped in `::: {.content-visible when-format="html"}` (HTML only), or
- Pre-rendered to PNG and included as a static image for PDF.

### 1a. Quarto built-in (HTML only)

````markdown
```{mermaid}
flowchart LR
  A[Multivariate data] --> B{Goals?}
  B --> C[Explore structure\nPCA / Biplot]
  B --> D[Test group differences\nMANOVA / HE plots]
  B --> E[Classify observations\nLDA / QDA]
```
````

### 1b. HTML + PDF together (static fallback)

Pre-render the Mermaid diagram with the `mmdc` CLI tool or the **DiagrammeR**
package and save as PNG, then include conditionally:

````markdown
::: {.content-visible when-format="html"}
```{mermaid}
%%| fig-cap: "Analysis workflow"
flowchart LR
  ...
```
:::

::: {.content-visible when-format="pdf"}
![Analysis workflow](figs/diagrams/workflow.png)
:::
````

### Book-relevant Mermaid diagram ideas

- **Method-selection flowchart** — one response vs. many → regression vs. MLM
- **Chapter dependency map** — which chapters build on which (reader guide)
- **HE plot concept** — H ellipse vs. E ellipse interpretation flow
- **PCA decision tree** — standardize? how many components?
- **Discriminant analysis pipeline** — LDA → canonical scores → classification rule

### Example: method-selection flowchart

````markdown
```{mermaid}
flowchart TD
  A([Start]) --> B{How many\nresponse variables?}
  B -->|one| C[Linear model\nCh 6–9]
  B -->|many| D{Inferential\nor exploratory?}
  D -->|inferential| E[MANOVA / MLM\nCh 10–14]
  D -->|exploratory| F{Relationships\nor grouping?}
  F -->|relationships| G[PCA / Biplot\nCh 5]
  F -->|grouping| H[LDA / Discriminant\nCh 21]
```
````

---

## 2. TikZ

TikZ is the gold standard for publication-quality diagrams in LaTeX. In Quarto,
use the **knitr `tikz` chunk engine** — knitr calls LaTeX, captures the output
as PDF, and converts it to PNG (HTML) or embeds it directly (PDF).

### Setup

In `_quarto.yml` or a setup chunk, ensure `tikzDevice` or the external
LaTeX-based PNG conversion is available:

````r
# In a setup chunk (runs once)
knitr::opts_chunk$set(
  engine.opts = list(tikz = list(extra.preamble = c(
    "\\usepackage{tikz}",
    "\\usetikzlibrary{arrows.meta,positioning,shapes.geometric,fit}"
  )))
)
````

### Basic usage

````markdown
```{tikz, fig.cap="HE plot geometry", out.width="70%"}
\usetikzlibrary{arrows.meta, positioning}
\begin{tikzpicture}[>=Latex, node distance=2cm]
  \node[ellipse, draw, minimum width=3cm, minimum height=1.5cm,
        label=above:$\mathbf{H}$ (hypothesis)] (H) {};
  \node[ellipse, draw, dashed, minimum width=1.5cm, minimum height=0.8cm,
        right=1.5cm of H, label=above:$\mathbf{E}$ (error)] (E) {};
  \draw[->] (H) -- node[above]{$F > 1$?} (E);
\end{tikzpicture}
```
````

### Book-relevant TikZ diagram ideas

- **Ellipse geometry** — data ellipse as 1 SD contour, Mahalanobis distance
- **HE plot logic** — H vs. E ellipse, effect size as ratio
- **MLM model diagram** — $\mathbf{Y} = \mathbf{X}\mathbf{B} + \mathbf{E}$ as
  matrix block diagram
- **Canonical correlation** — two variable sets, canonical variates as bridges
- **Influence diagram** — leverage, residual, influence as geometry in hat-matrix space
- **Covariance structure** — compound symmetry vs. AR(1) vs. unstructured as matrix heat maps
- **Variable taxonomy** — predictors, responses, covariates shown as set diagram

### Example: MLM matrix diagram

````markdown
```{tikz, fig.cap="MLM as matrix equation"}
\usetikzlibrary{matrix, positioning}
\begin{tikzpicture}
  \matrix (Y) [matrix of math nodes, left delimiter={[}, right delimiter={]}] {
    y_{11} & y_{12} \\ y_{21} & y_{22} \\ y_{31} & y_{32} \\
  };
  \node[right=0.3cm of Y] {$=$};
  \matrix (X) [matrix of math nodes, right=0.6cm of Y,
               left delimiter={[}, right delimiter={]}] {
    1 & x_{11} \\ 1 & x_{21} \\ 1 & x_{31} \\
  };
  \matrix (B) [matrix of math nodes, right=0.3cm of X,
               left delimiter={[}, right delimiter={]}] {
    \beta_{01} & \beta_{02} \\ \beta_{11} & \beta_{12} \\
  };
  \node[right=0.3cm of B] {$+\;\mathbf{E}$};
  \node[below=0.2cm of Y] {$\mathbf{Y}_{n \times p}$};
  \node[below=0.2cm of X] {$\mathbf{X}_{n \times q}$};
  \node[below=0.2cm of B] {$\mathbf{B}_{q \times p}$};
\end{tikzpicture}
```
````

### Potential snag: PDF-to-PNG conversion

The `tikz` engine calls a standalone LaTeX process. On Windows with TinyTeX,
check that `pdfcrop` and `ghostscript` (or ImageMagick `convert`) are on the
PATH — knitr uses them to trim and rasterize the output PNG. Test with a
minimal chunk first.

---

## 3. smartdiagram

The `smartdiagram` LaTeX package provides canned diagram styles (flow, cycle,
bubble, priority, constellation, connected) with minimal code. Works only in
PDF natively; same knitr tikz/LaTeX-engine workaround applies for HTML.

### Usage in Quarto

The safest approach is a raw LaTeX block for PDF + static PNG fallback for HTML
(same conditional pattern as Mermaid above).

````markdown
::: {.content-visible when-format="pdf"}
```{=latex}
\usepackage{smartdiagram}   % or put in preamble.tex
\begin{center}
\smartdiagram[flow diagram:horizontal]{
  Multivariate data,
  Explore (PCA),
  Model (MLM),
  Visualize (HE plots),
  Interpret
}
\end{center}
```
:::
````

Or use the `tikz` chunk engine with `\usepackage{smartdiagram}` in the preamble.

### smartdiagram styles relevant to this book

| Style | Book use |
|-------|----------|
| `flow diagram` | Analysis pipeline steps |
| `circular diagram` | Iterative modelling cycle |
| `bubble diagram` | Package ecosystem (heplots, candisc, …) |
| `priority descriptive diagram` | Parts of the book / reading order |
| `constellation diagram` | Relationships among methods |

### Example: circular analysis cycle

````markdown
```{=latex}
\smartdiagram[circular diagram:clockwise]{
  Data collection,
  EDA \& plots,
  Model fitting,
  Diagnostics,
  Visualization,
  Inference
}
```
````

---

## 4. Recommendation / approach

1. **Use Mermaid first** for flowcharts and decision trees — zero extra
   dependencies, renders natively in HTML, easy to edit. Accept HTML-only
   rendering for now; add PNG fallback for PDF in a later pass.

2. **Use TikZ** for geometry-based diagrams (ellipses, matrix equations,
   coordinate diagrams) where precision matters and the diagram appears in print.
   Test the knitr `tikz` engine with a minimal example before committing to it
   throughout.

3. **Use smartdiagram sparingly** for "pretty" process/cycle diagrams in PDF;
   wrap in `{.content-visible when-format="pdf"}` since there is no HTML renderer.

4. **Store pre-rendered PNGs** in `figs/diagrams/` for any diagram used as a
   static fallback.

---

## 5. Next steps

- [ ] Test Mermaid flowchart in a chapter (e.g., method-selection diagram for
      Chapter 2 intro or Chapter 10 Hotelling)
- [ ] Test knitr `tikz` engine on this machine (check `pdfcrop` / ImageMagick
      availability)
- [ ] Draft HE-plot geometry diagram in TikZ
- [ ] Draft MLM matrix-equation diagram in TikZ
- [ ] Add `\usepackage{smartdiagram}` to `latex/preamble.tex` and test circular
      analysis-cycle diagram
- [ ] Decide on HTML fallback strategy: conditional blocks vs. pre-rendered PNGs

---

## Related files

- `latex/preamble.tex` — add TikZ `\usetikzlibrary` and `\usepackage{smartdiagram}` here
- `R/common.R` — could add a helper to include diagrams conditionally
- `issues/conditional-content.md` — conditional HTML/PDF block patterns
- `_quarto.yml` — knitr engine options if global setup is needed
