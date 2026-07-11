# Abstract Notes — Source Material per Chapter

Working notes for drafting chapter abstracts, per Step 1–2 of `abstract-plan.md`. Distilled from the chapter `.qmd` content itself (summary child files excluded). Chapter numbering verified against `_quarto.yml`: Ch 1 = `01-Prelude.qmd`, Ch 2 = `02-intro.qmd`, Ch 3 = `03-getting_started.qmd`.

## Chapter 1 — Warm-up Exercises (`01-Prelude.qmd`)

**Topic:** Motivating multivariate thinking and visualization in higher dimensions; historical and conceptual warm-up for the book.

**Sections / content skeleton:**

- The magic of graphs: Hubbard quotes; 1900–1950 as the "Modern Dark Ages" of data visualization; rebirth via John Tukey's exploratory data analysis (EDA).
- Graphic discoveries 1900–1950: Maunder's butterfly diagram (sunspots), Hertzsprung–Russell diagram (stellar evolution), Moseley's plots establishing atomic number.
- ONE, TWO, MANY (John Hartigan): classification of all statistical/graphical methods as univariate (1D), bivariate (2D), multivariate (nD); half-integer cases 1.5D, 2.5D.
- Flatland (Edwin Abbott, 1884): parable for imagining higher dimensions via projection, analogy, motion over time; tesseract; Minkowski/Einstein 4D spacetime.
- EUREKA: 1986 Data Exposition pollen dataset; 5-dimensional haystack; zooming a 3D scatterplot reveals hidden word "EUREKA"; scagnostics (Tukey & Tukey; Wilkinson) and projection pursuit (Friedman & Tukey).
- Multivariate scientific discoveries: Galton's anticyclonic weather pattern discovery; Reaven & Miller's discovery of two distinct classes of Type 2 diabetes using PRIM-9 (first interactive high-D visualization system).

**Datasets:** `pollen` (animation / HistData::Pollen), `Diabetes` (heplots).

**Packages:** rgl, animation, scagnostics, cassowaryr, heplots.

**Methods/terms:** high-dimensional data, projection, 3D scatterplot, exploratory data analysis (EDA), scagnostics, projection pursuit, interactive/dynamic graphics, PRIM-9.

**Must-use keywords:** multivariate thinking; high-dimensional data; data visualization history; exploratory data analysis (EDA); Flatland; dimensions; projection; 3D scatterplot; R.

## Chapter 2 — Introduction (`02-intro.qmd`)

**Topic:** Why multivariate designs and multivariate thinking; the multivariate linear model; why visualization is harder with multiple responses.

**Sections / content skeleton:**

- Why use a multivariate design: psychological/social constructs (depression, academic achievement, self-concept) are inherently multidimensional; questions univariate analyses can't answer (do predictors affect all outcomes? same or different ways? how many dimensions?).
- Statistical advantages: increased power (pooling effects across correlated responses), avoids inflated Type I error from multiple tests, insight into how outcomes vary jointly, dimension reduction.
- Multivariate ≠ multivariable: multivariable = one response, many predictors (multiple regression); multivariate = several response variables (MANOVA, multivariate multiple regression, canonical correlation, PCA).
- Ubiquity: York University graduate course bibliographic database (405 exemplars); MANOVA, factor analysis, multiple regression, PCA most frequent; heatmap + wordcloud figures.
- Linear models univariate → multivariate: y = Xβ + ε generalizes to Y = XB + E; all fit in R by `lm()` (objects of class "mlm").
- Visualization is harder: data ellipsoids as minimally sufficient visual summaries; Hypothesis-Error (HE) plot framework; "multivariate juicer" = projection to low-D space; animated tours, biplots, canonical correlation and canonical discriminant HE plots; Hofstadter GEB cover as projection metaphor.
- Problems in understanding/communicating MLM results (from consulting practice): atomistic model checking; "Bonferroni everywhere" (unneeded; multivariate tests protect); reverting to univariate visualizations.

**Datasets:** none central (heatmap/wordcloud images from course bibliography).

