# Exercise Ideas by Chapter

Notes on potential exercises: (E) = extending a chapter example; (D) = different dataset.
Model exercise file: `exercises/Ch12-exercises.qmd` (Hernior MMRA).
All exercise code chunks must use `eval: false`, `code-fold: true`, `code-summary: "Show the code"`.
Include `data(Dataset, package = "pkg")` in the first chunk.

---

## Ch 03 — Getting Started

**Key datasets:** `datasets::anscombe`, `datasauRus`, `carData::Davis`, US 1970 Draft Lottery

- (E) The `datasauRus` package contains 12+ datasets with identical summary statistics but
  different shapes. Pick 3 or 4; show them together with summary statistics and scatterplots.
  What does this tell you about the importance of visualization?
- (E) The Davis data has a famous influential observation (a data entry error). Use
  `car::influencePlot()` or `plot(lm(...))` to identify it; refit the model without it.
  How does the regression change?
- (D) The 1970 Draft Lottery analysis used smoothing to expose the bias. Apply the same
  approach (monthly means + smoother) to a different time-indexed process of your choice
  to check for systematic patterns.

---

## Ch 04 — Multivariate Plots

**Key datasets:** `carData::Salaries`, `palmerpenguins::penguins`, US crime data

- (E) Extend the `Salaries` scatterplot matrix to include the `sex × discipline` interaction.
  Use stratified smoothers and data ellipses to show whether the sex gap in salary differs
  by discipline.
- (E) Redo the penguins parallel coordinate plot with variables ordered by effect size
  (most discriminating first). Compare to alphabetical ordering. Which reveals group
  separation more clearly?
- (D) Apply the full suite of Ch 04 visualizations (pairs plot, parallel coordinates,
  corrgram) to the `heplots::NeuroCog` data. Which methods are most useful for a
  clinical dataset of this type?

---

## Ch 05 — PCA and Biplots

**Key datasets:** `datasets::iris`, `palmerpenguins::penguins`, US crime data

- (E) For the crime PCA biplot, add a second biplot with the states labeled by region
  (Northeast, South, Midwest, West). Do regions cluster in PC space? Which crime types
  drive regional differences?
- (E) Use `factoextra::fviz_eig()` to plot the scree plot for the iris PCA. How many
  components does the elbow rule suggest? Compare to the 80% cumulative variance criterion.
- (D) Apply PCA and a biplot to the `heplots::NeuroCog` data (6 neurocognitive measures).
  Do the patient groups (schizophrenia, schizoaffective, control) separate in the first
  two PCs? Add group ellipses to the biplot.
- (D) Apply PCA to `carData::Salaries` (numeric variables only). Interpret the first two
  components. Does the biplot reveal anything about the salary structure that the
  scatterplot matrix in Ch 04 missed?

---

## Ch 07 — Regression Plots

**Key datasets:** `carData::Duncan`, `heplots::coffee`

- (E) The Duncan data analysis found that `minister` and `conductor` are highly influential.
  Use `car::avPlots()` to show the added-variable plots before and after removing them.
  How does the slope for `income` change?
- (E) The coffee/stress/heart disease example illustrates Simpson's paradox. Construct a
  similar artificial dataset where the marginal and conditional correlations have opposite
  signs; visualize it with data ellipses.
- (D) Fit a multiple regression to the `carData::Prestige` data (prestige ~ income +
  education + women). Use `effects::allEffects()` to display the marginal effects plots.
  Which predictor has the largest standardized effect?

---

## Ch 08 — Linear Model Topics

**Key datasets:** `heplots::coffee`

- (E) Visualize the data space and β space for the coffee example simultaneously (side by
  side). Annotate both plots to show how the data ellipse shape in one corresponds to
  the confidence ellipse shape in the other.
- (D) Choose a dataset with two correlated predictors (e.g., `carData::Salaries` with
  `yrs.since.phd` and `yrs.service`). Show the confidence ellipse for the two coefficients
  under OLS. Then add 10% noise to `yrs.service` (simulating measurement error) and refit;
  overlay the new confidence ellipse. What changes?

---

## Ch 09 — Collinearity and Ridge Regression

**Key datasets:** Synthetic collinear data, various regression examples

- (E) Use `VisCollin::colldiag()` to produce a tableplot for a dataset of your choice with
  moderate collinearity. Identify which pairs of predictors are most problematic.
- (E) For a collinear dataset, fit ridge regression across a range of λ values using
  `genridge::ridge()`. Plot the bivariate ridge trace for the two most collinear
  predictors. At what λ do the confidence ellipses first become reasonable?
- (D) Apply the collinearity diagnostic pipeline (VIF, tableplot, collinearity biplot) to
  `carData::Prestige` (all numeric predictors). Is collinearity a problem here?

---

## Ch 10 — Hotelling's T²

**Key datasets:** `heplots::mathscore`, `palmerpenguins::penguins`

- (E) Apply Hotelling's T² to compare Adelie vs. Chinstrap penguins on all four body
  measurements. Create an HE plot for each pair of variables. Which variable pair shows
  the greatest separation?
