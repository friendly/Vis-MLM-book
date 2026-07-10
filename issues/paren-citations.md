# Review: Parenthesized Narrative Citations `(@key)` → `[@key]`

**Stage 1 inventory, generated 2026-07-09.** See `issues/paren-citations-plan.md` for
background and method. **No book text has been edited yet.**

These are citations written as a bare narrative citation wrapped in literal parentheses,
which render doubled, e.g. "(Costelloe (1915))" instead of "(Costelloe, 1915)".

**Detection:** single-line grep over all `*.qmd`, `child/*.qmd`, `summary/*.qmd`
(excluding `@fig-`/`@sec-`/`@exm-` etc. cross-refs); a multiline pass for citations
spanning line breaks (zero hits); and a symptom grep of rendered `docs/*.html` for
"(Author (Year))" patterns. The HTML pass found one extra case the source grep could
not (row 11 — a hand-written markdown link, not a `@` citation). Every doubled citation
in the rendered HTML maps to a row below.

## For reviewers (GK / Michael)

Fill in the **Decision** column for each row:
- `OK` — apply the proposed fix as shown
- `skip` — leave the text as is
- or write your own replacement text

Categories: **A** = mechanical `(@key)` → `[@key]` · **B** = prefix (e.g., "e.g.,",
"following", "suggested by") moves inside the brackets · **C** = multi-cite, separator
must also change to `;` · **D** = judgment call, prose inside the parens · **E** =
intentional narrative use, recommend leaving as is.

When done, give Claude the go-ahead to run Stage 2 (fixes applied only per the
Decision column, on a dedicated branch).

## Instances in files that are part of the build

