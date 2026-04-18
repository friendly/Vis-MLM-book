# Figures without fig.code comments

Figures in `{r}` chunks with a `fig-*` label that have no `<!-- fig.code: -->` comment
in the 15 lines before the label. The dataset token (first word after `fig-`) is matched
against filenames in `R/`.

**Summary:** 95 uncovered figures across 14 chapters — 16 clear match, 27 ambiguous, 52 no match.

To add a comment, insert it in the `.qmd` file immediately before the opening ` ```{r}` of the chunk.

---

## Chapter 1: Warm-up Exercises (`01-Prelude.qmd`)

**`fig-diabetes1`** (line 364) — *no match for token `diabetes1`*

---

## Chapter 3: Getting Started (`03-getting_started.qmd`)

**`fig-davis-reg1`** (line 301)
→ `<!-- fig.code: R/Davis-reg.R -->`

**`fig-davis-reg2`** (line 329)
→ `<!-- fig.code: R/Davis-reg.R -->`

**`fig-draft-gg2`** (line 455)
→ `<!-- fig.code: R/draft1970.R -->`

**`fig-draft-means`** (line 516)
→ `<!-- fig.code: R/draft1970.R -->`

**`fig-davis-diagnostic`** (line 659)
→ `<!-- fig.code: R/Davis-reg.R -->`

---

## Chapter 4: Plots of Multivariate Data (`04-multivariate_plots.qmd`)

**`fig-Salaries-lm`** (line 183)
→ `<!-- fig.code: R/Salaries-scatterplots.R -->`

**`fig-Salaries-loess`** (line 258)
→ `<!-- fig.code: R/Salaries-scatterplots.R -->`

**`fig-Salaries-rank`** (line 371)
→ `<!-- fig.code: R/Salaries-scatterplots.R -->`

**`fig-Salaries-discipline`** (line 410)
→ `<!-- fig.code: R/Salaries-scatterplots.R -->`

**`fig-Salaries-faceted`** (line 482)
→ `<!-- fig.code: R/Salaries-scatterplots.R -->`

**`fig-Salaries-facet-sex`** (line 516)
→ `<!-- fig.code: R/Salaries-scatterplots.R -->`

**`fig-Prestige-scatterplot-educ1`** (line 937) — *no match for token `Prestige`*

**`fig-Prestige-scatterplot-educ2`** (line 964) — *no match for token `Prestige`*

**`fig-Prestige-scatterplot2`** (line 1004) — *no match for token `Prestige`*

**`fig-Prestige-scatterplot3`** (line 1036) — *no match for token `Prestige`*

**`fig-peng-ggplot1`** (line 1200) — *no match for token `peng`*

**`fig-peng-ggplot2`** (line 1232) — *no match for token `peng`*

**`fig-peng-bagplot`** (line 1277) — *no match for token `peng`*

**`fig-peng-ggdensity`** (line 1341) — *no match for token `peng`*

**`fig-peng-ggplot-out`** (line 1720) — *no match for token `peng`*

**`fig-prestige-pairs`** (line 1819) — *no match for token `prestige`*

**`fig-peng-mosaic`** (line 2221) — *no match for token `peng`*

---

## Chapter 5: Dimension Reduction (`05-pca-biplot.qmd`)

**`fig-crime-ggscreeplot`** (line 709) — *no match for token `crime`*

**`fig-crime-scores-plot12`** (line 770) — *no match for token `crime`*

**`fig-crime-vectors`** (line 839) — *no match for token `crime`*

**`fig-crime-biplot2`** (line 1058) — *no match for token `crime`*

**`fig-crime-biplot3`** (line 1094) — *no match for token `crime`*

**`fig-fviz-contrib`** (line 1149) — *no match for token `fviz`*

**`fig-crime-factominer`** (line 1287) — *no match for token `crime`*

**`fig-diabetes-ggbiplot`** (line 1405) — *no match for token `diabetes`*

**`fig-diabetes-stress`** (line 1523) — *no match for token `diabetes`*

**`fig-diabetes-mds`** (line 1558) — *no match for token `diabetes`*

**`fig-diabetes-pca-tsne-anim`** (line 1741) — *no match for token `diabetes`*

**`fig-mtcars-corrplot-varorder`** (line 1817) — *ambiguous* (token: `mtcars`)
- `<!-- fig.code: R/mtcars-corrplot.R -->`
- `<!-- fig.code: R/mtcars-corrplot0.R -->`

**`fig-mtcars-biplot`** (line 1863) — *ambiguous* (token: `mtcars`)
- `<!-- fig.code: R/mtcars-corrplot.R -->`
- `<!-- fig.code: R/mtcars-corrplot0.R -->`

**`fig-mtcars-corrplot-pcaorder`** (line 1887) — *ambiguous* (token: `mtcars`)
- `<!-- fig.code: R/mtcars-corrplot.R -->`
- `<!-- fig.code: R/mtcars-corrplot0.R -->`

---

## Chapter 6: Overview of Linear models (`06-linear_models.qmd`)

**`fig-workers-fits`** (line 266) — *ambiguous* (token: `workers`)
- `<!-- fig.code: R/workers-pca.R -->`
- `<!-- fig.code: R/workers-reg.R -->`

---

## Chapter 7: Plots for Univariate Response Models (`07-linear_models-plots.qmd`)

**`fig-duncan-plot-model`** (line 272) — *no match for token `duncan`*

**`fig-plot-prestige-mod`** (line 360) — *ambiguous* (token: `plot`)
- `<!-- fig.code: R/avplot-interp.R -->`
- `<!-- fig.code: R/correlplot-ex.R -->`
- `<!-- fig.code: R/geom-bagplot-test.R -->`
- `<!-- fig.code: R/geom-bagplot.R -->`
- `<!-- fig.code: R/longley-plots.R -->`
- `<!-- fig.code: R/mtcars-corrplot.R -->`
- `<!-- fig.code: R/mtcars-corrplot0.R -->`
- `<!-- fig.code: R/NeuroCog-biplot.R -->`
- `<!-- fig.code: R/NeuroCog-plots.R -->`
- `<!-- fig.code: R/pvPlot.R -->`
- `<!-- fig.code: R/Salaries-scatterplots.R -->`
- `<!-- fig.code: R/schooldata-plots.R -->`

**`fig-modelplot2`** (line 508) — *no match for token `modelplot2`*

**`fig-modelplot3`** (line 559) — *no match for token `modelplot3`*

**`fig-prestige-allEffects`** (line 1192) — *no match for token `prestige`*

**`fig-prestige-effplot-educ`** (line 1222) — *no match for token `prestige`*

**`fig-prestige-effplot-women`** (line 1238) — *no match for token `prestige`*

**`fig-prestige-effplot-inc`** (line 1251) — *no match for token `prestige`*

**`fig-prestige-effplot-inc-log`** (line 1273) — *no match for token `prestige`*

**`fig-levdemo`** (line 1389)
→ `<!-- fig.code: R/levdemo.R -->`

**`fig-hatvalues-demo2`** (line 1579)
→ `<!-- fig.code: R/hatvalues-demo.R -->`

---

## Chapter 9: Collinearity & Ridge Regression (`09-collinearity-ridge.qmd`)

**`fig-cars-check-collin`** (line 493) — *ambiguous* (token: `cars`)
- `<!-- fig.code: R/cars-colldiag.R -->`
- `<!-- fig.code: R/mtcars-corrplot.R -->`
- `<!-- fig.code: R/mtcars-corrplot0.R -->`

**`fig-cars-collin-biplot`** (line 699) — *ambiguous* (token: `cars`)
- `<!-- fig.code: R/cars-colldiag.R -->`
- `<!-- fig.code: R/mtcars-corrplot.R -->`
- `<!-- fig.code: R/mtcars-corrplot0.R -->`

**`fig-collin-centering`** (line 852) — *ambiguous* (token: `collin`)
- `<!-- fig.code: R/collin-centering.R -->`
- `<!-- fig.code: R/collin-data-beta.R -->`

**`fig-longley-plot-ridge`** (line 1335) — *ambiguous* (token: `longley`)
- `<!-- fig.code: R/genridge-longley-figs1.R -->`
- `<!-- fig.code: R/genridge-longley-figs2.R -->`
- `<!-- fig.code: R/longley-plots.R -->`

**`fig-longley-pairs`** (line 1361) — *ambiguous* (token: `longley`)
- `<!-- fig.code: R/genridge-longley-figs1.R -->`
- `<!-- fig.code: R/genridge-longley-figs2.R -->`
- `<!-- fig.code: R/longley-plots.R -->`

**`fig-longley-pca-pairs`** (line 1522) — *ambiguous* (token: `longley`)
- `<!-- fig.code: R/genridge-longley-figs1.R -->`
- `<!-- fig.code: R/genridge-longley-figs2.R -->`
- `<!-- fig.code: R/longley-plots.R -->`

**`fig-longley-pca-dim56`** (line 1535) — *ambiguous* (token: `longley`)
- `<!-- fig.code: R/genridge-longley-figs1.R -->`
- `<!-- fig.code: R/genridge-longley-figs2.R -->`
- `<!-- fig.code: R/longley-plots.R -->`

**`fig-longley-pca-biplot`** (line 1565) — *ambiguous* (token: `longley`)
- `<!-- fig.code: R/genridge-longley-figs1.R -->`
- `<!-- fig.code: R/genridge-longley-figs2.R -->`
- `<!-- fig.code: R/longley-plots.R -->`

---

## Chapter 10: Hotelling's $T^2$ (`10-hotelling.qmd`)

**`fig-mathscore-violins`** (line 497) — *no match for token `mathscore`*

**`fig-banknote-biplot`** (line 606)
→ `<!-- fig.code: R/banknote.R -->`

---

## Chapter 11: Multivariate Linear Models (`11-mlm-review.qmd`)

**`fig-dogfood-boxplot`** (line 289) — *no match for token `dogfood`*

**`fig-parenting-boxpl`** (line 1011) — *ambiguous* (token: `parenting`)
- `<!-- fig.code: R/parenting-ex.R -->`
- `<!-- fig.code: R/parenting.R -->`

**`fig-addhealth-means-each`** (line 1249) — *no match for token `addhealth`*

**`fig-NLSY-density`** (line 1660) — *ambiguous* (token: `NLSY`)
- `<!-- fig.code: R/NLSY-check.R -->`
- `<!-- fig.code: R/NLSY-ex.R -->`
- `<!-- fig.code: R/NLSY-models-nolog.R -->`

**`fig-NLSY-scat1`** (line 1682) — *ambiguous* (token: `NLSY`)
- `<!-- fig.code: R/NLSY-check.R -->`
- `<!-- fig.code: R/NLSY-ex.R -->`
- `<!-- fig.code: R/NLSY-models-nolog.R -->`

**`fig-NLSY-scat2`** (line 1701) — *ambiguous* (token: `NLSY`)
- `<!-- fig.code: R/NLSY-check.R -->`
- `<!-- fig.code: R/NLSY-ex.R -->`
- `<!-- fig.code: R/NLSY-models-nolog.R -->`

**`fig-schooldata-scats`** (line 1923) — *ambiguous* (token: `schooldata`)
- `<!-- fig.code: R/schooldata-ex.R -->`
- `<!-- fig.code: R/schooldata-plots.R -->`

**`fig-Rohwer-scats`** (line 2268) — *ambiguous* (token: `Rohwer`)
- `<!-- fig.code: R/Rohwer-ex.R -->`
- `<!-- fig.code: R/Rohwer-scat.R -->`

---

## Chapter 12: Visualizing Multivariate Models (`12-mlm-viz.qmd`)

**`fig-iris-pairs`** (line 598) — *no match for token `iris`*

**`fig-iris-candisc`** (line 764) — *no match for token `iris`*

**`fig-jury-can`** (line 1035)
→ `<!-- fig.code: R/MockJury-ex.R -->`

**`fig-school-heplot2`** (line 1208) — *ambiguous* (token: `school`)
- `<!-- fig.code: R/schooldata-ex.R -->`
- `<!-- fig.code: R/schooldata-plots.R -->`

**`fig-school-can`** (line 1356) — *ambiguous* (token: `school`)
- `<!-- fig.code: R/schooldata-ex.R -->`
- `<!-- fig.code: R/schooldata-plots.R -->`

**`fig-school-can0`** (line 1384) — *ambiguous* (token: `school`)
- `<!-- fig.code: R/schooldata-ex.R -->`
- `<!-- fig.code: R/schooldata-plots.R -->`

**`fig-rohwer-HE-mod1-pairs`** (line 1470) — *ambiguous* (token: `rohwer`)
- `<!-- fig.code: R/Rohwer-ex.R -->`
- `<!-- fig.code: R/Rohwer-scat.R -->`

---

## Chapter 13: Visualizing Equality of Covariance Matrices (`13-eqcov.qmd`)

**`fig-peng-boxplots`** (line 163) — *no match for token `peng`*

**`fig-peng-devplots`** (line 204) — *no match for token `peng`*

**`fig-peng-iris-boxm-plots`** (line 497) — *no match for token `peng`*

**`fig-peng-iris-boxm-plots2`** (line 533) — *no match for token `peng`*

**`fig-peng-boxm-plots`** (line 666) — *no match for token `peng`*

**`fig-iris-dev-pairs`** (line 718) — *no match for token `iris`*

**`fig-iris-dev-can`** (line 750) — *no match for token `iris`*

---

## Chapter 14: Multivariate Influence and Robust Estimation (`14-infl-robust.qmd`)

**`fig-toy-dfbetas`** (line 343)
→ `<!-- fig.code: R/mvinfluence-Toy.R -->`

**`fig-peng-robmlm-plot`** (line 588) — *no match for token `peng`*

---

## Chapter 15: Case Studies (`15-case-studies.qmd`)

**`fig-NC-boxplot`** (line 129) — *ambiguous* (token: `NC`)
- `<!-- fig.code: R/ANCOVA-ex.R -->`
- `<!-- fig.code: R/cancor-matrix.R -->`
- `<!-- fig.code: R/find-uncovered-figures.R -->`
- `<!-- fig.code: R/mvinfluence-Toy.R -->`

**`fig-neuro-biplot`** (line 257) — *ambiguous* (token: `neuro`)
- `<!-- fig.code: R/NeuroCog-biplot.R -->`
- `<!-- fig.code: R/NeuroCog-plots.R -->`
- `<!-- fig.code: R/NeuroCog.R -->`
- `<!-- fig.code: R/NeuroCog1.R -->`

**`fig-NC-HE-pairs`** (line 352) — *ambiguous* (token: `NC`)
- `<!-- fig.code: R/ANCOVA-ex.R -->`
- `<!-- fig.code: R/cancor-matrix.R -->`
- `<!-- fig.code: R/find-uncovered-figures.R -->`
- `<!-- fig.code: R/mvinfluence-Toy.R -->`

**`fig-NC-candisc`** (line 386) — *ambiguous* (token: `NC`)
- `<!-- fig.code: R/ANCOVA-ex.R -->`
- `<!-- fig.code: R/cancor-matrix.R -->`
- `<!-- fig.code: R/find-uncovered-figures.R -->`
- `<!-- fig.code: R/mvinfluence-Toy.R -->`

---

## Appendix: Discriminant analysis (`21-discrim.qmd`)

**`fig-peng-new-data`** (line 384) — *no match for token `peng`*

**`fig-peng-new-discrim`** (line 432) — *no match for token `peng`*

**`fig-peng-new-discrim2`** (line 475) — *no match for token `peng`*

**`fig-peng-regions`** (line 648) — *no match for token `peng`*

**`fig-peng-plot-discrim`** (line 704) — *no match for token `peng`*

**`fig-peng-LD-predict`** (line 770) — *no match for token `peng`*

**`fig-peng-LD-biplot`** (line 827) — *no match for token `peng`*

**`fig-peng-candisc`** (line 876) — *no match for token `peng`*

---

