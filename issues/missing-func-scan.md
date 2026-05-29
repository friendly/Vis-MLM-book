# Missing `func()` Formatting — Scan Results

Bare backtick function references of the form `` `funcname()` `` in prose that should be
converted to `` `r func("funcname()")` `` so that index entries are generated automatically.

**Scan date:** 2026-05-25  
**Scope:** All `.qmd` chapter files and included child files at the project root. `index.qmd`,
`blogs/`, and `test/` are excluded per the exclusion criteria in `func-references.md`.

**Exclusions applied:**
- Functions with an underscore (`_`) in the name — excluded per user instruction (LaTeX subscript issue)
- Lines already using `` `r func(` `` — excluded
- `#| fig-cap:` chunk option lines — inline R does not execute there
- HTML comment lines (`<!--`)
- Lines starting with `` ``` `` (code chunk delimiters)

**Notes:**
- Functions with dots (e.g., `plot.lm()`, `row.names()`) are listed — only underscores are excluded
- Section headings that contain bare function references are marked **[heading]**
- Footnote occurrences are marked **[fn]**
- Lines where `r func()` and a bare reference coexist on the same line may have been missed;
  this is a known gap in the grep-based approach

---

## `04-multivariate_plots.qmd`

| Line | Bare reference(s) | Notes |
|------|-------------------|-------|
| 355 | `` `lm()` ``, `` `glm()` `` | historical S Book paragraph |
| 356 | `` `plot()` ``, `` `coef()` `` | same paragraph |
| 357 | `` `text()` ``, `` `lines()` ``, `` `points()` `` | same paragraph; closing backtick missing on `points()` |
| 375 | `` `panel.xyplot()` ``, `` `panel.lmline()` `` | lattice panel function list |
| 382 | `` `aes()` `` | ggplot2 description |
| 390 | `` `lmer()` ``, `` `glmer()` `` | mixed-model formula note |
| 701 | `` `qchisq()` `` | data ellipse sizing |
| 884 | `` `sunflowerplot()` `` | base R plot description |
| 985 | `` `scatterplot()` `` | point-label note |
| 1198 | `` `peng.colors()` `` | user-defined helper function |
| 1702 | `` `cqplot()` `` | chi-square QQ plot description |
| 1728 | `` `jitter()` `` | jitter on ellipse description |
| 1757 | `` `cqplot()` `` | outlier discussion |
| 1881 | `` `pairs()` `` | base R pairs intro |
| 1909 | `` `pairs()` `` | enhanced pairs intro |
| 1942 | `` `scatterplotMatrix()` `` | point-label argument description |
| 2071 | `` `par()` `` | axis suppression note |
| 2154 | `` `corrplot()` `` | corrplot rendering methods |
| 2157 | `` `corrplot.mixed()` `` | mixed corrplot options |
| 2199 | `` `corrMatOrder()` `` | ordering methods |
| 2213 | `` `corrplot()` `` | ordering in corrplot |
| 2259 | `` `pairs()` `` | vcd pairs description |
| 2266 | `` `xtabs()` ``, `` `ftable()` `` | table construction |
| 2335 | `` `ggpairs()` `` | GGally intro |
| 2399 | `` `ggpairs()` `` | ggpairs generality description |
| 2443 | `` `ggpairs()` `` | ggpairs argument usage |

---

## `05-pca-biplot.qmd`

| Line | Bare reference(s) | Notes |
|------|-------------------|-------|
| 411 | `` `eigen()` `` | eigenvalue/eigenvector intro |
| 433 | `` `latexMatrix()` ``, `` `Eqn()` `` | matlib display |
| 555 | `` `prcomp()` `` | prcomp intro/preview |
| 600 | `` `prcomp()` `` | default options description |
| 603 | `` `princomp()` `` | older function comparison |
| 612 | `` `scale()` `` | standardization note |
| 647 | `` `prcomp()` `` | single-line example description |
| 658 | `` `is.numeric()` `` | column-selection function |
| 659 | `` `prcomp()` `` | result feed description |
| 667 | `` `prcomp()` `` | model object description |
| 669 | `` `summary()` `` | variance contribution summary |
| 675 | `` `prcomp()` `` | returned list description |
| 764 | `` `ggplot()` `` | component plot description |
| 817 | `` `ggplot()` ``, `` `row.names()` `` | loadings processing description |
| 822 | `` `row.names()` `` | R labeling convention |
| 1058 | `` `ggbiplot()` `` | groups argument description |
| 1241 | `` `PCA()` ``, `` `row.names()` `` | FactoMineR labeling limitation |
| 1253 | `` `prcomp()` `` | comparison with PCA() |
| 1254 | `` `PCA()` `` | supplementary variables result |
| 1358 | `` `movie3d()` `` | animation recording |
| 1656 | `` `print()` ``, `` `summary()` `` | Rtsne missing methods note |
| 1726 | `` `rbind()` `` | data stacking for animation |
| 1826 | `` `corrplot()` `` | cars corrplot intro |
| 1892 | `` `corrplot()` `` | PC variable ordering |
| 1897 | `` `corrplot()` `` | block highlighting feature |
| 2005 | `` `as.data.frame()` `` | image data conversion |
| 2022 | `` `prcomp()` `` | Mona Lisa PCA |

---

## `06-linear_models.qmd`

| Line | Bare reference(s) | Notes |
|------|-------------------|-------|
| 173 | `` `contrasts.poly()` `` | polynomial contrast description |
| 404 | `` `as.formula()` `` | formula construction |
| 425 | `` `model.matrix()` `` | one-sided formula note |
| 484 | `` `contr.sum()` `` | contrast type list |
| 485 | `` `contr.helmert()` `` | contrast type list |
| 486 | `` `contr.poly()` `` | contrast type list |
| 673 | `` `contr.sum()` `` | deviation coding description |
| 738 | `` `contr.poly()` `` | orthogonal contrasts |
| 741 | `` `contr.poly()` `` | scaling property |

---

## `07-linear_models-plots.qmd`

| Line | Bare reference(s) | Notes |
|------|-------------------|-------|
| 13 | `` `lm()` ``, `` `glm()` `` | chapter intro |
| 126 | `` `row.names()` `` | dataset labeling |
| 294 | `` `plot.lm()` `` | comparison with performance package |
| 411 | `` `summary()` `` | model summary description |
| 423 | `` `modelsummary()` `` | modelsummary intro |
| 458 | `` `modelplot()` `` | companion function description |
| 477 | `` `modelsummary()` ``, `` `modelplot()` `` | comparable displays intro |
| 478 | `` `modelplot()` `` | same |
| 479 | `` `modelsummary()` `` | multiple models display |
| 576 | `` `modelsummary()` `` | coefficient extraction note |
| 579 | `` `modelsummary()` ``, `` `modelplot()` `` | standardize argument forwarding |
| 722 | `` `lm()` `` | partial effects note |
| 784 | `` `avPlot()` `` | **[bold heading]** "**The `avPlot()` function**" |
| 1024 | `` `anova()` `` | polynomial comparison |
| 1088 | `` `predict()` ``, `` `vcov()` `` | effects package methods |
| 1102 | `` `predict()` `` | simple effect plot |
| 1103 | `` `predict.lm()` `` | return type note |
| 1123 | `` `plot()` `` | emmeans plot method |
| 1132 | `` `predictorEffect()` ``, `` `predictorEffects()` `` | main effects functions |
| 1133 | `` `predictorEffects()` `` | interaction handling description |
| 1137 | `` `plot.eff()` `` | "eff" object graphing |
| 1140 | `` `avplots()` `` | inclusion in plot formula (note: may be typo of `avPlots()`) |
| 1142 | `` `allEffects()` `` | high-order term effects |
| 1150 | `` `Anova()` `` | Type II tests |
| 1159 | `` `coeftest()` `` | coefficient testing |
| 1188 | `` `allEffects()` `` | all-terms overview |
| 1213 | `` `predictorEffects()` `` | slope description |
| 1217 | `` `plot()` `` | graphing options |
| 1544 | `` `hatvalues()` `` | hat values extraction |
| 1743 | `` `influencePlot()` `` | default identification method |
| 1755 | `` `influencePlot()` `` | return value description |
| 1789 | `` `avPlots()` `` | basic AV plots call |

---

## `09-collinearity-ridge.qmd`

| Line | Bare reference(s) | Notes |
|------|-------------------|-------|
| 265 | `` `coef()` `` | coefficient extraction |
| 608 | `` `colldiag()` `` | condition index description |
| 632 | `` `colldiag()` `` | tableplot intro |
| 653 | `` `colldiag()` `` | tableplot comparison |
| 925 | `` `SO()` `` | **[fn]** response surface model shortcut |
| 941 | `` `I()` `` | **[fn]** identity function explanation |
| 957 | `` `update()` `` | centered data refit |
| 1190 | `` `lm.ridge()` `` | MASS package mention |
| 1196 | `` `ridge()` ``, `` `pca.ridge()` `` | genridge workhorse description |
| 1197 | `` `vif.ridge()` ``, `` `precision()` `` | VIF and precision measures |
| 1204 | `` `traceplot()` `` | univariate ridge trace (bullet list) |
| 1205 | `` `plot.ridge()` `` | bivariate 2D (bullet list) |
| 1206 | `` `pairs.ridge()` `` | all pairwise (bullet list) |
| 1207 | `` `plot3d.ridge()` `` | 3D trace (bullet list) |
| 1208 | `` `biplot.ridge()` `` | PCA/SVD space trace (bullet list) |
| 1210 | `` `pca()` ``, `` `biplot.pcaridge()` `` | PCA method and biplot |
| 1246 | `` `ridge()` `` | returned matrix description |
| 1258 | `` `traceplot()` `` | simple coefficient plot |
| 1331 | `` `plot()` `` | "ridge" plot method |
| 1358 | `` `pairs()` `` | "ridge" pairs method |
| 1378 | `` `precision()` `` | shrinkage measures |
| 1409 | `` `plot()` `` | "precision" plot method |
| 1496 | `` `traceplot()` `` | pcaridge traceplot |
| 1516 | `` `pairs()` `` | pcaridge pairs plot |
| 1561 | `` `biplot.pcaridge()` `` | covariance ellipsoids in PCA space |

---

## `10-hotelling.qmd`

| Line | Bare reference(s) | Notes |
|------|-------------------|-------|
| 208 | `` `lm()` `` | t-test comparison |
| 461 | `` `lda()` `` | discriminant analysis function |
| 485 | `` `t.test()` `` | discriminant score t-test |
| 630 | `` `Anova()` `` | multivariate test statistics |
| 638 | `` `summary()` `` | "Anova.mlm" summary method |
| 749 | `` `hotelling.test()` `` | Hotelling T² value |
| 750 | `` `Anova()` `` | equivalent F statistic |

---

## `11-mlm-review.qmd`

| Line | Bare reference(s) | Notes |
|------|-------------------|-------|
| 19 | `` `lm()` ``, `` `glm()` `` | **[fn]** `[^mglm]` gap in methods |
| 20 | `` `lm()` `` | **[fn]** continuation |
| 258 | `` `lm()` `` | MLM fitting with lm() |
| 259 | `` `cbind()` `` | matrix response construction |
| 309 | `` `lm()` `` | dogfood formula fitting |
| 429 | `` `sweep()` ``, `` `colMeans()` `` | direct calculation description |
| 430 | `` `crossprod()` `` | premultiply operation |
| 630 | `` `summary()` `` | "Anova.mlm" multiple statistics |
| 800 | `` `cbind()` `` | column construction |
| 817 | `` `contrasts()` `` | contrast matrix assignment |
| 1078 | `` `lm()` `` | "mlm" class description |
| 1116 | `` `Anova()` `` | "Anova.mlm" class |
| 1117 | `` `summary()` `` | summary method description |
| 1125 | `` `summary()` `` | matrix suppression note |
| 1156 | `` `linearHypothesis()` `` | equal means test |
| 1164 | `` `linearHypothesis()` `` | general hypothesis description |
| 1281 | `` `covEllipses()` `` | within-group correlation examination |
| 1385 | `` `ggpairs()` `` | scatterplot matrix |
| 1411 | `` `Anova()` `` | interaction significance |
| 1428 | `` `Anova()` `` | multivariate test summary |
| 1429 | `` `uniStats()` `` | univariate statistics summary |
| 1754 | `` `Anova()` `` | individual predictor contribution |
| 1759 | `` `linearHypothesis()` `` | joint test |
| 1772 | `` `coef()` `` | coefficient display |
| 1833 | `` `update()` `` | model update |
| 1843 | `` `linearHypothesis()` `` | joint test |
| 1917 | `` `ggduo()` `` | **[fn]** `[^ggduo]` GGally function |
| 1918 | `` `ggpairs()` `` | **[fn]** same footnote |
| 1982 | `` `glance()` `` | MLM R² assessment |
| 1988 | `` `etasq()` `` | eta² measure for MLM |
| 1989 | `` `Anova()` `` | Type II analogy |
| 2039 | `` `cqplot()` `` | observed-variable outliers |
| 2045 | `` `mvn()` `` | MVN package test function |
| 2058 | `` `mvn()` `` | univariate normality tests |
| 2099 | `` `distancePlot()` `` | MCD estimator function |
| 2150 | `` `update()` `` | omitting troubling cases |
| 2160 | `` `Anova()` `` | post-omission test result |
| 2336 | `` `glance()` `` | univariate ANCOVA model tests |
| 2414 | `` `linearHypothesis()` ``, `` `grep()` `` | interaction term trick |
| 2440 | `` `lm()` `` | subset argument |

---

## `12-mlm-viz.qmd`

| Line | Bare reference(s) | Notes |
|------|-------------------|-------|
| 352 | `` `contrasts()` ``, `` `lm()` `` | pre-fitting contrast note |
| 390 | `` `heplot()` `` | heplot function intro |
| 539 | `` `linearHypothesis()` `` | numerical hypothesis tests |
| 594 | `` `pairs()` `` | pairs method for MLM |
| 595 | `` `pairs.mlm()` `` | heplots method description |
| 620 | `` `heplot3d()` `` | three-response plot |
| 666 | `` `candisc()` `` | candisc function reference |
| 669 | `` `candiscList()` `` | **[fn]** `[^candiscList]` all-terms version |
| 703 | `` `coef()` `` | "candisc" coefficient matrix |
| 751 | `` `plot()` `` | "candisc" plot method |
| 878 | `` `heplot()` `` | add=TRUE overlay description |
| 976 | `` `pairs.mlm()` `` | 5×5 display description |
| 1017 | `` `candisc()` `` | 2D space for Attr term |
| 1113 | `` `heplot()` `` | hypotheses argument |
| 1208 | `` `pairs()` `` | all-response pairs plot |
| 1349 | `` `cancor()` ``, `` `coef()` ``, `` `scores()` `` | "cancor" object description |
| 1350 | `` `coef()` ``, `` `candisc()` ``, `` `scores()` `` | methods description |
| 1357 | `` `plot()` ``, `` `heplot()` `` | visualization methods |
| 1358 | `` `plot()` `` | canonical scores plot |

---

## `13-eqcov.qmd`

| Line | Bare reference(s) | Notes |
|------|-------------------|-------|
| 319 | `` `covEllipses()` `` | pairwise scatterplot matrix |
| 383 | `` `boxM()` `` | Box M test results |
| 493 | `` `boxM()` ``, `` `summary()` ``, `` `plot()` `` | "boxm" object methods |
| 494 | `` `plot()` `` | log-determinant dot plot |
| 529 | `` `plot.boxm()` `` | additional measures |

---

## `14-infl-robust.qmd`

| Line | Bare reference(s) | Notes |
|------|-------------------|-------|
| 189 | `` `det()` ``, `` `tr()` `` | size measure functions |
| 249 | `` `cooks.distance()` `` | Cook's D examination |
| 575 | `` `robmlm()` ``, `` `lm()` `` | robust MANOVA substitution |
| 583 | `` `plot()` `` | "robmlm" plot method |
| 640 | `` `robmlm()` `` | down-weighting premise |

---

## `15-case-studies.qmd`

| Line | Bare reference(s) | Notes |
|------|-------------------|-------|
| 318 | `` `heplot()` `` | model visualization |
| 324 | `` `heplot()` ``, `` `update()` `` | abbreviated labels procedure |
| 333 | `` `heplot()` `` | first two responses plot |
| 373 | `` `candisc()` `` | mean differences result |
| 380 | `` `plot()` `` | "candisc" plot method |
| 433 | `` `Anova()` `` | overall group differences |
| 444 | `` `linearHypothesis()` `` | two contrasts test |
| 543 | `` `update()` `` | model update after subset |
| 594 | `` `heplot()` `` | "candisc" heplot method |

---

## `21-discrim.qmd`

| Line | Bare reference(s) | Notes |
|------|-------------------|-------|
| 49 | `` `predict()` `` | LDA predicted group membership |
| 53 | `` `lm()` `` | MLM with grouping factors |
| 316 | `` `predict.lda()` `` | newdata classification |
| 328 | `` `predict()` `` | result manipulation |
| 429 | `` `plot.lda()` `` | MASS plot method note |
| 465 | `` `plot.lda()` `` | panel argument description |
| 472 | `` `plot.lda()` `` | panel function call |
| 513 | `` `plot.lda()` `` | method internals note |
| 541 | `` `predict()` `` | decision boundary classification |
| 548 | `` `predict()` `` | grid point classification (bulleted) |
| 563 | `` `partimat()` `` | **[heading]** "### Partition plots with `partimat()`" |
| 569 | `` `partimat()` `` | formula argument description |
| 571 | `` `lda()` `` | method argument |
| 603 | `` `ggplot()` `` | **[heading]** "### Using `ggplot()`" |
| 608 | `` `seq.range()` `` | variable range sequence |
| 694 | `` `theme()` `` | ggplot customization |
| 734 | `` `lda()` `` | new predictor call |
| 809 | `` `lda()` `` | scaling component description |
| 810 | `` `ggplot()` `` | data.frame conversion for ggplot |
| 851 | `` `lm()` `` | "mlm" object for candisc |
| 852 | `` `candisc()` `` | candisc from lm |
| 865 | `` `lda()` `` | percent contributions comparison |
| 871 | `` `plot()` `` | "candisc" plot method |
| 912 | `` `lda()` ``, `` `candisc()` `` | unstandardized vs. standardized |
| 915 | `` `lda()` `` | standardized result note |

---

## `child/04-grand-tour.qmd`

| Line | Bare reference(s) | Notes |
|------|-------------------|-------|
| 363 | `` `animate()` `` | real-time animation function |
| 364 | `` `render()` `` | frame-saving function |
| 394 | `` `holes()` `` | holes index (bulleted) |
| 395 | `` `cmass()` `` | central mass index (bulleted) |

---

## `child/04-network.qmd`

| Line | Bare reference(s) | Notes |
|------|-------------------|-------|
| 98 | `` `qgraph()` `` | edge significance argument |
| 193 | `` `qgraph()` `` | partial correlation graph |
| 245 | `` `pvPlot()` `` | user-defined partial variance plot |

---

## `child/10-discrim.qmd`

| Line | Bare reference(s) | Notes |
|------|-------------------|-------|
| 35 | `` `predict()` `` | LDA predicted group membership |
| 39 | `` `lm()` `` | MLM with grouping factors |
| 109 | `` `mda()` ``, `` `fda()` `` | mda package alternatives |
| 110 | `` `lda()` `` | same syntax as mda |
| 188 | `` `predict.lda()` `` | newdata classification |
| 200 | `` `predict()` `` | result manipulation |
| 290 | `` `plot.lda()` `` | MASS plot method note |
| 325 | `` `plot.lda()` `` | panel argument description |
| 333 | `` `plot.lda()` `` | panel function call |
| 375 | `` `plot.lda()` `` | method internals note |
| 403 | `` `predict()` `` | decision boundary classification |
| 410 | `` `predict()` `` | grid point classification (bulleted) |
| 425 | `` `partimat()` `` | **[heading]** "#### Partition plots with `partimat()`" |
| 431 | `` `partimat()` `` | formula argument description |
| 433 | `` `lda()` `` | method argument |
| 465 | `` `ggplot()` `` | **[heading]** "#### Using `ggplot()`" |
| 470 | `` `range80()` `` | variable range function |
| 553 | `` `lda()` `` | new predictor call |
| 619 | `` `lda()` `` | scaling component description |
| 620 | `` `ggplot()` `` | data.frame conversion for ggplot |
| 659 | `` `lm()` `` | "mlm" object for candisc |
| 660 | `` `candisc()` `` | candisc from lm |
| 673 | `` `lda()` `` | percent contributions comparison |
| 678 | `` `plot()` `` | "candisc" plot method |
| 718 | `` `lda()` ``, `` `candisc()` `` | unstandardized vs. standardized |
| 721 | `` `lda()` `` | standardized result note |

---

## `child/influence-mlm.qmd`

| Line | Bare reference(s) | Notes |
|------|-------------------|-------|
| 77 | `` `det()` ``, `` `tr()` `` | size measure functions |

---

## Summary counts

| File | Lines with bare references |
|------|---------------------------|
| `04-multivariate_plots.qmd` | 26 |
| `05-pca-biplot.qmd` | 26 |
| `06-linear_models.qmd` | 9 |
| `07-linear_models-plots.qmd` | 30 |
| `09-collinearity-ridge.qmd` | 24 |
| `10-hotelling.qmd` | 7 |
| `11-mlm-review.qmd` | 36 |
| `12-mlm-viz.qmd` | 19 |
| `13-eqcov.qmd` | 5 |
| `14-infl-robust.qmd` | 5 |
| `15-case-studies.qmd` | 9 |
| `21-discrim.qmd` | 22 |
| `child/04-grand-tour.qmd` | 4 |
| `child/04-network.qmd` | 3 |
| `child/10-discrim.qmd` | 24 |
| `child/influence-mlm.qmd` | 1 |
| **Total** | **250** |

---

## Files with no bare references found

- `01-Prelude.qmd`
- `02-intro.qmd`
- `03-getting_started.qmd`
- `04b-higher.qmd`
- `08-lin-mod-topics.qmd`
- `child/06-linear-combinations.qmd`
- `child/anova-manova.qmd`
