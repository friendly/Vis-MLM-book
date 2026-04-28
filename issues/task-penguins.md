# Keep `peng` or switch to `penguins`

In the book I used a cleaned-up version of the `palmerpenguins::penguins` dataset
to avoid messy variable labels, missing data, etc. The result, `peng` is now in
the `heplots` package.

However, another version is now available as `datasets::penguins`. It is similar to
`peng`, except that it contains  observations with NA that I deleted in `peng`.

What would it take to replace `peng` with `datasets::penguins`? It would involve
changing many source code files (in `R/penguin`) as well as many, many code chunks
and images in the book. Let's make an inventory of the changes and tools needed
without actually doing this yet.

---

## Inventory (2026-04-24)

### Structural differences

| Attribute | `peng` (heplots) | `datasets::penguins` |
|---|---|---|
| Source | `palmerpenguins::penguins` → renamed + cleaned | Base R (R ≥ 4.5), same underlying data |
| Rows | 333 (NAs dropped) | 344 (11 NAs in bill/flipper/body; 2 in sex) |
| Col 3 | `bill_length` | `bill_length_mm` |
| Col 4 | `bill_depth` | `bill_depth_mm` |
| Col 5 | `flipper_length` | `flipper_length_mm` |
| Col 6 | `body_mass` | `body_mass_g` |
| Col 7 | `sex` → `M`/`F` (factor) | `sex` → `male`/`female` (with NAs) |
| Col 8 | (absent) | `year` (int) |

Critically: columns 3–6 are at the **same positions**, so `peng[, 3:6]` positional indexing would still
land on the 4 numeric variables — but named differently.

---

### What needs changing

#### 1. Data loading (~42 R scripts in `R/penguin/`)
Every script does one of:
- `load("data/peng.RData")` — the most common pattern
- `library(heplots)` (which makes `peng` available)

All 42 scripts in `R/penguin/` would need the data source changed.

#### 2. Variable name references (pervasive across all 42 scripts + 11 QMDs)
Every bare name reference in formulas, ggplot aesthetics, axis labels, column selections:
- `bill_length` → `bill_length_mm`
- `bill_depth` → `bill_depth_mm`
- `flipper_length` → `flipper_length_mm`
- `body_mass` → `body_mass_g`
- `sex == "M"` / `"F"` → `"male"` / `"female"`

Quick count of formula-style occurrences (rough):
- `bill_length`: ~60+ hits across `R/` and `.qmd` files
- `bill_depth`: ~50+ hits
- `flipper_length`: ~30+ hits
- `body_mass`: ~30+ hits
- `sex "M"/"F"`: several hits

#### 3. NA handling (at every analysis step)
`peng` has no NAs so current code doesn't bother. Switching to `datasets::penguins` would require
adding `na.omit()` (or `|> drop_na()`) before:
- `lm()`, `manova()`, `lda()` calls
- `Mahalanobis()` / `cqplot()` calls (7+ sites using `peng[, 3:6]`)
- `scale()`, `prcomp()`, `covEllipses()` calls
- `xtabs()` / mosaic plot code (sex NAs affect tables)

#### 4. Positional index sites that depend on column count
The `year` column (col 8) doesn't shift the numeric block, but these sites need review:
- `peng[, -1]` in `penguins3d.R:23` — works only because col 1 is still `species`
- `peng[, c(1, 3:6)]` in `21-discrim.qmd:304` and `child/10-discrim.qmd:177` — still correct
- `peng[, c(3,4,6, 1)]` in `peng-3D-rgl.R:9` — still correct positions but named `_mm`/`_g`

#### 5. Saved derived data files
- `data/peng.RData` — needs regeneration
- `data/peng_tsne_2D.rds`, `data/peng_tsne_3D.rds` — derived from `peng`, need regeneration

#### 6. QMD narrative text (11 files)
Text that explicitly mentions `heplots::peng` and describes the cleaning rationale:
- `04-multivariate_plots.qmd` lines 1090–1096 — explains why `peng` was created from
  `palmerpenguins::penguins`; this narrative needs rewriting
- Axis/legend labels in plots that print variable names will change automatically but may need
  caption updates
- Figure cross-references (`@fig-peng-*`) don't need renaming, just data recomputation

#### 7. Figures that need regeneration
All figures in `figs/` derived from penguin data — essentially all of `figs/ch04/`, `figs/ch05/`,
`figs/ch11/`, `figs/ch13/`, `figs/ch14/`, and `figs/discrim/`. Axis labels will say
`bill_length_mm` instead of `bill_length` — probably fine (units visible), but all plots rerender.

Static images that won't auto-regenerate:
- `images/peng-simpsons.png` — manually maintained, needs manual redo

---

### Three strategic options

**Option A — Full replacement (high effort)**
Delete `data/peng.RData`, change `peng.R` to source `datasets::penguins`, rename all variable
references throughout. Requires touching ~42 R scripts, 11 QMDs, and regenerating all figures.
Many find-and-replace passes, plus manual NA-handling additions everywhere.

**Option B — Shim (low effort, recommended)**
Change only `peng.R` so it builds `peng` from `datasets::penguins` instead of
`palmerpenguins::penguins`, keeping the same rename + `drop_na()` pipeline. Rebuild
`data/peng.RData`. Update the narrative in `04-multivariate_plots.qmd` to credit
`datasets::penguins` as the source. **Zero other code changes needed.** The variable names,
column positions, sex coding, and NA-free guarantee all stay identical.

**Option C — Use `datasets::penguins` directly everywhere (highest effort)**
Like Option A but also removes the `peng` alias entirely. Every script becomes self-contained.
Most principled but most work.

---

### Tools needed

| Tool | Purpose |
|---|---|
| `sed` / `grep -r` + `Edit` | Bulk rename `bill_length` → `bill_length_mm` etc. (Options A/C only) |
| `Grep` | Audit all `peng[, 3:6]` positional sites before/after |
| Quarto render | Regenerate all figures after code changes |
| R session | Run `peng.R` to rebuild `data/peng.RData`; verify `str()` matches |

**Bottom line:** Option B (shim) requires changing 2 files — `R/penguin/peng.R` and a few sentences
in `04-multivariate_plots.qmd` — and rebuilding `data/peng.RData`. The result is that `peng` is
now sourced from `datasets::penguins` rather than `palmerpenguins::penguins`, with no downstream
breakage. Full Options A/C are feasible but touch hundreds of locations and require regenerating
most of the book's figures.