| # | File:line | Current source (snippet) | Proposed fix | Cat. | Decision |
|---|-----------|--------------------------|--------------|------|----------|
| 1 | `index.qmd:362` | `previous books (@FriendlyMeyer:2016:DDAR).` | `previous books [@FriendlyMeyer:2016:DDAR].` | A | OK |
| 2 | `01-Prelude.qmd:52` | `textbooks (e.g., @Peddle:1910; @Haskell:1919)` | `textbooks [e.g., @Peddle:1910; @Haskell:1919]` | B |  |
| 3 | `01-Prelude.qmd:52` | `college courses (@Costelloe:1915).` | `college courses [@Costelloe:1915].` | A | OK |
| 4 | `03-getting_started.qmd:26` | `"sparklines" (@Tufte:83), tiny versions` — in footnote `[^tables]` | `"sparklines" [@Tufte:83], tiny versions` | A | OK |
| 5 | `04-multivariate_plots.qmd:341` | `the GLIM program (@Nelder1974glim), which` | `the GLIM program [@Nelder1974glim], which` | A | OK |
| 6 | `04-multivariate_plots.qmd:343` | `generalized linear models (@NelderWedderburn1972GLM) as natural extensions` | `generalized linear models [@NelderWedderburn1972GLM] as natural extensions` | A | OK |
| 7 | `04-multivariate_plots.qmd:355` | `The "S Book" (@ChambersHastie1991) laid out` | `The "S Book" [@ChambersHastie1991] laid out` | A | OK |
| 8 | `04-multivariate_plots.qmd:385` | `_Grammar of Graphics_ (@Wilkinson:99).` | `_Grammar of Graphics_ [@Wilkinson:99].` | A | OK |
| 9 | `04-multivariate_plots.qmd:938` | `(the @PineoPorter2008 prestige score for an occupational category, derived from a social survey)` | **Leave as is** — citation used as a noun ("the Pineo & Porter (2008) prestige score") inside a parenthetical remark; narrative form is intended | E | skip |
| 10 | `04-multivariate_plots.qmd:2652` | `(following @VanderPlas2023), we reorder` | `[following @VanderPlas2023], we reorder` | B | |
| 11 | `04-multivariate_plots.qmd:3342` | `In this figure (taken from [Rodrigues (2021)](https://bit.ly/3A6kvq5)),` — hand-written link, not a `@` citation | `In this figure (taken from [Rodrigues, 2021](https://bit.ly/3A6kvq5)),` | D | |
| 12 | `05-pca-biplot.qmd:1835` | `_effect ordering_ (@FriendlyKwan:03:effect) for variables` | `_effect ordering_ [@FriendlyKwan:03:effect] for variables` | A | OK |
| 13 | `05-pca-biplot.qmd:1980` | `**eigenfaces** (@Turk1991),` | `**eigenfaces** [@Turk1991],` | A | OK |
| 14 | `06-linear_models.qmd:91` | `IBM Yorkdown Heights (@IBM1965)` | `IBM Yorkdown Heights [@IBM1965]` | A | OK |
| 15 | `06-linear_models.qmd:91` | `University of Georgia (@BradshawFindley1967)` | `University of Georgia [@BradshawFindley1967]` | A | OK |
| 16 | `07-linear_models-plots.qmd:733` | `the _added-variable_ plot ("AV plot", also called _partial regression_ plot, @MostellerTukey-1977).` | `the _added-variable_ plot ["AV plot", also called _partial regression_ plot; @MostellerTukey-1977].` → renders ("AV plot", also called partial regression plot; Mosteller & Tukey, 1977) | D | |
| 17 | `07-linear_models-plots.qmd:954` | `("C+R plot", also called _partial residual plot_, @LarsenMcCleary:72; @Cook:93) gives a` | `["C+R plot", also called _partial residual plot_; @LarsenMcCleary:72; @Cook:93] gives a` | D | |
| 18 | `09-collinearity-ridge.qmd:60` | `(e.g, @Graybill1961; @Hocking2013)` — note existing typo "e.g," | `[e.g., @Graybill1961; @Hocking2013]` (also fixes the typo) | B | |
| 19 | `09-collinearity-ridge.qmd:824` | `Bayesian regression (e.g., @Pesaran2019) can reduce` | `Bayesian regression [e.g., @Pesaran2019] can reduce` | B | |
| 20 | `11-mlm-review.qmd:22` | `` The `r package("VGAM")` (@Yee2015, @R-VGAM) handles `` | `` The `r package("VGAM")` [@Yee2015; @R-VGAM] handles `` — comma between keys must become `;` or Pandoc mis-parses | C | |
| 21 | `11-mlm-review.qmd:2071` | `screening plot (suggested by @Rousseeuw2004) is a plot` | `screening plot [suggested by @Rousseeuw2004] is a plot` | B | |
| 22 | `12-mlm-viz.qmd:674` | `It is well-known (e.g., @Gittins:85)` | `It is well-known [e.g., @Gittins:85]` | B | |
| 23 | `21-discrim.qmd:209` | `Bayesian approaches (e.g., @EnisGeisser1974)` | `Bayesian approaches [e.g., @EnisGeisser1974]` | B | |
| 24 | `21-discrim.qmd:882` | `**step-down tests** (@Roy1957), which test` | `**step-down tests** [@Roy1957], which test` | A | OK |
| 25 | `21-discrim.qmd:970` | `(@Rao1948)` — on its own line, before the displayed equation | `[@Rao1948]` | A | OK |

## Instances in dead files (not in `_quarto.yml`, not included by any chapter)

Fixing these is optional — they do not affect the rendered book. Recommend fixing anyway
(or deleting the files) so the error does not resurface if the text is ever re-included.

| # | File:line | Current source (snippet) | Proposed fix | Cat. | Decision |
|---|-----------|--------------------------|--------------|------|----------|
| 26 | `04b-higher.qmd:167` | `(following @VanderPlas2023), we reorder` — duplicate of row 10; file referenced nowhere in build configs or other chapters | same as row 10 | B | |
| 27 | `child/04-network.qmd:32` | `(taken from [Rodrigues (2021)](...))` — duplicate of row 11; file referenced nowhere | same as row 11 | D | |

## Notes / near-misses (no action proposed)

- `04-multivariate_plots.qmd:359` — `(originally called *coplots* [@ChambersHastie1991])`:
  the citation syntax is **correct**, but a bracketed citation inside literal parentheses
  still renders nested parens: "(originally called *coplots* (Chambers & Hastie, 1991))".
  Strict APA would restructure; flagged only in case Michael wants to reword.
- `04-multivariate_plots.qmd:3360` and `child/04-network.qmd:50` — fig-cap
  `_Source_: [Rodrigues (2021)](...)`: narrative form after "Source:" reads fine; no change.
- `21-discrim.qmd:209` — `McLachlan's [-@McLachlan2004]` is correct suppressed-author
  syntax; excluded.
- Cross-references such as `(@fig-...)`, `(@sec-...)`, `(@exm-...)` are correct Quarto
  syntax and were excluded from all scans.
