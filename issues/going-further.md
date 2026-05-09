# Task: "Going Further" Infoboxes

## Concept

The book covers classical, frequentist extensions of `lm()` to the multivariate
setting. Many readers will want pointers to topics that are **intentionally excluded**:
hierarchical/mixed models, Bayesian methods, robust methods beyond Ch 14,
machine learning, etc.

A recurring infobox titled **"Going further"** at the end of selected chapters
(or major sections) provides these pointers without disrupting the main narrative.

---

## Existing usage

`21-discrim.qmd` (and `child/10-discrim.qmd`) already has a plain `### Going further`
heading — the first instance to upgrade to the new callout style.

---

## Implementation

### Quarto callout syntax

The simplest approach uses the existing `callout-note` type with a fixed title,
consistent with the "History Corner", "Looking ahead", and "What about SEM?" boxes
already in the book:

```markdown
:::: {.callout-note title="Going further"}

Text and references here.

::::
```

### Giving it a distinct visual identity (optional)

If "Going further" boxes should look different from informational `callout-note`
boxes, two options:

**Option A — use `callout-tip`** (renders green in most Quarto themes, vs. blue
for `callout-note`). No CSS needed:

```markdown
:::: {.callout-tip title="Going further"}
...
::::
```

**Option B — custom CSS class** for full control. Add to a `styles/custom.scss`
(referenced from `_quarto.yml`):

```scss
// "Going further" callout — teal left border, light background
div.callout-going-further {
  border-left-color: $part-II-color;  // teal, from part color scheme
  > .callout-header { background-color: mix($part-II-color, white, 15%); }
}
```

Then use:

```markdown
:::: {.callout-going-further title="Going further"}
...
::::
```

Custom div classes require a Lua filter to be recognized by Quarto as a callout;
`callout-tip` with a custom title is probably the pragmatic choice for now.

### Placement

- Prefer **end of chapter**, just before or after the Summary section.
- For long chapters with distinct sections (e.g., Ch 11 covering multiple test
  statistics), a box at the end of the relevant section is fine.
- Keep boxes short: 3–8 bullet points with citations, not prose paragraphs.

### Template

```markdown
:::: {.callout-tip title="Going further"}

The methods in this chapter assume [brief scope statement]. Extensions include:

- **Hierarchical / mixed models**: when observations are grouped within larger
  units (schools, clinics, subjects), use `lme4::lmer()` [@Bates2015] or
  `nlme::lme()`. See @Snijders2012 for a thorough introduction.

- **Bayesian methods**: `brms` [@Burkner2017] and `rstanarm` [@Goodrich2023]
  provide Bayesian analogues with Stan back-ends and familiar `lm()`-style syntax.

- **[Topic]**: ...

::::
```

---

## Per-chapter content ideas

### Part I — Orienting Ideas

**Ch 02 — Introduction** (SEM callout already exists; could add a "Going further")
- Structural equation modeling: `lavaan` [@Rosseel2012], `sem`
- Longitudinal/growth curve models as MLM extension

### Part II — Exploratory Methods

**Ch 05 — PCA and Biplots**
- **Sparse PCA**: `PMA::SPC()`, `elasticnet` — useful when p >> n
- **Probabilistic PCA / Factor analysis**: `psych::fa()` for latent variable
  interpretation; FA assumes a generative model, PCA does not
- **Non-linear dimension reduction**: t-SNE (`Rtsne`), UMAP (`uwot`) for
  cluster-preserving embeddings — exploratory only, not inferential
- **Kernel PCA**: `kernlab::kpca()` for non-linear structure

**Ch 04 — Multivariate Plots**
- **Interactive graphics**: `plotly`, `ggiraph`, `crosstalk` for HTML output
- **Linked / brushed plots**: `ggvis` or Shiny apps for interactive exploration
- **High-dimensional visualization**: `tourr` for grand tours, `GGally` extensions

### Part III — Univariate Linear Models

**Ch 06 — Linear Models**
- **Bayesian regression**: `brms`, `rstanarm` — priors, credible intervals,
  posterior predictive checks; `bayesplot` for visualization
- **Hierarchical linear models**: `lme4::lmer()` when units are nested;
  random intercepts and slopes; `lmerTest` for p-values
- **Generalized linear models**: `glm()` for non-normal responses; `MASS::glm.nb()`
  for count data; `betareg` for proportions

**Ch 07 — Linear Model Plots**
- **`ggeffects` / `marginaleffects`**: richer marginal-effects visualization
  than `effects`; works with many model classes beyond `lm()`
- **`modelsummary`**: publication-quality regression tables comparing models

**Ch 08 — LM Topics**
- **GAMs**: `mgcv::gam()` for smooth non-linear effects; `gratia` for
  visualization analogous to this chapter's `effects`-based plots