**Packages:** methods implemented in heplots, candisc (book's core packages); `lm()` function.

**Methods/terms:** multivariate linear model (MLM), MANOVA, multivariate multiple regression, canonical correlation, data ellipse/ellipsoid, HE plots, statistical power, Type I error, dimension reduction.

**Must-use keywords:** multivariate analysis; multivariate linear models (MLM); multivariate analysis of variance (MANOVA); multivariate vs multivariable; statistical power; Type I error; HE plots; data ellipsoid; R; lm().

## Chapter 3 — Getting Started (`03-getting_started.qmd`)

**Topic:** Why plot your data: classic cautionary stories, then a taxonomy of plots for data analysis.

**Sections / content skeleton:**

- Opening: Farquhar "sunlight from a cucumber"; brief history — Playfair's charts, first scatterplot, thematic maps, Golden Age of Graphics (1860–1890).
- Why plot your data — three stories:
  - Anscombe's Quartet: four datasets, identical means/SDs/correlations/regression lines, vastly different in plots; labeled pure error, lack of fit, outlier, influence; recreated with ggplot2 (facets, stat_ellipse data ellipses). Callouts: Datasaurus Dozen (datasauRus, metamer packages, simulated annealing/statistical metamers); other quartets (causal, Rashomon; quartets package).
  - One lousy point can ruin your day: Davis data (carData::Davis), reported vs measured weight; one mis-recorded female observation drags the slope for women to 0.26; influence requires unusual in both x and y; plots reveal reasons and corrective action.
  - 1970 US draft lottery (Vietnam War): vcdExtra::Draft1970; weak signal in noise; scatterplot looks random; regression line + loess smoother reveal trend; visual summaries (monthly means with error bars, visual thinning); flaw = inadequate mixing of capsules; could have used R's sample().
- Plots for data analysis taxonomy: data plots, reconnaissance plots (scatterplot matrices, corrgrams), dimension reduction plots ("multivariate juicers": PCA, biplots, MDS, canonical space), model plots, conditional plots (added-variable, effect plots), diagnostic plots.
- Diagnostic plots: regression quartet from `plot()` of an `lm()` model on the Davis data; point identification flags the erroneous case.

**Datasets:** `anscombe` (datasets), Datasaurus Dozen (datasauRus), `Davis` (carData), `Draft1970` (vcdExtra).

**Packages:** ggplot2, tidyverse, broom, datasauRus, metamer, quartets, carData, vcdExtra, tinytable, gt.

**Methods/terms:** scatterplot, regression line, loess smoothing, data ellipse, outliers, influential observations, regression diagnostics, summary statistics, visual thinning.

**Must-use keywords:** plot your data; Anscombe's quartet; Datasaurus Dozen; summary statistics; scatterplot; regression; loess smoothing; outlier; influential observations; regression diagnostics; ggplot2; R.

## Chapter 4 — Plots of Multivariate Data (`04-multivariate_plots.qmd`)

Numbering verified against `_quarto.yml`: Ch 4 = `04-multivariate_plots.qmd`, Ch 5 = `05-pca-biplot.qmd`, Ch 6 = `06-linear_models.qmd`. (`04b-higher.qmd` is not in `_quarto.yml` and not included as a child of Ch 4, so it is not part of the rendered book.)

**Topic:** A toolbox of basic graphical methods for visualizing multivariate data: enhanced scatterplots through reconnaissance plots to animated tours and network diagrams.

**Sections / content skeleton:**

- Bivariate summaries: annotating scatterplots with smoothers (linear regression, polynomial, loess), stratifiers (color/shape for subgroups), conditioning (multi-panel displays). Salaries example (academic salaries vs years since PhD; rug plots, jittering).
- Data ellipses: concentration ellipse as sufficient visual summary of means, SDs, correlation, regression slope under bivariate normality; Mahalanobis vs Euclidean distance; drawing via Cholesky factor; contour levels via qchisq; `car::dataEllipse()`, `ggplot2::stat_ellipse()`; log-scale for nonlinearity (Prestige data); stratifying by groups.
- Meet the penguins: `heplots::peng` (Palmer penguins, palmerpenguins pkg), 3 species (Adélie, Chinstrap, Gentoo), bill length/depth, flipper length, body mass; custom color scales; visual thinning.
- Bagplots: robust nonparametric 2D boxplot generalization (bag, fence, loop; data depth); `gggda::geom_bagplot()`.
- Non-parametric bivariate density plots: kernel density; `geom_density_2d()`, `ggdensity::geom_hdr()` high-density regions.
- Simpson's paradox: marginal vs conditional relationships; penguin bill dimensions example.
- Multivariate normality and outliers: Mahalanobis D², chi-square QQ plot (`heplots::cqplot()`) with confidence envelope; Galton parent-child heights (HistData); penguin outliers.
- Scatterplot matrices: `pairs()`, `car::scatterplotMatrix()` with regression lines, loess smooths, data ellipses; Prestige data; visual thinning with crime data.
- Corrgrams: visual displays of correlation matrices (`corrgram`, `corrplot` packages); effect ordering of variables; crime data (rates of 7 crimes in 50 U.S. states, `ggbiplot::crime`).
- Generalized pairs plots: `GGally::ggpairs()` with categorical + quantitative variables (penguins).
- Parallel coordinate plots: `ggpcp` package; history corner (d'Ocagne, Gannett, Guerry, Inselberg, Wegman).
- Animated tours: grand tour (Asimov), guided tours / projection pursuit, projections as shadows (Hofstadter GEB cover); `tourr` package (tour paths + display methods; animate/render).
- Network diagrams: correlation networks, nodes/edges, graphical LASSO; Big Five personality items (psych::bfi); `qgraph`, igraph, ggraph; partial correlations and partial variables plots (pvPlot) for crime data.

**Datasets:** `Salaries` (carData), `Prestige` (carData), `peng` (heplots; Palmer penguins), `Galton` (HistData), `crime` (ggbiplot), `bfi` (psych).

**Packages:** ggplot2, car, GGally, ggpcp, tourr, corrplot, corrgram, ggdensity, gggda, heplots, qgraph, dplyr, tidyr, patchwork.

**Methods/terms:** scatterplot annotations, smoothers (loess), data ellipse, Mahalanobis distance, bagplot, kernel density, Simpson's paradox, multivariate normality, chi-square QQ plot, outlier detection, scatterplot matrix, corrgram, generalized pairs plot, parallel coordinate plot, grand tour, projection pursuit, network diagram, partial correlations, visual thinning.

**Must-use keywords:** multivariate data visualization; scatterplot matrix; data ellipse; parallel coordinate plot; corrgram / correlation matrix; Palmer penguins; multivariate outliers; Mahalanobis distance; animated tours; network diagram; ggplot2; R.

## Chapter 5 — Dimension Reduction (`05-pca-biplot.qmd`)

**Topic:** Dimension reduction, focusing on principal component analysis (PCA) and biplots; "multivariate juicers" that squeeze high-D data into informative low-D views.

**Sections / content skeleton:**

- Flatland and Spaceland: A Square's dream of projecting a high-D point cloud; multivariate juicers = dimension reduction techniques.
- PCA: Pearson (1901) line/plane of closest fit — first truly multivariate problem in statistics; PCA by springs (physical least-squares demo); mathematics and geometry (eigenvectors/eigenvalues, axes of the data ellipsoid); workers data (matlib) small example; finding PCs with `prcomp()`/`princomp()`, FactoMineR::PCA; centering/scaling choices (correlation vs covariance matrix); crime data PCA; screeplots (variance proportions, broom::tidy, factoextra); visualizing scores and variable vectors.
- Biplots: Gabriel (1971); SVD construction, low-rank approximation, biplot scaling α (row-principal GH, column-principal JK, symmetric); `ggbiplot`, factoextra, stats::biplot; crime data biplot with state labels + region data ellipses; contributions and quality; supplementary variables (state.x77 characteristics projected into crime biplot); Diabetes data example (ReavenMiller; 3D rgl plots via car::scatter3d, groups Normal / Chemical / Overt diabetic).
- Nonlinear dimension reduction: multidimensional scaling (MDS, nonmetric MDS via MASS::isoMDS; Torgerson, Shepard, Kruskal); t-SNE (Rtsne package, perplexity, KL divergence) — compared with PCA on Diabetes data.
- Application: variable ordering for data displays (effect ordering, principal component variable ordering / AOE, seriation; mtcars corrplot example).
- Application: eigenfaces — PCA/SVD for image compression; Mona Lisa reconstruction; machine-learning feature extraction, principal components regression.
- Elliptical insights: outlier detection — outliers in data space stand out on the smallest PC dimension; penguin outliers in biplot.

**Datasets:** `workers` (matlib), `crime` (ggbiplot), `Diabetes` (heplots), `mtcars`, `state.x77`, Mona Lisa image, `peng` (heplots).

**Packages:** ggbiplot, FactoMineR, factoextra, matlib, car, ggplot2, dplyr, patchwork, ggpubr, MASS (isoMDS), Rtsne, corrplot.

**Methods/terms:** dimension reduction, principal component analysis (PCA), eigenvalues/eigenvectors, singular value decomposition (SVD), screeplot, biplot, supplementary variables, multidimensional scaling (MDS), t-SNE, variable ordering / effect ordering, eigenfaces, image compression, outlier detection, principal components regression.

**Must-use keywords:** dimension reduction; principal component analysis (PCA); biplot; singular value decomposition (SVD); screeplot; multidimensional scaling (MDS); t-SNE; eigenfaces; ggbiplot; factoextra; outlier detection; R.

## Chapter 6 — Overview of Linear Models (`06-linear_models.qmd`)

**Topic:** Review of univariate linear models — regression, ANOVA, ANCOVA within the general linear model — as the foundation that generalizes to multivariate linear models; R model formulas, model matrices, and contrast coding.

**Note:** The chapter is comparatively short; sections on Regression / ANOVA / ANCOVA details are currently commented out. Content is: key ideas, history corner, model formulas, model matrices, contrasts.

**Sections / content skeleton:**

- Key ideas: regression and ANOVA differ only in quantitative vs discrete-factor predictors; both are the general linear model (GLM), fit with `lm()`; extends directly to multivariate responses (also `lm()`); binary/categorical outcomes → generalized linear model via `glm()` (logistic regression); techniques table classified by number/type of predictors and responses; multivariate multiple regression (MMRA), canonical correlation mentioned as generalizations.
- History corner "Twins reared apart": regression (Galton heredity, Pearson) vs ANOVA (Fisher, Rothamsted crop experiments) grew up separately; synthesis into the general linear model in the 1960s (Scheffé, Graybill, Winer; MULTIVARIANCE, MANOVA, BMD programs) and birth of the multivariate linear model (Bock, Finn).
- The general linear model: y = Xβ + ε notation; regressors: quantitative variables, transformations, polynomials/splines, factors as d−1 columns, interactions as products.
- Model formulas: Wilkinson-Rogers notation (`response ~ terms`); operators +, -, *, :, ^, I(), poly(); examples for regression models; workers data example — linear and quadratic fits, interpreting poly() coefficients (raw vs orthogonal).
- Factors, crossing, powers: formula shorthand for one-way/two-way/factorial ANOVA, ANCOVA models.
- Model matrices: `model.matrix()`; dummy variables for factors; interaction columns.
- Coding factors and contrasts: choice of coding scheme changes meaning of parameters / testable hypotheses; treatment (dummy) coding, deviation coding (contr.sum), Helmert contrasts for ordered factors, orthogonal polynomial contrasts (contr.poly, Gram-Schmidt), custom contrasts and nested dichotomies (political parties; psychiatric diagnostic groups examples; nestedLogit package).

**Datasets:** `workers` (matlib), small simulated examples (income/occupation type, political parties, psychiatric groups).

**Packages:** ggplot2, dplyr, nestedLogit; also matlib (GramSchmidt), equatiomatic (extract_eq).

**Methods/terms:** general linear model, linear regression, analysis of variance (ANOVA), analysis of covariance (ANCOVA), model formula, model matrix, dummy variables, contrasts (treatment, sum/deviation, Helmert, polynomial), orthogonal contrasts, nested dichotomies, lm(), glm(), logistic regression.

**Must-use keywords:** linear models in R; general linear model; regression; analysis of variance (ANOVA); lm(); model formula; model matrix; contrasts; dummy coding; factors; R.

## Chapter 7 — Plots for Univariate Response Models (`07-linear_models-plots.qmd`)

Numbering verified against `_quarto.yml`: Ch 7 = `07-linear_models-plots.qmd`, Ch 8 = `08-lin-mod-topics.qmd`, Ch 9 = `09-collinearity-ridge.qmd`.

**Topic:** Graphical methods for understanding and diagnosing univariate response models fit by `lm()`: diagnostic plots, coefficient plots, added-variable and component+residual plots, effect displays, and plots for outliers, leverage and influence.

**Sections / content skeleton:**

- The regression quartet: default diagnostic plots from `plot(model)` — residuals vs fitted, normal QQ plot of studentized residuals, scale-location, residuals vs leverage with Cook's distance contours; reference lines/smooths and labeling of unusual observations; nicer versions via `performance::check_model()` (easystats suite).
- Example: Duncan's occupational prestige (carData::Duncan; income, education, prestige as percents from 1950 US Census). Duncan's hypothesis of equal income/education slopes tested with `car::linearHypothesis()`, Wald test (spida2), and visualized with a joint confidence ellipse (`car::confidenceEllipse()`) whose shadow gives a CI for the slope difference.
- Example: Canadian occupational prestige (carData::Prestige) — regression quartet for main-effects model.
- Coefficient displays: tables via `modelsummary()`, `lmtest::coeftest()`, `broom::tidy()`; coefficient plots via `modelplot()`; problem of raw coefficients on different scales → standardized coefficients (`standardize = "refit"`) or rescaling predictors to meaningful units; `ggstats::ggcoef_model()` / `ggcoef_compare()` handle factors better.
- Added-variable (partial regression) plots: marginal scatterplots are misleading with correlated predictors; coffee–stress–heart example (matlib::coffee) where marginal slope for coffee is positive but partial slope negative (confounding; Simpson's paradox in regression). Construction via residuals from auxiliary regressions; `car::avPlots()`; properties (same slope, residuals, SE as full model; shows partial leverage/influence and partial correlation). Marginal–conditional plots (`car::mcPlots()`) animate/overlay the marginal → conditional transition.
- Prestige AV plots: physicians/general managers pull income slope; loess smooth in AV plot suggests nonlinearity (with caveat from Cook 1996).
- Component + residual (partial residual) plots: `car::crPlots()` to diagnose nonlinearity and suggest predictor transformations (income → log scale; quadratic for women).
- Effect displays (John Fox): predicted response for focal predictors over their range, others held at typical values; `effects::predictorEffects()`, `allEffects()`; partial residuals show fit + lack of fit; alternatives **ggeffects**, **marginaleffects**; example: model with `log10(income)*type` interaction interpreted via multiline effect plot on log scale.
- Outliers, leverage, influence: three archetypes (outlier, good/bad leverage); influence = leverage × residual; leverage-influence quartet demo with data ellipses; hat values (proportional to Mahalanobis D²); studentized (deleted) residuals; DFFITS, Cook's distance; influence plots (`car::influencePlot()`, bubble = Cook's D); Duncan data: minister and conductor jointly influential — removing them overturns the equal-slopes conclusion; influence seen directly in AV plots.

**Datasets:** `Duncan` (carData), `Prestige` (carData), `coffee` (matlib), simulated leverage-influence quartet data.

**Packages:** car, effects, ggeffects, marginaleffects, modelsummary, performance, easystats, ggstats, ggplot2, dplyr, lmtest, broom, spida2.

**Methods/terms:** regression diagnostics, regression quartet, residuals, QQ plot, coefficient plots, standardized coefficients, added-variable plot (partial regression plot), component + residual plot (partial residual plot), effect displays, partial residuals, confounding, outliers, leverage, hat values, studentized residuals, influence, Cook's distance, DFFITS, influence plot, confidence ellipse.

**Must-use keywords:** regression diagnostics; diagnostic plots; added-variable plots (partial regression plots); component-plus-residual plots; coefficient plots; effect displays; outliers; leverage; influential observations; Cook's distance; car package; R.

## Chapter 8 — Topics in Linear Models (`08-lin-mod-topics.qmd`)

**Topic:** Two deeper topics illuminated by ellipse geometry: the duality between data space and $\beta$ (coefficient) space, and the effects of measurement error in predictors on bias and precision of regression coefficients.

**Note:** Comparatively short chapter; two main sections (betaspace, measurement error).

**Sections / content skeleton:**

- Ellipsoids in data space and β space: axes of β space are model coefficients; points are models (OLS, WLS, ML estimates), lines are hypotheses. Duality: lines in data space ↔ points in β space and conversely (matlib::showEqn demo). Inverse relation (Dempster 1969): data ellipsoids based on S_X vs confidence ellipsoids for coefficients based on S_X⁻¹; eigenvectors identical, eigenvalues reciprocal — ellipse for the inverse is a 90° rotation/rescaling. Key insight: coefficients are estimated most precisely in directions where the data are most widely dispersed.
- Data ellipse and confidence ellipse: coffee–stress–heart data (revisiting AV-plot example); joint 95% confidence ellipse for (β_Coffee, β_Stress) via `car::confidenceEllipse()`; visual hypothesis tests (is H₀ point inside the ellipse?); Scheffé joint intervals from ellipse shadows; Bonferroni intervals; the confidence-interval generating ellipse (df = 1) whose shadows give individual 95% CIs equivalent to t-tests.
- Measurement error: OLS assumptions (fixed or error-free predictors); Gauss-Markov theorem, BLUE. Errors in predictors vs response: error in y increases MSE/standard errors but leaves coefficients unbiased; error in x biases the slope toward zero (attenuation bias, with convergence formula); errors-in-variables regression (Fuller 2006).
- The measurement error quartet: simulated regression with added error in x, y, neither, or both; ggplot2 faceted plots with data ellipses and confidence bands show unchanged vs attenuated slopes and inflated variance; model statistics (R, sigma) extracted per condition via dplyr::nest_by.
- Coffee data, bias and precision: adding increasing error to Stress attenuates its coefficient (data ellipses widen, confidence ellipses in β space drift toward β=0); surprising cross-effect — measurement error in one predictor (Stress) also biases the coefficient of another (Coffee) toward its marginal value.

**Datasets:** `coffee` (matlib/heplots), simulated measurement-error quartet data.

**Packages:** car (dataEllipse, confidenceEllipse), matlib, ggplot2, dplyr, tidyr, patchwork, heplots.

**Methods/terms:** data space, β space, duality, inverse matrices, data ellipse, confidence ellipse, joint confidence region, visual hypothesis test, Scheffé/Bonferroni intervals, Gauss-Markov theorem, BLUE, ordinary least squares, measurement error, errors-in-variables, attenuation bias, precision.

**Must-use keywords:** beta space; confidence ellipse; data ellipse; duality; joint confidence region; measurement error; attenuation bias; errors-in-variables; regression coefficients; bias and precision; R.

## Chapter 9 — Collinearity & Ridge Regression (`09-collinearity-ridge.qmd`)

**Topic:** Understanding, diagnosing, visualizing and remedying collinearity among predictors; ridge regression as a regularization remedy, visualized with generalized ridge trace plots.

**Sections / content skeleton:**

- What is collinearity: near-linear relations among predictors; consequences — inflated coefficient standard errors, deflated t-statistics, significant overall F with no significant predictors, numerical instability; "Where's Waldo" metaphor for finding signal in tables of diagnostics (Friendly & Kwan 2009). Visualizing: instability of the regression plane in 3D; data-space vs β-space views — confidence ellipses inflate as predictor correlation ρ grows.
- Measuring collinearity: variance inflation factor (VIF) and √VIF as standard-error multiplier; tolerance; generalized VIF (Fox & Monette 1992) for terms with >1 df; connection of VIF to diagonal of inverse correlation matrix R⁻¹; `car::vif()`, `performance::check_collinearity()` plot with colored danger zones.
- Collinearity diagnostics (Belsley et al.): eigenvalues/eigenvectors of predictor correlation matrix; condition indices κ = sqrt(λ₁/λⱼ) (>10 moderate, >30 severe); variance decomposition proportions; `VisCollin::colldiag()` with `fuzz` and `descending` for readable output.
- Tableplots (`VisCollin::tableplot()`): semi-graphic display of condition indices (colored squares) and variance proportions (scaled circles), making the collinearity pattern visually apparent.
- Collinearity biplots: biplot of the *smallest* PCA dimensions (`factoextra::fviz_pca_biplot()`) shows which predictors contribute to near-singular dimensions; also reveals multivariate outliers/high-leverage points (Buick Estate wagon in cars data).
- Example throughout: `cars` data (VisCollin) — 406 automobiles from 1982, predicting gas mileage (mpg) from cylinders, engine displacement, horsepower, weight, acceleration, year.
- Remedies: ignore for pure prediction; structural collinearity → center predictors in polynomial/interaction (response surface) models — Acetylene data (genridge) example, VIF ratios show improvement; model re-specification; principal components regression; regularization (ridge, lasso); Bayesian shrinkage priors.
- Ridge regression: adds k to diagonal of X'X; shrinkage matrix; penalized RSS formulation; geometry — locus of osculation where OLS covariance ellipses kiss the circular constraint region; SVD formulation — shrinkage factors d²/(d²+k) act most on smallest dimensions; effective degrees of freedom df_k; relation to principal components regression; HKB, LW, GCV criteria for choosing k.
- genridge package: `ridge()`, `traceplot()` (univariate ridge trace plots vs k or df); critique — univariate traces show bias but not precision. Bivariate ridge trace plots (`plot.ridge()`, `pairs.ridge()`): confidence ellipses for pairs of coefficients shrink and drift toward 0, showing bias AND precision; precision() and the bias-variance tradeoff plot; low-rank views: `pca()` of ridge objects — shrinkage acts only on the smallest dimensions; biplot view relates predictors to those dimensions.
- Example: Longley economic data (`longley`) — classic perverse collinear time series (GNP, Unemployed, Armed.Forces, Population, Year, GNP.deflator → Employed); VIF up to 1789.

**Datasets:** `cars` (VisCollin), `Acetylene` (genridge), `longley` (datasets), simulated data-space/β-space demo.

**Packages:** VisCollin, genridge, car, MASS, easystats/performance, factoextra, ggrepel, ggplot2, dplyr, patchwork, glmnet (mentioned).

**Methods/terms:** collinearity (multicollinearity), variance inflation factor (VIF), generalized VIF, tolerance, condition indices, variance decomposition proportions, tableplot, collinearity biplot, centering, response surface models, principal components regression, ridge regression, regularization, shrinkage, LASSO, bias-variance tradeoff, ridge trace plots (univariate, bivariate), confidence ellipse, SVD, effective degrees of freedom.

**Must-use keywords:** collinearity; multicollinearity; variance inflation factor (VIF); condition indices; collinearity diagnostics; ridge regression; regularization; shrinkage; ridge trace plots; bias-variance tradeoff; biplot; VIF in R; R.

## Chapter 10 — Hotelling's T² (`10-hotelling.qmd`)

Numbering verified against `_quarto.yml`: Ch 10 = `10-hotelling.qmd`, Ch 11 = `11-mlm-review.qmd`, Ch 12 = `12-mlm-viz.qmd` (part "Multivariate Linear Models").

**Topic:** Hotelling's T² as the gateway from the univariate t-test to MANOVA; springboard for the HE plot framework; first taste of discriminant analysis and the discriminant axis.

**Sections / content skeleton:**

- T² as a generalized t-test: one-sample t² → T² = N (x̄ − μ₀)ᵀ S⁻¹ (x̄ − μ₀) = N × squared Mahalanobis distance between mean vector and hypothesized means in the metric of S.
- T² properties: maximum univariate t² over all linear combinations w = Xa; T² as the one non-zero eigenvalue of Q_H relative to Q_E (leading to Wilks' Λ, Pillai/Hotelling-Lawley trace, Roy's test in bigger designs); eigenvector = (raw) discriminant coefficients; exact F transformation F* = (N−p)/(p(N−1)) T²; invariance under linear (affine) transformation; two-sample test with pooled covariance matrix S_p.
- Mathscore example (`heplots::mathscore`): two groups of students, tests of basic math (BM) and word problems (WP); `Hotelling::hotelling.test()` and `car::Anova()` on `lm(cbind(BM, WP) ~ group)`; separate univariate t-tests mislead (BM "not significant") because they ignore the correlation of responses; data ellipses via `heplots::covEllipses()` show groups widely separated along a ~45° direction; pooled S_p.
- HE plot and discriminant axis: H = data ellipse of fitted values (rank 1 → plots as a line through the group means); E = data ellipse of residuals; `heplots::heplot()`; visual test of significance (H projects outside E iff significant); the H line is the discriminant axis; overlay of data ellipses + HE plot + projections of points onto the discriminant axis.
- Discriminant analysis: `MASS::lda()`; discriminant weights a = S⁻¹(x̄₁ − x̄₂); t-test of discriminant scores reproduces T²; violin plots comparing groups on BM, WP, and LD1 (groups much further apart on the discriminant axis).
- More variables — banknote example (`mclust::banknote`): six size measures on 100 genuine and 100 counterfeit Swiss 1000-franc banknotes; overlaid violin + boxplots (Graph craft box: layers, alpha transparency); PCA + biplot (`ggbiplot`) as "multivariate juicer" 2D summary; one-way MANOVA via `car::Anova()`; all four multivariate test statistics identical for 1-df (two-group) tests; multivariate F (392) vs average univariate F (236) — power gained from correlations.
- Variance accounted for: η² generalized to MLMs; `heplots::etasq()` gives 92% for banknote model, vs 70% in two PCA dimensions; PCA vs MANOVA goals.
- The grand scheme: HE plot framework diagram — data ellipses → HE plot → discriminant/canonical space; forward pointer to canonical discriminant analysis.

**Datasets:** `mathscore` (heplots), `banknote` (mclust).

**Packages:** car, heplots, Hotelling, ggplot2, dplyr, tidyr, ggbiplot, broom, MASS (lda).

**Methods/terms:** Hotelling's T², multivariate test, Mahalanobis distance, data ellipse, pooled covariance matrix, HE plot, hypothesis (H) and error (E) matrices, visual test of significance, discriminant axis, linear discriminant analysis, discriminant scores, MANOVA, eigenvalue/eigenvector, exact F test, biplot, PCA, eta-squared, effect size, violin plot.

**Must-use keywords:** Hotelling's T-squared (T^2); multivariate test; MANOVA; hypothesis-error (HE) plot; discriminant analysis; discriminant axis; data ellipse; Mahalanobis distance; heplots; R.

## Chapter 11 — Multivariate Linear Models (`11-mlm-review.qmd`)

**Topic:** Theory and practice of the multivariate linear model (MLM): structure, assumptions, fitting, multivariate test statistics, contrasts/linear hypotheses; MANOVA, factorial MANOVA, MMRA, MANCOVA; model diagnostics.

**Sections / content skeleton:**

- Structure of the MLM: Y = XB + E as the collection of p univariate models; why separate models fail (no simultaneous test; ignore correlations among responses — pooling strength, discovering the number of dimensions); X can contain quantitative, transformed, polynomial, factor, and interaction regressors.
- Assumptions: residuals multivariate normal N_p(0, Σ); homoscedasticity; independence; error-free X (exogeneity, omitted variable bias); correct specification (linearity, completeness, additivity).
- Fitting: B̂ = (XᵀX)⁻¹XᵀY; `lm(cbind(y1, y2, ...) ~ ...)` gives class "mlm"; robust alternative `heplots::robmlm()`.
- Dogfood example (`heplots::dogfood`): 4 formulas (Old, New, Major, Alps), responses start & amount; boxplots; `car::Anova()`.
- Sums of squares → SSP matrices: SSP_T = SSP_H + SSP_E (= H + E); visual decomposition figure; computing H and E directly; how big is H vs E → eigenvalues of HE⁻¹.
- Multivariate test statistics: Wilks' Λ (geometric mean), Pillai trace (arithmetic), Hotelling-Lawley trace (harmonic), Roy's maximum root (supremum); power/robustness guidance (Schatzoff, Olson; Pillai most robust, default in car); partial η² analogs via `heplots::etasq()`.
- Contrasts & linear hypotheses: general linear test H₀: CB = 0; `car::linearHypothesis()`; orthogonal contrasts / nested dichotomies decompose H additively into rank-1 tests (dogfood: Ours vs Theirs, Old vs New, Major vs Alps).
- ANOVA → MANOVA: conceptual diagrams (joint separation of centroids; number of dimensions of group differences); Parenting example (`heplots::Parenting`, 3 groups of fathers × caring/emotion/play): boxplots, covEllipses, univariate vs multivariate tests, contrast tests.
- Ordered factors: polynomial contrasts; AddHealth example (`heplots::AddHealth`, national adolescent-health survey): anxiety & depression across grades 7–12; means ± SE plots; joint linear/quadratic trend tests.
- Factorial MANOVA: Plastic film data (`heplots::Plastic`): tear, gloss, opacity ~ rate × additive; `ggpubr::ggline()` means + SE plots; MockJury data (`heplots::MockJury`): attractiveness of defendant photo × crime → Years sentence, Serious rating.
- MRA → MMRA: NLSY data (`heplots::NLSY`): math & reading ~ income, education (+ antisocial, hyperactivity tested jointly); overall tests via linearHypothesis; bivariate coefficient plots with confidence ellipses (`heplots::coefplot()`); School data (`heplots::schooldata`, 70 schools): reading, mathematics, self-esteem ~ education, occupation, visit, counseling, teacher.
- Model diagnostics: χ² QQ plots of residuals (`heplots::cqplot()`); formal multivariate normality tests (Mardia; `MVN::mvn()`); distance plot (`heplots::distancePlot()`, leverage vs residual distances, Rousseeuw); multivariate influence (`mvinfluence`, generalized hat values & Cook's D, `influencePlot()`); sensitivity test — refit without cases 44 & 59, relative coefficient change.
- ANCOVA → MANCOVA: group differences adjusting for covariates vs homogeneity-of-regression flavors; Rohwer data (`heplots::Rohwer`, low/high SES kindergarteners): SAT, PPVT, Raven ~ SES + paired-associate tasks (n, s, ns, na, ss); adjusted means; test homogeneity of slopes via SES × covariate interactions tested jointly; separate models per group.

**Datasets:** `dogfood`, `Parenting`, `AddHealth`, `Plastic`, `MockJury`, `NLSY`, `schooldata`, `Rohwer` (all heplots).

**Packages:** car, heplots, broom, MVN, mvinfluence, ggplot2, ggpubr, dplyr, tidyr, patchwork, matlib, ggrepel.

**Methods/terms:** multivariate linear model (MLM), MANOVA, factorial MANOVA, multivariate multiple regression (MMRA), MANCOVA, sum of squares and products (SSP) matrices, H and E matrices, eigenvalues of HE⁻¹, Wilks' lambda, Pillai trace, Hotelling-Lawley trace, Roy's maximum root, partial eta-squared, contrasts, linear hypotheses, polynomial trends, adjusted means, homogeneity of regression, multivariate normality, Mardia tests, chi-square QQ plot, distance plot, multivariate influence, robust estimation.

**Must-use keywords:** multivariate linear model (MLM); multivariate analysis of variance (MANOVA); multivariate multiple regression; MANCOVA; Wilks' lambda; Pillai's trace; Roy's maximum root; contrasts; linear hypotheses; lm(); car; heplots; R.

## Chapter 12 — Visualizing Multivariate Models (`12-mlm-viz.qmd`)

**Topic:** The HE plot framework for visualizing effects in multivariate linear models; canonical discriminant analysis and canonical correlation analysis as low-dimensional views.

**Sections / content skeleton:**

- Motivation: answer to Huang (2019) "MANOVA: a procedure whose time has passed?" — graphical methods cure interpretability problems; heplots & candisc packages.
- HE plot framework: dogfood quartet figure — (a) data space → (b) data ellipses → (c) HE plot → (d) canonical space; MANOVA ≡ discriminant analysis (emphasis differs); one H ellipse per model term, SSP_Model = H_A + H_B + H_AB.
- HE plot construction: E ellipse = 68% data ellipsoid of residuals scaled by df_e, centered at grand mean; effect size scaling (H/df_e) vs significance scaling (H/(λ_α df_e)) — H protrudes outside E iff Roy's test significant at α.
- Iris data example (Anderson's data, Fisher, discriminant analysis history; History corner: "is the iris data racist?" — eugenics context, Bodmer et al.): scatterplot matrix, MANOVA with contrasts (setosa vs others; versicolor vs virginica), `heplot()` for sepal and petal pairs, significance vs effect scaling figure, contrasts as degenerate 1-df line ellipses, `pairs.mlm()` HE plot matrix.
- Low-D views — canonical discriminant analysis (CDA): eigen-decomposition of HE⁻¹; scores Z = Y E^(-1/2) V; `candisc::candisc()`; tests of number of significant canonical dimensions (Bartlett/Wilks); canonical R²; standardized/raw/structure coefficients; canonical scores plot with variable vectors (iris: 99.1% one dimension = flower size; Can2 = shape); canonical HE plot (E is a circle in canonical space).
- Factorial designs: Plastic film revisited — overlaid HE plots with both effect & significance scaling; interaction means added via `termMeans()`; MockJury manipulation check — ratings (phyattr, exciting, sociable, happy, independent) ~ Attr*Crime; HE plots for selected pairs; candisc for Attr term: 91% on Can1 aligned with phyattr.
- MMRA HE plots: 1-df quantitative predictors plot as lines; angles = correlations of predicted effects; joint linear hypothesis ellipses ("Overall", "Regr"); NLSY example; schooldata example (cases 44, 59 removed).
- Canonical correlation analysis (CCA): symmetric in X and Y sets; maximize corr of linear combinations (Hotelling 1936); geometry of minimal angle between subspaces; generalized eigenvalue problem; `candisc::cancor()`; schooldata: CanR = 0.995, 98.6% on first dimension; canonical scores plots (influential cases inflate CanR to 0.997); HE plot for cancor.
- MANCOVA models: HE plots for Rohwer MANCOVA; heterogeneous regression model with joint "Slopes" hypothesis ellipse; overlaid HE plots for separate low/high SES models.

**Datasets:** `dogfood`, `iris` (datasets), `Plastic`, `MockJury`, `NLSY`, `schooldata`, `Rohwer` (heplots).

**Packages:** heplots, candisc, car, ggplot2, dplyr, tidyr, ggpubr, patchwork.

**Methods/terms:** HE plot, hypothesis-error plot framework, effect size scaling, significance scaling, visual test of significance, Roy's maximum root test, contrasts, HE plot matrix, canonical discriminant analysis (CDA), canonical space, canonical scores, structure coefficients, canonical HE plot, factorial MANOVA, multivariate multiple regression, canonical correlation analysis (CCA), MANCOVA, homogeneity of regression.

**Must-use keywords:** HE plots (hypothesis-error plots); visualizing MANOVA; canonical discriminant analysis; canonical correlation analysis; multivariate linear models; iris data; heplots; candisc; effect scaling; significance scaling; R.

## Chapter 13 — Visualizing Equality of Covariance Matrices (`13-eqcov.qmd`)

Numbering verified against `_quarto.yml`: Ch 13 = `13-eqcov.qmd`, Ch 14 = `14-infl-robust.qmd`, Ch 15 = `21-discrim.qmd` (`15-case-studies.qmd` is commented out of the chapter list and becomes the HTML-only Appendix via `_quarto-online.yml`).

**Topic:** Extending tests of homogeneity of variance from univariate ANOVA to equality of covariance matrices in MANOVA; visualizing heterogeneity of covariance matrices (following Friendly & Sigal 2018).

**Sections / content skeleton:**

- Motivation: Box's rowing-boat quote; violations impact MANOVA conclusions; equality of covariances of interest in itself (lab equivalence studies); outcome informs choice of linear (LDA) vs quadratic (QDA) discriminant analysis, analogous to the Welch t-test under unequal variances.
- Homogeneity of variance in ANOVA: F test robust to violation with roughly equal group sizes but loses power; classical tests (Hartley's F_max, Cochran's C, Bartlett) have terrible properties; Levene's test = ANOVA of absolute deviations |y − ȳ_i| from group means; Brown-Forsythe versions use median or trimmed mean; `heplots::colDevs()`, `car::leveneTest()`, `heplots::leveneTests()` (all responses at once; penguins: only body_mass differs).
- Visualizing Levene's test: boxplots of the absolute deviations from group medians — the visual test is whether the median lines align (plot the quantity of direct interest).
- Homogeneity in MANOVA: Σ₁ = Σ₂ = ⋯ = Σ_g much stronger than univariate (p(p+1)/2 parameters equal); variances = size, covariances = shape of data ellipses; `heplots::covEllipses()` draws per-group + pooled data ellipses, `center = TRUE` shifts to grand mean for direct comparison; pairwise scatterplot-matrix format. Penguin ellipses look similar yet Box's M strongly rejects; iris ellipses visibly heterogeneous (setosa smallest).
- Box's M test: likelihood-ratio statistic comparing log determinants ln|S_i| to pooled ln|S_p|; chi-square and F approximations, bias correction; Bartlett's test is the univariate special case; highly sensitive to non-normality and outliers.
- Visualizing Box's M: `plot()` of a `"boxm"` object — dot plot of log determinants with asymptotic confidence intervals (Cai et al. 2015).
- Low-rank views: covariance ellipses of principal component scores (uncentered/centered); **small dimensions matter** — differences among covariance matrices can lurk in the smallest PCs (iris: PC3–PC4 correlations differ in sign for virginica), just as for outliers and collinearity.
- Other measures of heterogeneity: eigenvalue functions of an ellipsoid's size — generalized variance (determinant/product), average variance (trace/sum), average precision (harmonic mean), maximal variance (largest eigenvalue) — parallel to Wilks/Pillai/Hotelling-Lawley/Roy; `plot(boxm, which = ...)` plots each; different functions reflect different patterns, could define new tests.
- Multivariate Levene test: MANOVA of absolute deviations from group medians (`colDevs()` + `lm()` + `car::Anova()`); visualized with HE plots (`pairs.mlm`) showing group differences in *dispersion*, and canonical discriminant analysis (`candisc`) — iris dispersion differences are 98% one-dimensional (setosa smallest, virginica largest).

**Datasets:** `peng` (heplots; Palmer penguins), `iris` (datasets).

**Packages:** heplots (main: boxM, covEllipses, colDevs, leveneTests), car, candisc, ggplot2, dplyr, tidyr.

**Methods/terms:** homogeneity of variance, equality of covariance matrices, Levene's test, Brown-Forsythe test, Box's M test, log determinant, pooled covariance matrix, data ellipse, centered ellipses, generalized variance, precision, principal components, HE plot, canonical discriminant analysis, MANOVA assumptions.

**Must-use keywords:** equality of covariance matrices; homogeneity of variance; Box's M test; Levene's test; MANOVA assumptions; covariance ellipses / data ellipses; heplots; Palmer penguins; iris; R.

## Chapter 14 — Multivariate Influence and Robust Estimation (`14-infl-robust.qmd`)

**Topic:** Extending influence diagnostics (leverage, residuals, Cook's distance) to multivariate response models; robust estimation for MLMs to downweight outliers.

**Sections / content skeleton:**

- Motivation: single bad observation can alter OLS fits; univariate diagnostics well established (Cook 1977, Belsley et al.); multivariate case requires *joint influence* across correlated responses — cases can look benign univariately yet be influential jointly.
- Multivariate influence (Barrett & Ling 1992; Barrett 2003; `mvinfluence` package): case-deletion idea generalized to deleting subsets of m ≥ 1 cases (masking); notation for X, Y, B with cases deleted; hat matrix H and residual analog Q = E(EᵀE)⁻¹Eᵀ; multivariate Cook's distance via vec(B − B₍₋I₎) and Kronecker product; factorization D_i ∝ L_i × R_i into leverage component L = h/(1−h) and (squared studentized) residual component R = q/(1−h); det() or tr() for size when m > 1 (same trick as Wilks/Pillai).
- The Mysterious Case 9 (toy example, Barrett 2003): one x, two nearly perfectly correlated responses y1, y2 (r = 0.9997); case 9 has tiny univariate Cook's D in each separate regression (DFBETAS near 0) but multivariate D 10× larger than any other case — ill-conditioning of highly correlated responses magnifies small discrepancies.
- Influence plots: `mvinfluence::influencePlot.mlm()` — `type = "stres"` plots squared studentized residual vs hat value (cutoffs: 2–3 × p/n; Beta calibration); `type = "LR"` plots log leverage vs log residual, where contours of constant Cook's distance are diagonal lines with slope −1.
- NLSY example (`heplots::NLSY`, child reading & math ~ parents' income, education): "noteworthy" point labeling (large on any of residual, hat, Cook's D); groups of low-leverage/large-residual vs high-leverage/small-residual points.
- Penguin example: MANOVA model with factor predictor — hat values proportional to 1/n_j (Chinstrap most unusual); influential birds "Cyrano" (case 283) and "Hook Nose" (case 10).
- Robust estimation: reliable estimates when outliers present; M-, S-, MM-estimators; `heplots::robmlm()` = M-estimation, replaces least squares ρ(e) = e² with robust loss (L1, biweight with tuning constant); iteratively reweighted least squares (IRLS); a robust MANOVA by substituting robmlm() for lm().
- Penguin robust fit: index plot of final observation weights (`plot()` method) — Cyrano weighted exactly 0 (excluded), Hook Nose 0.13; `heplots::rel_diff()` percent change in coefficients, largest for Chinstrap bill_depth and body_mass.

**Datasets:** `Toy` (constructed, Barrett 2003), `NLSY` (heplots), `peng` (heplots; Palmer penguins).

**Packages:** mvinfluence, heplots, car, candisc, dplyr, tidyr, ggplot2, patchwork.

**Methods/terms:** influential observations, outliers, leverage, hat values, studentized residuals, case deletion, multivariate Cook's distance, DFBETAS, influence plots, LR plot, masking, robust estimation, M-estimators, S-estimators, MM-estimators, biweight function, weighted least squares, iteratively reweighted least squares (IRLS), robust MANOVA, observation weights.

**Must-use keywords:** multivariate influence; influential observations; Cook's distance; hat values; leverage; influence plots; robust estimation; robust MANOVA; iteratively reweighted least squares; mvinfluence; heplots; R.

## Chapter 15 — Discriminant Analysis (`21-discrim.qmd`)

**Topic:** Linear and quadratic discriminant analysis as classification — the "flipped MANOVA"; visualizing classification in data space, prediction regions, and discriminant space; relation to canonical discriminant analysis.

**Sections / content skeleton:**

- LDA vs MANOVA: same mathematics (T = H + E, eigenvalues/eigenvectors of HE⁻¹) but emphasis flipped from testing mean differences to classifying observations; model formulas `lm(cbind(y1,y2,y3) ~ group)` vs `MASS::lda(group ~ y1 + y2 + y3)`; predict() gives group membership; dimension-reduction view — s = min(p, df_h) discriminant dimensions squeeze the between/within "juice".
- Main ideas figure: two groups, LD1 = weighted sum maximizing separation relative to within-group variability; projections onto discriminant axis; linear decision boundary perpendicular to line joining means.
- Linear vs quadratic: LDA assumes equal covariance matrices → hyperplane boundaries; unequal covariances → QDA (`MASS::qda()`), curved boundaries; also MDA/FDA (mda package) in a footnote.
- Prior probabilities: π_k shifts classification boundaries; discriminant function δ_k(x); misclassification costs.
- History Corner: Fisher (1936) discriminant function with Anderson's iris data; Mahalanobis distance; Rao (1948) → QDA; McLachlan, Bayesian approaches.
- Penguins on Island Z: five imaginary new penguins (Abe, Betsy, Chloe, Dave, Emma) classified with `lda()` + `predict()`; posterior probabilities; iris LDA (LD1 = 99.1%).
- Classification accuracy: confusion table actual vs predicted (penguins: 1.2% error, only Adélie–Chinstrap confusions); leave-one-out cross-validation (`CV = TRUE`).
- candisc convenience functions for `"lda"` objects: `predict_discrim()`, `cor_lda()`, `scores()`.
- Visualizing classification in data space: scatterplots with 95% data ellipses + labeled new observations.
- Discriminant space: customized `plot.lda()` (panel function, % between-group variance axis labels); 2D view captures 100% of species separation.
- Prediction regions ("territorial maps"/partition plots): `klaR::partimat()`; better versions with ggplot2 `geom_tile()` over a `marginaleffects::datagrid()` grid; `candisc::plot_discrim()` one-liner; regions in discriminant space by refitting lda on LD1, LD2.
- LDA biplot: variable vectors (`gggda::geom_vector()`) added to discriminant-space plot; aspect ratio 1.
- Relation to MANOVA and CDA: `candisc()` on the mlm gives same dimensions plus step-down significance tests; canonical discriminant plot (structure coefficients, standardized — unlike lda()'s unstandardized scaling); canonical HE plot (E circular in canonical space).
- QDA: discriminant function with per-group S_k; penguin QDA prediction regions only slightly curved for bills, more curved for flipper/body mass; LDA vs QDA compared by cross-validated accuracy — QDA gains only 0.3%.

**Datasets:** `peng` (heplots; Palmer penguins) + constructed `peng_new` (island Z), `iris` (datasets).

**Packages:** MASS (lda, qda), candisc, klaR, marginaleffects, gggda, heplots, ggplot2, patchwork, dplyr.

**Methods/terms:** linear discriminant analysis (LDA), quadratic discriminant analysis (QDA), classification, decision boundary, prediction regions, partition plots, prior probabilities, posterior probabilities, discriminant scores, discriminant space, dimension reduction, confusion table, classification accuracy, cross-validation, LDA biplot, canonical discriminant analysis, canonical HE plot, step-down tests.

**Must-use keywords:** linear discriminant analysis (LDA); quadratic discriminant analysis (QDA); classification; decision boundaries; prediction regions; posterior probabilities; cross-validation; MANOVA; canonical discriminant analysis; MASS; candisc; Palmer penguins; iris; R.

## Appendix — Case Studies (`15-case-studies.qmd`)

Numbering verified against `_quarto.yml`: `15-case-studies.qmd` is commented out of the chapter list and becomes the HTML-only Appendix (via `_quarto-online.yml`). Abstract drafted into `issues/abstract-case-studies.md` (kept separate from `chapter-abstracts.md` per Michael's instruction).

**Topic:** Complete worked case studies placing the book's methods in a wider research context: a sequence from research questions to exploratory graphics, MANOVA model fitting, HE plots, canonical analysis, and model checking.

**Sections / content skeleton:**

- Framing: Part IV chapters used small examples; here, fuller analyses show the workflow — research questions → graphical, computing and statistical methods. Pointer to heplots vignettes (HE_manova, HE_mmra).
- Study: Laura Hartman's York University Ph.D. dissertation (Hartman 2016; Heinrichs et al. 2015) — can patients diagnosed with schizophrenia (n = 70) or schizoaffective disorder (n = 46) be distinguished from each other and from normal controls (n = 146) on standardized neurocognitive tests (processing speed, attention, memory, verbal learning, visual learning, problem solving) and social-cognitive measures? Clinical relevance: overlapping symptoms, different treatments (mood disorder vs psychotic ideation).
- Research questions: do groups differ; which domains differ most; how many dimensions of difference? Contrasts: Dx1 = control vs diagnosed groups; Dx2 = schizophrenia vs schizoaffective.
- NeuroCog analysis: first look with combined jittered points + violin plots + boxplots (ggplot2, long format); corrgram with effect ordering (corrgram package); scatterplot matrix with data ellipses and regression lines (car::scatterplotMatrix); PCA biplot (ggbiplot; ~80% variance in 2D) — control group differs, patient groups don't.
- MANOVA: `lm(cbind(...) ~ Dx)` + `car::Anova()`; `linearHypothesis()` tests of the two contrasts (Dx1 highly significant; Dx2 not); chi-square QQ plot (`heplots::cqplot()`) checks multivariate normality of residuals; HE plot and `pairs()` HE plot matrix — group means nearly perfectly correlated; canonical discriminant analysis (`candisc()`): separation 98.5% one-dimensional; control group higher on all measures.
- SocialCog analysis (managing emotions, theory of mind, externalizing bias, personalizing bias): both contrasts initially significant — potentially a new finding (schizophrenia vs schizoaffective distinguishable on social cognition); BUT model checking with `cqplot()` reveals one extreme multivariate outlier = data entry error (ExtBias score of -33, valid range -10 to +10); refitting with `update()` on the subset makes the key Dx2 contrast non-significant. Lesson: traditional non-graphical SPSS data screening missed it; visual model diagnostics matter.
- Canonical HE plot of corrected model: both dimensions significant (83.9% / 16.1%); dimension 1 orders control → schizoaffective → schizophrenia (externalizing bias, theory of mind); dimension 2 separates the schizoaffective group (personalizing bias, managing emotions); contrast lines projected into canonical space.

**Datasets:** `NeuroCog`, `SocialCog` (both heplots).

**Packages:** car, heplots, candisc, ggplot2, dplyr, tidyr, corrgram, ggbiplot.

**Methods/terms:** case study, research questions, exploratory data analysis, violin plot, boxplot, corrgram, effect ordering, scatterplot matrix, data ellipse, biplot, PCA, MANOVA, contrasts, linear hypotheses, chi-square QQ plot, multivariate normality, multivariate outlier, data entry error, HE plot, HE plot matrix, canonical discriminant analysis, canonical HE plot, model checking.

**Must-use keywords:** case studies; multivariate analysis workflow; MANOVA; schizophrenia; neurocognitive; social cognition; HE plots; canonical discriminant analysis; multivariate outlier; model checking; heplots; candisc; R.
