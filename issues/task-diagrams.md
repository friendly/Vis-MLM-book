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

The `smartdiagram` LaTeX package provides canned diagram styles from a list of
items. Via the knitr `tikz` engine (with `\usepackage{smartdiagram}` in
`extra.preamble`) it renders as PNG for HTML and as a native PDF graphic for PDF,
so **no conditional blocks are needed** — the tikz engine handles both formats.

Source: Fiandrino (2016), https://texdoc.org/serve/smartdiagram/0

### 3.1 Diagram types (10 total)

All invoked as `\smartdiagram[<type>]{item1, item2, ...}`.

| Type | Description | Good for |
|------|-------------|----------|
| `circular diagram` | Items around a circle, counter-clockwise | Iterative cycles |
| `circular diagram:clockwise` | Same, clockwise (no space before `:`) | Workflows (Kottwitz example) |
| `flow diagram` | Vertical pipeline with back-arrow | Analysis steps |
| `flow diagram:horizontal` | Horizontal pipeline with back-arrow | Chapter progression |
| `descriptive diagram` | Term + description pairs (circle + rounded box) | Method glossary |
| `priority descriptive diagram` | Items stacked on a vertical priority arrow | Method ranking by complexity |
| `bubble diagram` | **First item = large center bubble; rest overlap it** | Part + its chapters |
| `constellation diagram` | Center "planet" + "satellite" nodes, arrows from center out | Package ecosystem |
| `connected constellation diagram` | Like constellation but satellites also ring-connected | Method relationships |
| `sequence diagram` | Chevron-shaped items in a row | Layered dependencies |

**Note on bubble vs. constellation:** `bubble diagram` has the satellite bubbles
*overlapping* the center (translucent); `constellation diagram` keeps them
separate with connecting arrows. For showing chapters in a part, constellation
is usually cleaner. For a package ecosystem where overlap emphasises membership,
bubble works well.

**Descriptive diagram syntax** differs: items are `{Title, {Description text}}`:
```latex
\smartdiagram[descriptive diagram]{
  {EDA,   {Explore structure with plots and PCA}},
  {Model, {Fit a multivariate linear model}},
  {Infer, {Test hypotheses with MANOVA / HE plots}},
}
```

### 3.2 Setting options — `\smartdiagramset{...}`

Options are set globally before `\smartdiagram[...]`. Analogue of `\tikzset`.

#### General options (all diagram types)

| Option | Default | Notes |
|--------|---------|-------|
| `set color list={c1,c2,...}` | — | Custom color cycle |
| `uniform color list=color for N items` | — | One color for all N modules |
| `use predefined color list` | — | Reuse colors from a prior diagram |
| `insert decoration=style` | none | Decorate module borders (e.g. zigzag) |
| `arrow line width` | `0.1cm` | Connection arrow width |
| `arrow tip` | `stealth` | Arrow tip shape |
| `arrow style` | `<->` | Full arrow style string |
| `uniform arrow color` | `false` | Force one color for all arrows |
| `arrow color` | `gray` | Color when `uniform arrow color=true` |

#### Options for circular and flow diagrams

| Option | Default | Notes |
|--------|---------|-------|
| `module minimum width` | `2cm` | |
| `module minimum height` | `1cm` | |
| `module shape` | `rectangle,rounded corners` | Change to `diamond`, `ellipse`, etc. (load `shapes.geometric`) |
| `module x sep` | `2.75` | Horizontal distance factor (flow:horizontal) |
| `module y sep` | `1.65` | Vertical distance factor (flow) |
| `text width` | `1.75cm` | Text area inside each module |
| `font` | `\small` | Module label font |
| `border color` | `gray` | |
| `text color` | `black` | |
| `circular distance` | `2.75cm` | Radius of the circle |
| `back arrow disabled` | `false` | Set `true` to remove the return arrow |
| `back arrow distance` | `0.5` | Distance of back arrow from modules |
| `circular final arrow disabled` | `false` | Set `true` to break the cycle |

#### Options for bubble / constellation diagrams

| Option | Default | Notes |
|--------|---------|-------|
| `bubble center node size` | `4cm` | Center bubble minimum size |
| `bubble center node font` | `\large` | |
| `bubble center node color` | `lightgray!60` | |
| `distance center/other bubbles` | `0.8cm` | Gap between center and satellites |
| `bubble fill opacity` | `0.5` | Satellite translucency (bubble only) |
| `bubble node size` | `2.5cm` | Satellite bubble size |
| `bubble node font` | `\normalfont` | |
| `bubble text opacity` | `0.8` | |
| `planet size` | `2.5cm` | Center node (constellation only) |
| `planet color` | `lightgray!60` | |
| `planet font` | `\large` | |
| `satellite size` | `1.75cm` | |
| `satellite fill opacity` | `0.5` | |
| `distance planet-satellite` | `3.5cm` | Gap from center to satellites |
| `connection line width` | `0.1cm` | Arrow line width |
| `uniform connection color` | `false` | Constellation/connected only |
| `connection color` | `gray` | When uniform enabled |