- (D) Use `heplots::mathscore`: compare the two groups on both scores with a T² test and
  HE plot. Show the discriminant axis. How does it relate to the line connecting the
  two group means?
- (D) Find two groups in the `carData::Salaries` data (e.g., discipline A vs. B) and
  compare `salary` and `yrs.service` jointly with T². Is the multivariate test more
  significant than either univariate t-test?

---

## Ch 11 — MLM Review

**Key datasets:** School performance data, plastic film data

- (E) Fit separate univariate models for each response in a MANOVA dataset, then fit the
  full MLM. Extract and compare the H and E matrices. Show numerically that the MLM
  H + E = total SSP.
- (D) Apply a two-way MANOVA to `heplots::peng` (species × sex as factors; body
  measurements as responses). Test for main effects and interaction. Which factor
  accounts for more multivariate variance?

---

## Ch 12 — MLM Visualization (HE Plots)

**Key datasets:** `heplots::dogfood`, `datasets::iris`, `heplots::MockJury`, `heplots::NLSY`,
`heplots::schooldata`

- (E) **Hernior MMRA** [DONE: `exercises/Ch12-exercises.qmd`] — `heplots::Hernior` recovery
  from herniorrhaphy; parts (a)-(e) cover `Anova()`, R², `linearHypothesis()`, HE pairs
  plot, `candiscList()`.
- (E) Create a two-way MANOVA HE plot for the iris data (species as factor; add a synthetic
  second factor, e.g., collection site). Show how the interaction ellipse relates to the
  main effect ellipses.
- (D) Apply MMRA to `heplots::NLSY` with `post`, `read`, and `math` as responses and
  socioeconomic predictors. Create an HE pairs plot. Which predictor has the most
  consistent effect across all three responses?
- (D) Use `heplots::MockJury`: fit a MANOVA for the verdict-related response variables by
  `Attr` (physical attractiveness of defendant). Create significance-scaled and
  effect-scaled HE plots; compare what each emphasizes.

---

## Ch 13 — Equality of Covariance

**Key datasets:** `palmerpenguins::penguins`, `datasets::iris`

- (E) Test and visualize equality of covariance matrices for all three penguin species on
  bill length and bill depth. If Box's M is significant, fit both LDA and QDA; compare
  the decision boundaries visually.
- (D) Apply the covariance visualization pipeline (centered ellipses, Box's M, Levene-
  MANOVA) to `datasets::iris`. The iris dataset is well-known to have heterogeneous
  covariances — confirm this and show which species drives the heterogeneity.

---

## Ch 14 — Influence and Robust Estimation

**Key datasets:** `heplots::schooldata`, `heplots::NLSY`

- (E) For the school data MLM, identify the most influential cases with `mvinfluence::influencePlot()`.
  Delete them one at a time and track the change in canonical correlations. At what point
  does the model become stable?
- (D) Fit a MANOVA to `heplots::peng` (species as factor; body measurements as responses).
  Run multivariate influence diagnostics. Are the influential cases concentrated in any
  particular species?

---

## Ch 15 — Case Studies (NeuroCog)

**Key datasets:** `heplots::NeuroCog`, `heplots::SocialCog`

- (E) Replicate the NeuroCog canonical discriminant analysis, but use only the schizophrenia
  and control groups (binary comparison). Does the two-group analysis give a cleaner
  picture than the three-group analysis?
- (D) Combine `NeuroCog` and `SocialCog` into a joint analysis (if the same subjects appear
  in both). Fit a MANOVA across all cognitive and social domains simultaneously.
  Which group differences are most consistent across domains?

---

## Ch 21 — Discriminant Analysis

**Key datasets:** `datasets::iris`, `palmerpenguins::penguins`

- (E) Train LDA on 80% of the penguins data; classify the held-out 20%. Show the
  confusion matrix and classification accuracy. Display the misclassified cases in the
  LD1/LD2 plot — where do they fall relative to the decision boundaries?
- (E) Compare LDA vs. QDA on penguins (which violates the equal-covariance assumption).
  Overlay the linear and quadratic decision boundaries in LD space; quantify the
  improvement in classification accuracy.
- (D) Apply LDA to `heplots::NeuroCog` (three diagnostic groups). How many discriminant
  dimensions are significant? Plot LD1 vs. LD2 with group ellipses and structure
  coefficient vectors. Which neurocognitive measures best separate the groups?

---

## Datasets Worth More Coverage

These datasets appear briefly or in passing but are rich enough for standalone exercises:

| Dataset | Package | Notes |
|---------|---------|-------|
| `Swiss` | `datasets` | Fertility + socioeconomic; classic multivariate regression |
| `Rohwer` | `heplots` | SES + learning tasks; MANCOVA example |
| `foothead` | `heplots` | Head measurements; good for T² / discriminant |
| `Duncan` | `carData` | Good for influence + added-variable exercises |
| `Arrests` | `carData` | Logistic-adjacent; extend to multivariate responses |
| `Harman23.cor` | `datasets` | Correlation matrix; PCA/factor analysis starting point |
