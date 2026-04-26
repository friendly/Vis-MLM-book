# Task: Part-Level Color Themes

## Goal

Define one accent color per book part in a **single configurable location**, then
derive tint variants used consistently in chapter headings, callout boxes, smartdiagram
color lists, and any other themed elements.  No hardwired color values scattered
across individual chapters.

Current state: `index.qmd` smartdiagram hardwires
`color list={blue!35, teal!40, green!35, orange!40}` — this should reference symbolic
names instead.

---

## Part color assignments (provisional)

| Part | Topic | Base color |
|------|-------|------------|
| I  | Orienting Ideas   | `blue`   |
| II | Exploratory       | `teal`   |
| III| Univariate LM     | `green`  |
| IV | Multivariate LM   | `orange` |

---

## Prior art (.Rnw version of this book)

Three-part book used named colors in the preamble:

```latex
\colorlet{col1}{teal}    % Part I
\colorlet{col2}{olive}   % Part II
\colorlet{col3}{orange}  % Part III
```

At the start of each part's first chapter, tint variants were derived:

```latex
\colorlet{partcol0}{col1!80}
\colorlet{partcol1}{col1!50}
\colorlet{partcol2}{col1!20}
```

Then chapter headings, boxes, etc. referred to `partcol0`, `partcol1`, `partcol2`
rather than literal color names.

---

## Implementation plan

### PDF side (`latex/preamble.tex`)

Define the four base colors once:

```latex
% Part accent colors — change here to retheme the whole book
\colorlet{partI}{blue}
\colorlet{partII}{teal}
\colorlet{partIII}{green}
\colorlet{partIV}{orange}
```

At the start of each part (via `before-body.tex` or a `\part{}` hook), set the
active part color and derive tints:

```latex
\colorlet{partcol}  {partI}     % swap to partII / partIII / partIV per part
\colorlet{partcol80}{partI!80}
\colorlet{partcol50}{partI!50}
\colorlet{partcol20}{partI!20}
```

Use `partcol50` / `partcol20` in chapter title formatting, callout-box backgrounds,
table headers, etc.

**Where to set per-part color:**
Quarto inserts `\part{...}` calls from `_quarto.yml` `chapters:` structure.
One approach is a custom `before-part.tex` snippet (Quarto `include-before-body`
at the part level is not directly supported, but a LaTeX `\AtBeginPart` hook can
fire it):

```latex
% in preamble.tex
\usepackage{etoolbox}
\newcounter{partnum}
\AtBeginPart{%
  \stepcounter{partnum}%
  \ifnum\value{partnum}=1 \colorlet{partcol}{partI}\fi
  \ifnum\value{partnum}=2 \colorlet{partcol}{partII}\fi
  \ifnum\value{partnum}=3 \colorlet{partcol}{partIII}\fi
  \ifnum\value{partnum}=4 \colorlet{partcol}{partIV}\fi
  \colorlet{partcol80}{partcol!80}
  \colorlet{partcol50}{partcol!50}
  \colorlet{partcol20}{partcol!20}
}
```

### HTML side (SCSS)

Add to a custom SCSS file (e.g. `styles/theme.scss`, referenced from `_quarto.yml`):

```scss
// Part accent colors — change here to retheme the whole book
$part-I-color:   #4472C4;  // blue
$part-II-color:  #008080;  // teal
$part-III-color: #70AD47;  // green
$part-IV-color:  #ED7D31;  // orange
```

Callout boxes, header backgrounds etc. reference these variables.

**Problem:** HTML output has no concept of "which part am I in" at render time.
Options:
1. Use one SCSS color per chapter file via a custom `chapter-color` metadata field
   in each `.qmd`'s YAML header — then a Lua filter injects a CSS class.
2. Use part-colored callout/aside classes (e.g. `.callout-partI`) defined in SCSS,
   applied manually per chapter.
3. Accept that HTML theming is simpler (uniform color) and only apply per-part
   color in PDF.

### smartdiagram in `index.qmd`

Once the base colors are in `preamble.tex`, the `color list` in the tikz chunk
should reference them by name instead of literal values:

```latex
set color list={partI!35, partII!40, partIII!35, partIV!40},
```

This requires `preamble.tex` to be loaded before the tikz chunk fires, which it
is when building the full book PDF.  For standalone render of `index.qmd` only,
the `extra.preamble` knitr option would need to also define the named colors.

---

## Files to change

| File | Change |
|------|--------|
| `latex/preamble.tex` | Add `\colorlet{partI}` … `\colorlet{partIV}` + `\AtBeginPart` hook |
| `styles/theme.scss` (new or existing) | Add `$part-I-color` … SCSS variables |
| `_quarto.yml` | Reference SCSS file if not already |
| `index.qmd` tikz chunk | Replace literal colors with `partI!35` etc. |
| Each chapter `.qmd` (optional) | Add `chapter-color: partI` YAML for Lua filter approach |

---

## Next steps

- [ ] Add `\colorlet{partI}` … `\colorlet{partIV}` to `latex/preamble.tex` and test
      that a simple `\textcolor{partI}{text}` renders in a chapter
- [ ] Implement `\AtBeginPart` hook and verify colors switch at part boundaries in PDF
- [ ] Update `index.qmd` smartdiagram to reference named colors
- [ ] Decide on HTML strategy (uniform vs. per-chapter via Lua filter)
- [ ] Apply `partcol50` background to chapter-opening callout boxes (if any)

---

## Related files

- `latex/preamble.tex` — primary location for PDF color definitions
- `index.qmd` — smartdiagram currently hardwires the four colors
- `issues/task-diagrams.md` — smartdiagram usage and color tips
- `issues/task-chunk-visibility.md` — conditional HTML/PDF content patterns