#### Options for sequence diagram

| Option | Default | Notes |
|--------|---------|-------|
| `sequence item height` | `1cm` | |
| `sequence item width` | `2cm` | |
| `sequence item border color` | `gray` | |
| `sequence item font size` | `\normalfont` | |
| `sequence item text color` | `black` | |
| `uniform sequence color` | `false` | |
| `sequence item uniform color` | `gray!60!black` | Color when uniform enabled |

### 3.3 Book-specific diagram ideas and code

#### Bubble diagram: chapters in one book part

The first item is the center. Use `\\` for line breaks inside item names.
Works best with 4–6 satellites; more than 6 gets crowded.

```latex
% Part III: Univariate Linear Models (4 chapters — good bubble count)
\smartdiagramset{
  bubble center node size=3.5cm,
  bubble node size=2.2cm,
  uniform color list=teal!50 for 5 items,
  bubble fill opacity=0.4,
  bubble text opacity=0.9,
  font=\small,
}
\smartdiagram[bubble diagram]{
  Univariate\\ Linear\\ Models,
  Ch 6\\ Linear\\ Models,
  Ch 7\\ Model\\ Plots,
  Ch 8\\ LM Topics,
  Ch 9\\ Collinearity
}
```

#### Constellation diagram: chapters in a part (cleaner alternative)

Satellites are separate from the center — better when chapter names are longer.

```latex
% Part IV: Multivariate Linear Models (6 chapters)
\smartdiagramset{
  planet size=3cm,
  satellite size=2cm,
  distance planet-satellite=4cm,
  planet color=blue!30,
  uniform color list=blue!20 for 7 items,
  font=\small,
  planet font=\normalfont,
}
\smartdiagram[constellation diagram]{
  Multivariate\\ Linear Models,
  Ch 10\\ Hotelling,
  Ch 11\\ MLM Review,
  Ch 12\\ MLM Viz,
  Ch 13\\ Equal Cov,
  Ch 14\\ Influence,
  Ch 15\\ Case Studies
}
```

#### Connected constellation: method relationships

```latex
% heplots as hub connecting related packages
\smartdiagramset{
  planet color=orange!60,
  planet size=3cm,
  satellite size=2cm,
  distance planet-satellite=3.5cm,
  uniform color list=orange!30 for 6 items,
  font=\small,
}
\smartdiagram[connected constellation diagram]{
  heplots,
  car,
  candisc,
  ggplot2,
  MASS,
  broom
}
```

#### Sequence diagram: conceptual hierarchy

```latex
% Layered abstraction from data to insight
\smartdiagramset{
  uniform sequence color=true,
  sequence item uniform color=teal!60!black,
  sequence item border color=black,
  sequence item font size=\small,
  sequence item text color=white,
  sequence item width=2.5cm,
}
\smartdiagram[sequence diagram]{
  Raw data,
  EDA,
  LM / MLM,
  HE plots,
  Inference
}
```

#### Descriptive diagram: book parts with summaries

```latex
\smartdiagramset{
  set color list={blue!40, teal!40, green!40, orange!40},
  description title width=2.5cm,
  description title text width=2cm,
  description text width=6cm,
  font=\small,
}
\smartdiagram[descriptive diagram]{
  {Part I,   {Orienting ideas: data ellipses, visualisation principles}},
  {Part II,  {Exploratory: PCA, biplots, multivariate plots}},
  {Part III, {Univariate LM: model plots, collinearity, ridge}},
  {Part IV,  {Multivariate LM: MANOVA, HE plots, influence}},
}
```

### 3.4 Color tips

- Default color cycle is pastel (blue, red, orange, green, …) — fine for slides,
  may be too bright for a book. Use `uniform color list` for a monochromatic scheme.
- CRC books are typically printed in black-and-white internally; use high-contrast
  colors or patterns, or accept that diagrams appear as grayscale in print.
- Predefined colors can be reused across diagrams with `use predefined color list`.
- `bubble fill opacity=0.4` and `satellite fill opacity=0.4` lighten backgrounds
  so labels stay readable.

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
