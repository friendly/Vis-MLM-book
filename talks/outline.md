# Talk outline: Visualizing Multivariate Data and Models in R

**Title:** Visualizing Multivariate Data and Models in R: A Romance in Many Dimensions

**First outing:** Utrecht, 5 November 2026

**Status:** outline of candidate topics, to be cut down to fit the time slot. Nothing here is a slide yet.

## Open questions

- How long is the slot, and how much of it is discussion? The outline below is modular: the **core** sections make a talk of roughly 40--45 minutes; the **optional** ones can be added or swapped in.

- Audience mix: the organizer mentions "students and colleagues", so probably statistics/methodology people who know regression and ANOVA but not necessarily MANOVA or HE plots.

- Format: PowerPoint or Quarto/reveal.js (see the last section).

## What the organizer asked for

"A talk based on the new book, perhaps highlighting some of its themes and examples", with seven figures singled out. These are identified below from the current HTML build in `docs/`; each caption matches the organizer's description.

| Figure | What it is | Label | File | Section |
|---|---|---|---|---|
| 5.5 | Animation: PCA fitted by springs | `fig-pca-springs` | `images/pca-springs-cropped.gif` | Ch 5, PCA |
| 5.26 | Animation: PCA morphing into t-SNE, Diabetes data | `fig-diabetes-pca-tsne-anim-gif` | `images/diabetes-pca-tsne.gif` | Ch 5, Nonlinear dimension reduction |
| 7.27 | Added-variable plots, Duncan data, influence of *minister* and *conductor* | `fig-duncan-av-influence` | `images/duncan-av-influence.png` | Ch 7, Outliers, leverage and influence |
| 9.13 | Scatterplot matrix of bivariate ridge trace plots, Longley data | `fig-longley-pairs` | `figs/ch09/fig-longley-pairs-1.png` | Ch 9, Bivariate ridge trace plots |
| 10.9 | The HE plot framework for a two-group design | `fig-HE-framework` | `images/HE-framework.png` | Ch 10, HE plot and discriminant axis |
| 11.18 | Distance plot: Mahalanobis distances of residuals vs. predictors, school data | `fig-school-distplot` | `figs/ch11/fig-school-distplot-1.png` | Ch 11, Model diagnostics for MLMs |
| 12.17 | HE plot for reading and mathematics, school data MMRA | `fig-school-heplot1` | `figs/ch12/fig-school-heplot1-1.png` | Ch 12, Quantitative predictors: MMRA |

These seven fall naturally into four of the sections below (dimension reduction; univariate model plots; collinearity and ridge; HE plots and MLM diagnostics), so they can serve as the anchor figure for each.

## Proposed arc

The book's own progression is the simplest story line: from plots of *data*, to plots of *models* with one response, to plots of models with *many* responses. One recurring device ties it together: the **ellipse**, as data ellipse, confidence ellipse, and **H** and **E** ellipses.

### 1. Opening: why a romance in many dimensions? (core, ~5 min)

- The book and its aims: graphical methods for multivariate data and models that are as usable as those for a single response.

- From the Prelude (Ch 1): "The magic of graphs", "ONE, TWO, MANY", *Flatland*, and multivariate scientific discoveries.

- The problem (Ch 2): why use a multivariate design, why visualization is harder there, and the problems in understanding and communicating MLM results.

- Where to find it: online version, R packages (**heplots**, **candisc**, **mvinfluence**, **genridge**, ...).

### 2. Seeing multivariate data (core, ~7 min)

- Data ellipses as the workhorse summary (Ch 4), and what they show about means, variances and correlation.

- Meet the penguins: the running example, including Simpson's paradox (marginal vs. conditional relationships).

- A quick tour of the toolbox: scatterplot matrices, corrgrams, generalized pairs plots, parallel coordinates, animated tours.

- Optional: multivariate normality and outliers; bagplots.