- **Regularization**: `glmnet` for lasso/ridge/elastic net; `hdm` for
  high-dimensional inference

**Ch 09 — Collinearity and Ridge**
- **Elastic net / lasso**: `glmnet` unifies ridge (α=0) and lasso (α=1);
  cross-validated via `cv.glmnet()`
- **Bayesian shrinkage**: horseshoe and regularized horseshoe priors via `brms`
  as an alternative to ridge for sparse signals
- **PLS regression**: `pls::plsr()` — related to ridge but extracts components
  that predict Y, useful when collinearity is structural

### Part IV — Multivariate Linear Models

**Ch 10 — Hotelling's T²**
- **Non-parametric multivariate two-sample tests**: `energy::eqdist.etest()`,
  `vegan::adonis2()` (permutation MANOVA) — relax normality assumption
- **Bayesian multivariate two-group comparison**: `brms` with `mvbind()` syntax

**Ch 11 — MLM Review / MANOVA**
- **Multivariate mixed models**: `MCMCglmm` [@Hadfield2010] for Bayesian
  MANOVA with random effects; `lme4` + `car::Manova()` for frequentist LMM
- **Robust MANOVA**: `robustbase::covMcd()` for MCD-based test statistics;
  permutation tests via `vegan::adonis2()`
- **MANOVA with many responses (p >> n)**: `MANOVA.RM` package for
  non-parametric rank-based MANOVA

**Ch 12 — MLM Visualization**
- **SEM and path diagrams**: `lavaan` + `semPlot` or `tidySEM` for latent
  variable models with both predictors and responses
- **Canonical correlation analysis**: `CCA`, `yacca`, or `candisc::cancor()`
  as a bridge to MLM; biplot visualization of canonical scores

**Ch 13 — Equality of Covariance Matrices**
- **Regularized covariance estimation**: `corpcor`, `rrcov::CovMcd()` for
  robust estimates; `PDSCE` for positive-definite sparse estimation
- **Bayesian covariance modeling**: Wishart/inverse-Wishart priors via `MCMCglmm`

**Ch 14 — Influence and Robust Methods**
- **MM-estimators**: `robustbase::lmrob()` for higher-breakdown + high-efficiency
  robust regression; `rrcov::lmRob()` for multivariate extension
- **Robust MLM**: `rrcov::CovMcd()` + `heplots::heplot()` workflow for
  influence-resistant HE plots (partially covered in chapter; extend here)

### Appendix — Discriminant Analysis (Ch 21)

*Already has a plain `### Going further` heading — upgrade to callout and expand:*
- **Regularized/penalized LDA**: `MASS::lda()` with `method="mle"` + `klaR::rda()`
  for regularized DA between LDA and QDA
- **QDA**: `MASS::qda()` — relaxes equal-covariance assumption; visualize with
  `klaR::partimat()`
- **Machine learning classifiers**: random forests (`randomForest`), SVM (`kernlab`),
  gradient boosting (`xgboost`) as black-box alternatives; compare with `caret` or
  `tidymodels`; note loss of interpretability
- **Naive Bayes**: `e1071::naiveBayes()` — assumes independence; surprisingly
  competitive, easy to interpret

---

## Cross-cutting topics (could appear in multiple chapters)

- **`tidymodels` ecosystem**: `parsnip`, `recipes`, `workflows` unify model
  fitting across many model classes; relevant wherever model comparison appears
- **Bayesian workflow**: prior predictive checks → fitting → posterior predictive
  checks → model comparison (`loo`); could be a single "Going further" at the
  end of Ch 06 or Ch 11 to cover the whole book
- **Missing data**: `mice` for multiple imputation before fitting any model;
  relevant to Ch 06 and Ch 11

---

## Style decisions to make

- [ ] `callout-note` (blue) vs `callout-tip` (green) — choose one and use
      consistently for all "Going further" boxes
- [ ] Fixed icon or `icon=false`? The existing `callout-note` boxes in the book
      use the default icon (ℹ️); "Going further" might look better without it
      to distinguish from informational notes
- [ ] Should the boxes include `\index{}` entries for the extension topics
      mentioned, so they appear in the subject index?

---

## Next steps

- [ ] Upgrade `### Going further` in `21-discrim.qmd` to the chosen callout style
- [ ] Decide on `callout-note` vs `callout-tip`; update all instances
- [ ] Draft box for Ch 11 (MANOVA extensions) as a second example
- [ ] Systematic pass once style is settled: add boxes to all chapters listed above

---

## Related files

- `issues/task-color-themes.md` — part accent colors; "Going further" boxes
  could eventually use the part color as their left border
- `issues/task-diagrams.md` — other infobox/callout patterns in the book
- `21-discrim.qmd` line ~509 — existing plain `### Going further` to upgrade
