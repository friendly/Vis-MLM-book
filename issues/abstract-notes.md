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