### 3. Flatland and Spaceland: dimension reduction (core, ~8 min)

- **Figure 5.5**: PCA fitted by springs. A physical intuition for least squares in many dimensions.

- Biplots: observations and variables in the same low-D view.

- **Figure 5.26**: PCA morphing into t-SNE for the Diabetes data. What nonlinear methods gain and what they give up.

- Optional: variable ordering for data displays; eigenfaces; outlier detection in the last dimensions.

### 4. Plots for models with one response (core, ~7 min)

- The "regression quartet" and what it does and does not tell you (Ch 7).

- Coefficient displays and effect displays.

- **Figure 7.27**: added-variable plots for the Duncan data, showing how *minister* and *conductor* pull the fitted lines. Leverage and influence made visible.

- Optional (Ch 8): ellipsoids in data space and beta space; measurement error.

### 5. Collinearity and ridge regression (optional, or core if section 2 is trimmed, ~6 min)

- What collinearity is and how to see it: tableplots, collinearity biplots (Ch 9).

- Ridge regression as shrinkage.

- **Figure 9.13**: the scatterplot matrix of bivariate ridge trace plots for the Longley data. Shrinkage as the path of a confidence ellipse, not just a set of traces.

- Low-rank views.

### 6. The HE plot framework (core, ~10 min)

- From the *t*-test to Hotelling's *T*² (Ch 10).

- **Figure 10.9**: the HE framework for two groups. Data ellipses become **E**; group means become **H**; the discriminant axis is where they differ most.

- HE plots for MANOVA: significance vs. effect scaling, contrasts and linear hypotheses, HE plot matrices (Ch 12).

- Low-D views: canonical discriminant analysis.

- **Figure 12.17**: HE plot for the school data. With quantitative predictors, each effect is a line whose length shows strength and whose direction shows its relation to the responses.

- Optional: canonical correlation; MANCOVA; factorial designs.

### 7. Checking multivariate models (core, ~6 min)

- **Figure 11.18**: the distance plot for the school data. Residual distance against predictor distance: a multivariate version of the outlier/leverage plot.

- Multivariate influence: "The Mysterious Case 9" (Ch 14).

- Robust MLMs: observation weights for the penguins, and the fates of "Cyrano" and "HookNose".

- Optional (Ch 13): visualizing equality of covariance matrices, Box's *M*, and a multivariate analog of Levene's test.

### 8. Discriminant analysis (optional, ~5 min)

- Classification in data space and in discriminant space; prediction regions (Ch 15).

- Relation to MANOVA and canonical discriminant analysis.

### 9. Closing (core, ~2 min)

- Multivariate thinking: the same few ideas (ellipses, projections, low-D views) used throughout.

- Where to get the book, the online version, and the packages.

## Timing

| Version | Sections | Approx. time |
|---|---|---|
| Core | 1, 2, 3, 4, 6, 7, 9 | ~45 min |
| Core + ridge | add 5 | ~50 min |
| Full | add 5 and 8 | ~55 min |

All seven of the organizer's figures are in the core version except Figure 9.13, which needs section 5. To keep it within 45 minutes, trim section 2 to the data ellipse and the penguins.

## Format: PowerPoint or Quarto/reveal.js?

| | PowerPoint | Quarto / reveal.js |
|---|---|---|
| Editing | Direct, familiar | Edit `.qmd` source and re-render |
| Figures from the book | Insert the PNG/GIF files from `figs/` and `images/` | Reference the same files by path; could also re-run chunks |
| Animated GIFs (Figs 5.5, 5.26) | Play in slide show mode | Play in the browser |
| Equations | Equation editor or images | LaTeX, as in the book |
| Reuse for later talks | Copy and edit the deck | Copy and edit the `.qmd` |
| Sharing | `.pptx` or PDF | A web page; PDF export is less reliable |

Suggestion: PowerPoint for this first talk, since direct editing matters most and every figure wanted already exists as an image file.
