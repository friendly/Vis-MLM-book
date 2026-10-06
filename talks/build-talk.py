# Build the first draft of the book talk as a PowerPoint deck.
#
#   python talks/build-talk.py            # writes talks/Vis-MLM-talk.pptx (refuses to overwrite)
#   python talks/build-talk.py --force    # overwrite an existing deck
#   python talks/build-talk.py -o talks/draft2.pptx
#
# NB: once Vis-MLM-talk.pptx has been edited by hand in PowerPoint, re-running this with
#     --force throws those edits away. Use -o to write a fresh copy somewhere else instead.
#
# The deck is built on talks/base-16x9.pptx: an empty 16:9 file with PowerPoint's standard
# Office layouts. Titles and bullets go in the layouts' placeholders, so fonts, colors and
# backgrounds can be changed in one place (View > Slide Master). Figures are the image files
# already in figs/ and images/.
#
# Needs: pip install python-pptx Pillow

import argparse
import copy
import sys
from pathlib import Path

from PIL import Image
from pptx import Presentation
from pptx.dml.color import RGBColor
from pptx.util import Inches, Pt

ROOT = Path(__file__).resolve().parent.parent
TALKS = ROOT / "talks"
BASE = TALKS / "base-16x9.pptx"

# layout indices in the standard Office theme
L_TITLE, L_CONTENT, L_SECTION, L_TWO, L_TITLE_ONLY = 0, 1, 2, 3, 5

GRAY = RGBColor(0x70, 0x70, 0x70)

# --------------------------------------------------------------------------------------
# Slide content
#   kind:  "title" | "section" | "text" (bullets; optional wide strip figure underneath) | "side" (bullets left, figure right)
#          | "full" (figure under the title) | "pair" (two figures side by side)
#   fig:   figure number in the book, shown as a small tag
#   take:  one-line takeaway under a full-width figure
#   notes: speaker notes;  opt=True marks a slide that is optional for a 45-minute talk
# --------------------------------------------------------------------------------------

SLIDES = []
SECTIONS = []  # (title, index of first slide)


def section(name):
    SECTIONS.append((name, len(SLIDES)))


def add(kind, title, **kw):
    SLIDES.append(dict(kind=kind, title=title, **kw))


# ---- Introduction
section("Introduction")

add("title", "Visualizing Multivariate Data and Models in R",
    sub="A Romance in Many Dimensions\n\nMichael Friendly, York University\nUtrecht, 5 November 2026",
    notes="Title slide. The talk is framed around the book of the same name.")

add("side", "The book",
    img="images/Viz-MLM-logo.jpg",
    bullets=[
        "Graphical methods for multivariate data and for multivariate linear models",
        "15 chapters in four parts, from exploratory plots to MANOVA and discriminant analysis",
        "To appear with CRC Press / Chapman & Hall",
        "Online version: friendly.github.io/Vis-MLM-book",
    ],
    notes="What the book is and where to find it. The online version has the animations and all the R code.")

add("text", "Where we are going",
    img="figs/fig-book-parts-1.png",
    bullets=[
        "Why many dimensions?",
        "Seeing multivariate data",
        "Dimension reduction",
        "Plots for models with one response",
        "Collinearity and ridge regression",
        "The HE plot framework for multivariate models",
        "Checking multivariate models",
    ],
    notes="Roadmap. The talk follows the book: plots of data, then models with one response, "
          "then models with many responses. The ellipse is the recurring device.")

# ---- 1
section("1. Why many dimensions?")

add("section", "Why a romance in many dimensions?",
    sub="We live in Spaceland, but we plot in Flatland")

add("side", "Flatland: we only ever see projections",
    img="images/flatland-spheres.jpg", fig="1.1",
    bullets=[
        "Abbott's Flatland (1884): a sphere passing through a 2D world is seen as a circle that grows and shrinks",
        "Our plots are Flatland views of data that live in many dimensions",
        "Multivariate visualization is the art of choosing good views",
    ],
    notes="The book's subtitle is a nod to Abbott's 'Flatland: A Romance of Many Dimensions'. "
          "The Flatlander sees only a slice of the sphere. We are in the same position with p > 2 variables.")

add("full", "EUREKA! Structure can hide in many dimensions",
    img="images/pollen-eureka.gif", fig="1.5",
    take="Zooming in on the right view of the pollen data reveals what no summary statistic would.",
    notes="Animation (plays in slide show mode). The pollen data look like a featureless cloud until you zoom in "
          "on the dense center, where the points spell out a word.")

add("side", "A multivariate discovery: kinds of diabetes",
    img="images/ReavenMiller-3d-annotated.png", fig="1.7",
    bullets=[
        "Reaven & Miller (1979) viewed glucose and insulin measures in 3D with PRIM-9",
        "The 3D view showed distinct groups that 2D plots had obscured",
        "The picture changed how the disease was classified",
    ],
    notes="An example of a scientific discovery that came from looking at data in more than two dimensions. "
          "The Diabetes data come back later in the dimension reduction section.")

add("side", "The problem: easy to fit, hard to see",
    img="images/techniques-table.png", fig="6.1",
    bullets=[
        "With one response, we have a rich toolkit of plots for linear models",
        "With several responses, lm(cbind(y1, y2, y3) ~ ...) is just as easy to fit",
        "But the results arrive as tables of multivariate tests",
        "Goal: plots that show what those tests mean",
    ],
    notes="The table classifies linear model techniques by the number and type of responses and predictors. "
          "The right-hand column, multivariate responses, is where graphical methods have been thin.")

# ---- 2
section("2. Seeing multivariate data")

add("section", "Seeing multivariate data",
    sub="Data ellipses, penguins, and looking at many variables at once")

add("side", "The data ellipse summarizes means, spread and correlation",
    img="figs/ch04/fig-ellipses-coverage-1.png", fig="4.9",
    bullets=[
        "Center: the means",
        "Shadows on the axes: the standard deviations",
        "Shape and tilt: the correlation",
        "Sufficient for bivariate normal data, and a useful visual summary otherwise",
    ],
    notes="Data ellipses of 50%, 68% and 95% coverage. The ellipse is the workhorse of the book: "
          "the same idea returns as confidence ellipses for coefficients and as H and E ellipses for multivariate tests.")

add("pair", "Meet the penguins",
    imgs=["images/penguins-horst.png", "figs/ch04/fig-peng-ggplot1-1.png"], fig="4.17, 4.19",
    take="Three species, four size measures: bill length, bill depth, flipper length, body mass. Artwork: Allison Horst.",
    notes="The Palmer penguins are the running example. Here: bill length and bill depth with data ellipses and "
          "regression lines for each species.")

add("full", "Simpson's paradox: marginal and conditional relationships differ",
    img="images/peng-simpsons.png", fig="4.23",
    take="Ignoring species, longer bills look shallower. Within every species, the relation is positive.",
    notes="Panels: (a) ignoring species, (b) by species, (c) pooled within species. "
          "The data ellipses make the reversal immediate.")

add("side", "Scatterplot matrices: all pairs at once",
    img="figs/ch04/fig-peng-spm-1.png", fig="4.31",
    bullets=[
        "Every pairwise view in one display",
        "Data ellipses and regression lines by species",
        "Works well up to a moderate number of variables",
    ],
    notes="Scatterplot matrix of the quantitative penguin variables.")

add("side", "Visual thinning: show less to see more",
    img="figs/ch04/fig-crime-corrplot-AOE-1.png", fig="4.35",
    bullets=[
        "With many variables, replace the points by a rendering of each correlation",
        "Order the variables so that similar ones are adjacent",
        "Here: ordered by the angles of the variable vectors from a PCA",
    ],
    notes="Corrplot of the crime data, with variables reordered. The ordering idea is taken up again under PCA.")

add("full", "Parallel coordinates: one line per penguin",
    img="images/fig-peng-ggpcp2-1.png", fig="4.40",
    take="Each observation is a line across the variable axes; groups appear as bundles.",
    notes="Parallel coordinates plot of the penguin size variables, colored by species.", opt=True)

add("full", "Animated tours: moving through projections",
    img="images/tours/peng-tourr-grand.gif", fig="4.48",
    take="A grand tour shows a smooth sequence of 2D projections; a guided tour steers toward interesting ones.",
    notes="Animation (plays in slide show mode): grand tour of the penguin data. "
          "Guided tours optimize an index, e.g. separation of groups or the presence of anomalies.")

add("pair", "Multivariate outliers: which penguins are unusual?",
    imgs=["figs/ch04/fig-peng-cqplot-1.png", "figs/ch04/fig-peng-ggplot-out-1.png"], fig="4.26, 4.27",
    take="Squared Mahalanobis distances against chi-square quantiles. We will meet these birds again.",
    notes="Chi-square QQ plot for the penguin data, and the unusual birds identified in the bill length-bill depth plot. "
          "Two of them, nicknamed Cyrano and Hook Nose, come back in the influence and robust sections.", opt=True)

# ---- 3
section("3. Dimension reduction")

add("section", "Flatland and Spaceland: dimension reduction",
    sub="PCA, biplots, and nonlinear methods")

add("full", "PCA: rotate to the views that show the most",
    img="images/pca-rotation.png", fig="5.6",
    take="PCA is a rotation of the axes: PC1 lies along the direction of greatest variance, PC2 is orthogonal to it.",
    notes="Geometry of PCA as a rotation. Tie back to the data ellipse: its major and minor axes are PC1 and PC2.")

add("full", "PCA fitted by springs",
    img="images/pca-springs-cropped.gif", fig="5.5",
    take="Springs pull the line in proportion to squared distance; it settles on the first principal component.",
    notes="Animation (plays in slide show mode). The blue points are connected to their projections on the red line "
          "by springs perpendicular to that line. A physical intuition for least squares. "
          "One of the figures the organizer singled out.")

add("side", "Biplots: observations and variables in one view",
    img="figs/ch05/fig-crime-biplot1-1.png", fig="5.13",
    bullets=[
        "Points: the observations (here, US states) in the PC1-PC2 plane",
        "Vectors: the variables (crime rates)",
        "Angles between vectors approximate correlations",
        "Projecting a point on a vector approximates its value on that variable",
    ],
    notes="Basic biplot of the crime data. The biplot is the low-D view used again and again: "
          "for collinearity, for canonical discriminant analysis, and for ridge regression.")

add("full", "When a linear view is not enough: PCA and t-SNE",
    img="images/diabetes-pca-tsne.png", fig="5.25",
    take="t-SNE separates the Diabetes groups more cleanly, but distances and axes no longer have a direct meaning.",
    notes="Comparison of the PCA and t-SNE 2D representations of the Diabetes data. "
          "Nonlinear methods preserve local neighborhoods at the cost of global geometry.")

add("full", "From PCA to t-SNE, animated",
    img="images/diabetes-pca-tsne.gif", fig="5.26",
    take="The PCA configuration morphs into the t-SNE one largely by a rotation.",
    notes="Animation (plays in slide show mode): interpolating between the PCA and t-SNE solutions for the Diabetes data. "
          "One of the figures the organizer singled out.")

add("pair", "Application: ordering variables in displays",
    imgs=["figs/ch05/fig-mtcars-corrplot-varorder-1.png", "figs/ch05/fig-mtcars-corrplot-pcaorder-1.png"],
    fig="5.27, 5.29",
    take="The same correlations of the mtcars data: in dataset order (left) and in PCA order (right).",
    notes="Ordering variables by their angles in the biplot puts similar variables together and makes the pattern visible.",
    opt=True)

add("full", "Application: how many dimensions is the Mona Lisa?",
    img="images/mona-pca.png", fig="5.33",
    take="Reconstructions from a few principal components: image compression as dimension reduction.",
    notes="Re-construction of the Mona Lisa from increasing numbers of components (the eigenfaces idea).", opt=True)

add("side", "Outliers can hide in the smallest dimensions",
    img="images/peng-out-biplot-34.png", fig="5.37",
    bullets=[
        "The first two dimensions show what is typical",
        "The last dimensions show what does not fit the pattern",
        "Biplot of dimensions 3-4 of the penguin data",
    ],
    notes="An 'elliptical insight': multivariate outliers often show up in the dimensions with the least variance.",
    opt=True)

# ---- 4
section("4. Models with one response")

add("section", "Plots for models with one response",
    sub="What we already do well, and want to carry over")

add("side", "The regression quartet",
    img="figs/ch07/fig-duncan-plot-model-1.png", fig="7.2",
    bullets=[
        "Residuals vs. fitted: nonlinearity",
        "Normal QQ: distribution of residuals",
        "Scale-location: non-constant variance",
        "Residuals vs. leverage: influential cases",
    ],
    notes="The four standard diagnostic plots, here for Duncan's data on the prestige of occupations "
          "predicted from income and education.")

add("side", "Coefficient plots: show the estimates, not a table",
    img="figs/ch07/fig-modelplot3-1.png", fig="7.7",
    bullets=[
        "Estimates with confidence intervals",
        "Standardize, or the scales of the predictors dominate the picture",
        "Easy to compare several models",
    ],
    notes="Plot of standardized coefficients and their confidence intervals.")

add("full", "Added-variable plots show partial relationships",
    img="figs/ch07/fig-coffee-mcplot-1.png", fig="7.12",
    take="Coffee, stress and heart damage: the marginal and the partial slope for coffee have opposite signs.",
    notes="Marginal + conditional (added-variable) plots for the coffee data, a contrived example constructed by "
          "Georges Monette. Each added-variable plot shows the relation of y to one predictor with the others partialled out; "
          "the slope is the coefficient in the full model.")

add("full", "Effect displays: what the model predicts",
    img="figs/ch07/fig-prestige-allEffects-1.png", fig="7.17",
    take="Fitted values for each predictor, averaging over the others.",
    notes="Predictor effect plots for all terms in the model for the Prestige data.", opt=True)

add("side", "Leverage and influence",
    img="figs/ch07/fig-duncan-infl-1.png", fig="7.26",
    bullets=[
        "Leverage: unusual in the predictors",
        "Outlier: a large residual",
        "Influence = leverage x residual",
        "Bubble size: Cook's distance",
    ],
    notes="Influence plot for the Duncan model. Minister and conductor stand out.")

add("full", "Which observations drive the fit?",
    img="images/duncan-av-influence.png", fig="7.27",
    take="Green: the residuals for minister and conductor. Red: the fitted line with those two cases omitted.",
    notes="One of the figures the organizer singled out. The two occupations pull the income and education slopes "
          "in opposite directions.")

add("full", "Data space and beta space are dual",
    img="images/coffee-data-beta-both.png", fig="8.3",
    take="The confidence ellipse for the coefficients is the inverse of the data ellipse of the predictors.",
    notes="Data space and beta space for the coffee data. Where the predictors have a wide spread, the coefficients "
          "are estimated precisely, and vice versa. This sets up collinearity.", opt=True)

add("full", "Measurement error biases more than one coefficient",
    img="images/coffee-measerr.png", fig="8.7",
    take="Error in one predictor attenuates its own coefficient and distorts those of the others.",
    notes="Biasing effect of measurement error in one variable on the coefficients, shown in beta space.", opt=True)

# ---- 5
section("5. Collinearity and ridge regression (optional)")

add("section", "Collinearity and ridge regression",
    sub="Seeing the problem, and seeing the remedy")

add("full", "Collinearity: narrow data, inflated uncertainty",
    img="figs/ch09/fig-collin-data-beta-1.png", fig="9.4",
    take="As the predictors become more correlated, the data ellipse narrows and the confidence ellipse balloons.",
    notes="95% data ellipses for x1, x2 and the corresponding confidence ellipses for their coefficients, "
          "for increasing correlation.", opt=True)

add("pair", "Where's Waldo? Collinearity lives in the smallest dimensions",
    imgs=["figs/ch09/fig-cars-tableplot-1.png", "figs/ch09/fig-cars-collin-biplot-1.png"], fig="9.6, 9.7",
    take="Tableplot of condition indices and variance proportions; biplot of the two smallest dimensions (Cars data).",
    notes="The standard collinearity diagnostics table hides the important information. The tableplot makes it stand out; "
          "the collinearity biplot shows which variables are involved.", opt=True)

add("side", "Ridge regression: shrink to gain precision",
    img="images/ridge-demo.png", fig="9.9",
    bullets=[
        "Constrain the size of the coefficients",
        "The estimate moves from the OLS solution toward the origin",
        "A little bias buys a lot of precision",
    ],
    notes="Geometric interpretation of ridge regression.", opt=True)

add("side", "The usual ridge trace shows only the estimates",
    img="figs/ch09/fig-longley-traceplot1-1.png", fig="9.10",
    bullets=[
        "Longley data: six highly collinear economic predictors",
        "Coefficients plotted against the shrinkage constant",
        "Shows the bias, but nothing about precision",
    ],
    notes="Univariate ridge trace plot for the Longley data.", opt=True)

add("full", "Bivariate ridge traces show bias and precision together",
    img="figs/ch09/fig-longley-pairs-1.png", fig="9.13",
    take="Each panel: the confidence ellipse for a pair of coefficients shrinking along the ridge path.",
    notes="One of the figures the organizer singled out. Scatterplot matrix of bivariate ridge trace plots (genridge package). "
          "Most of the shrinkage paths are regular; a few are not.", opt=True)

add("side", "A low-rank view of ridge regression",
    img="figs/ch09/fig-longley-pca-biplot-1.png", fig="9.18",
    bullets=[
        "Transform to the principal component space of the predictors",
        "Shrinkage happens mostly in the smallest dimensions",
        "A biplot shows how the variables relate to them",
    ],
    notes="Biplot view of the ridge trace plot for the smallest dimensions.", opt=True)

# ---- 6
section("6. The HE plot framework")

add("section", "The HE plot framework",
    sub="Seeing multivariate tests as ellipses")

add("side", "From the t-test to Hotelling's T²",
    img="images/T2-diagram.png", fig="10.1",
    bullets=[
        "Two groups, several responses",
        "T² is the largest squared t over all linear combinations of the responses",
        "That best combination is the discriminant axis",
    ],
    notes="Hotelling's T-squared as a generalized t-test.")

add("full", "The Hypothesis-Error plot framework",
    img="images/HE-framework.png", fig="10.9",
    take="Data ellipses become the E ellipse; the group means become H; projection gives the discriminant view.",
    notes="One of the figures the organizer singled out. Above: data ellipses summarized in an HE plot showing the pooled "
          "within-group error ellipse (E) and the H 'ellipse' for the group means. Below: observations projected on the "
          "line joining the means.")

add("full", "MANOVA: the same sums of squares, now as matrices",
    img="images/VisualizingSSP.png", fig="11.2",
    take="Total = Hypothesis + Error. Each is a matrix, so each can be drawn as an ellipse.",
    notes="Breakdown of the total SSP matrix into H and E. The Wilks, Pillai, Hotelling-Lawley and Roy tests are all "
          "functions of the eigenvalues of H relative to E.")

add("full", "HE plots: is the effect significant, and how?",
    img="figs/ch12/fig-iris-HE1-1.png", fig="12.5",
    take="With significance scaling, an H ellipse that projects outside E signals a significant effect (Roy's test).",
    notes="HE plots for the iris data. E: within-group variation. H: variation of the group means. "
          "The orientation of H shows how the groups differ.")

add("side", "Contrasts and linear hypotheses",
    img="figs/ch12/fig-iris-contrasts-1.png", fig="12.7",
    bullets=[
        "Any linear hypothesis has its own H",
        "A 1 df hypothesis is a line",
        "Contrasts decompose the overall effect",
    ],
    notes="HE plot for sepal length and width in the iris data, showing contrasts among the species.", opt=True)

add("side", "HE plot matrices: all pairs of responses",
    img="figs/ch12/fig-iris-pairs-1.png", fig="12.8",
    bullets=[
        "The analog of a scatterplot matrix for a multivariate model",
        "One HE plot for each pair of responses",
    ],
    notes="All pairwise HE plots for the iris data.")

add("side", "Canonical views: the space where the groups differ most",
    img="figs/ch12/fig-iris-HEcan-1.png", fig="12.10",
    bullets=[
        "Canonical discriminant analysis: a PCA of H relative to E",
        "E becomes a circle",
        "Variable vectors show what each dimension means",
    ],
    notes="Canonical HE plot for the iris data.")

add("side", "Quantitative predictors: each effect is a line",
    img="figs/ch12/fig-school-heplot1-1.png", fig="12.17",
    bullets=[
        "School data: reading and mathematics scores",
        "Length: the strength of the relationship",
        "Direction: how the predictor relates to the two responses",
        "The overall test is the ellipse for all predictors jointly",
    ],
    notes="One of the figures the organizer singled out. HE plot for the multivariate regression model for the school data. "
          "Each predictor has 1 df, so its H 'ellipse' collapses to a line.")

add("side", "Canonical correlation in an HE plot",
    img="figs/ch12/fig-school-hecan-1.png", fig="12.22",
    bullets=[
        "Canonical correlation: the weighted sums of the y and x variables that correlate most highly",
        "Shown as an HE plot in the canonical space",
    ],
    notes="HE plot for the canonical correlation analysis of the school data.", opt=True)

add("side", "Factorial designs: main effects and interactions",
    img="figs/ch12/fig-plastic-HE1-1.png", fig="12.11",
    bullets=[
        "Plastic film data: tear and gloss by rate of extrusion and amount of additive",
        "One H ellipse for each term in the model",
    ],
    notes="HE plot for the two-way MANOVA of the plastic film data.", opt=True)

add("side", "MANCOVA: are the regressions the same across groups?",
    img="figs/ch12/fig-rohwer-HE-lohi-1.png", fig="12.25",
    bullets=[
        "Rohwer data: aptitude and achievement predicted from paired-associate tasks",
        "Overlaid HE plots for the low and high SES groups",
    ],
    notes="Overlaid HE plots for SAT and PPVT for the two SES groups.", opt=True)

# ---- 7
section("7. Checking multivariate models")

add("section", "Checking multivariate models",
    sub="Outliers, influence and robust estimation")

add("side", "The distance plot: outliers and leverage, multivariately",
    img="figs/ch11/fig-school-distplot-1.png", fig="11.18",
    bullets=[
        "Vertical: Mahalanobis distance of the residuals",
        "Horizontal: Mahalanobis distance of the predictors",
        "The multivariate analog of residuals vs. leverage",
    ],
    notes="One of the figures the organizer singled out. Distance plot for the school data model.")

add("pair", "The Mysterious Case 9",
    imgs=["figs/ch14/fig-toy-inflplots-1.png", "figs/ch14/fig-toy-inflplot-mlm-stres-1.png"], fig="14.2, 14.3",
    take="Harmless in each univariate model (left), yet wildly influential in the multivariate model (right).",
    notes="A toy example from Barrett (2003): one predictor, two nearly perfectly correlated responses, nine cases. "
          "The univariate Cook's D values for case 9 are very small, but the multivariate Cook's D is 3.22, "
          "over 10 times the next largest. Multivariate influence is not the sum of univariate influences.")

add("side", "Influence in the penguin model",
    img="figs/ch14/fig-peng-inflplot1-1.png", fig="14.8",
    bullets=[
        "Multivariate influence plot (mvinfluence package)",
        "The most influential case is our Chinstrap friend 'Cyrano'",
        "'Hook Nose', an Adélie, is among the others",
    ],
    notes="Influence plot for the penguin MANOVA model.")

add("side", "Robust MLMs: down-weight what does not fit",
    img="figs/ch14/fig-peng-robmlm-plot-1.png", fig="14.10",
    bullets=[
        "robmlm(): iteratively reweighted least squares for a multivariate model",
        "Index plot of the final observation weights",
        "Cyrano gets weight 0; Hook Nose gets 0.13",
    ],
    notes="heplots::robmlm() applied to the penguin model. Most coefficients change little; the largest changes are "
          "for Chinstrap, reflecting the removal of Cyrano.")

add("side", "Are the covariance matrices equal?",
    img="figs/ch13/fig-peng-covEllipse-pairs-1.png", fig="13.4",
    bullets=[
        "MANOVA assumes equal within-group covariance matrices",
        "Compare the data ellipse of each group with the pooled one",
        "Look for differences in size and shape",
    ],
    notes="All pairwise covariance ellipses for the penguin data.", opt=True)

add("full", "Visualizing Box's M test",
    img="figs/ch13/fig-peng-iris-boxm-plots-1.png", fig="13.6",
    take="Box's M compares the log determinants of the group covariance matrices with that of the pooled matrix.",
    notes="Plots of the contributions to Box's M for the penguin and iris data.", opt=True)

# ---- 8
section("8. Discriminant analysis (optional)")

add("section", "Discriminant analysis",
    sub="MANOVA turned around: predicting the group")

add("full", "Linear discriminant analysis: the main ideas",
    img="images/discrim-demo-both.jpg", fig="15.1",
    take="Find the directions that best separate the groups, then classify by distance to the group means.",
    notes="Illustration of the main ideas of linear discriminant analysis.", opt=True)

add("full", "Prediction regions in data space",
    img="figs/discrim/fig-peng-regions-1.png", fig="15.6",
    take="Classify every point in a grid of values: the LDA boundaries are linear.",
    notes="Linear discriminant prediction regions for the penguin data.", opt=True)

add("side", "Prediction regions in discriminant space",
    img="figs/discrim/fig-peng-LD-biplot-1.png", fig="15.9",
    bullets=[
        "With three species, two discriminant dimensions show everything",
        "Variable vectors show which measures separate the species",
    ],
    notes="The penguin data in discriminant space, with variable vectors.", opt=True)

add("full", "Quadratic discriminant analysis",
    img="figs/discrim/fig-peng-qda-regions-1.png", fig="15.12",
    take="With a separate covariance matrix for each group, the boundaries become curved.",
    notes="Quadratic discriminant prediction regions for the penguin data.", opt=True)

# ---- Closing
section("Closing")

add("text", "A few ideas go a long way",
    bullets=[
        "Ellipses: for data, for coefficients, and for hypotheses and error",
        "Projections: every plot is a view; choose the views that answer the question",
        "Low-dimensional views: biplots and canonical plots show many variables in the space that matters",
        "Visual thinning: summarize, so the message can be seen",
        "Multivariate models deserve graphs as good as those for a single response",
    ],
    notes="Summary of the themes that recur through the book.")

add("side", "Book, code and packages",
    img="images/Viz-MLM-logo.jpg",
    bullets=[
        "Online version: friendly.github.io/Vis-MLM-book",
        "Source and R code: github.com/friendly/vis-MLM-book",
        "R packages: heplots, candisc, mvinfluence, genridge",
        "To appear with CRC Press / Chapman & Hall",
    ],
    notes="Where to find the book and the software.")

add("section", "Thank you", sub="Questions and discussion")


# --------------------------------------------------------------------------------------
# Builders
# --------------------------------------------------------------------------------------

def set_master_sizes(prs, title_pt=36, body_pts=(24, 20, 18)):
    """Slightly smaller title and body text than the Office default, set once on the master."""
    ns = {"p": "http://schemas.openxmlformats.org/presentationml/2006/main",
          "a": "http://schemas.openxmlformats.org/drawingml/2006/main"}
    m = prs.slide_master._element
    for rpr in m.findall(".//p:titleStyle/a:lvl1pPr/a:defRPr", ns):
        rpr.set("sz", str(title_pt * 100))
    for lvl, pt in enumerate(body_pts, start=1):
        for rpr in m.findall(f".//p:bodyStyle/a:lvl{lvl}pPr/a:defRPr", ns):
            rpr.set("sz", str(pt * 100))


def fit_picture(slide, path, left, top, width, height):
    """Place a picture centered in the box (inches), keeping its aspect ratio."""
    with Image.open(path) as im:
        w, h = im.size
    scale = min(width / w, height / h)
    pw, ph = w * scale, h * scale
    return slide.shapes.add_picture(str(path), Inches(left + (width - pw) / 2),
                                    Inches(top + (height - ph) / 2), Inches(pw), Inches(ph))


def text_box(slide, text, left, top, width, height, size, color=None):
    tb = slide.shapes.add_textbox(Inches(left), Inches(top), Inches(width), Inches(height))
    tf = tb.text_frame
    tf.word_wrap = True
    run = tf.paragraphs[0].add_run()
    run.text = text
    run.font.size = Pt(size)
    if color is not None:
        run.font.color.rgb = color
    return tb


def fill_bullets(placeholder, bullets):
    tf = placeholder.text_frame
    tf.paragraphs[0].text = bullets[0]
    for b in bullets[1:]:
        tf.add_paragraph().text = b


def drop_placeholder(slide, idx):
    for ph in slide.placeholders:
        if ph.placeholder_format.idx == idx:
            ph._element.getparent().remove(ph._element)


def add_sections(prs, sections):
    """Group the slides into named PowerPoint sections (shown in the slide sorter and thumbnail pane)."""
    import uuid
    from lxml import etree
    P = "http://schemas.openxmlformats.org/presentationml/2006/main"
    P14 = "http://schemas.microsoft.com/office/powerpoint/2010/main"
    pres = prs.part._element
    ids = [sld.get("id") for sld in pres.find(f"{{{P}}}sldIdLst")]
    ext_lst = pres.find(f"{{{P}}}extLst")
    if ext_lst is None:
        ext_lst = etree.SubElement(pres, f"{{{P}}}extLst")
    ext = etree.SubElement(ext_lst, f"{{{P}}}ext", uri="{521415D9-36F7-43E2-AB2F-B90AF26B5E84}")
    sec_lst = etree.SubElement(ext, f"{{{P14}}}sectionLst", nsmap={"p14": P14})
    starts = [i for _, i in sections] + [len(ids)]
    for (name, start), end in zip(sections, starts[1:]):
        sec = etree.SubElement(sec_lst, f"{{{P14}}}section", name=name,
                               id="{" + str(uuid.uuid4()).upper() + "}")
        lst = etree.SubElement(sec, f"{{{P14}}}sldIdLst")
        for sid in ids[start:end]:
            etree.SubElement(lst, f"{{{P14}}}sldId", id=sid)


def build(out):
    prs = Presentation(str(BASE))
    set_master_sizes(prs)
    missing = []

    def img(rel):
        p = ROOT / rel
        if not p.exists():
            missing.append(rel)
        return p

    for s in SLIDES:
        kind = s["kind"]
        layout = {"title": L_TITLE, "section": L_SECTION, "text": L_CONTENT,
                  "side": L_TWO, "full": L_TITLE_ONLY, "pair": L_TITLE_ONLY}[kind]
        slide = prs.slides.add_slide(prs.slide_layouts[layout])
        slide.shapes.title.text = s["title"]

        if kind in ("title", "section"):
            slide.placeholders[1].text = s.get("sub", "")
        elif kind == "text":
            fill_bullets(slide.placeholders[1], s["bullets"])
            if s.get("img"):
                fit_picture(slide, img(s["img"]), 0.92, 5.7, 11.5, 1.05)
        elif kind == "side":
            fill_bullets(slide.placeholders[1], s["bullets"])
            drop_placeholder(slide, 2)
            fit_picture(slide, img(s["img"]), 6.75, 1.95, 5.67, 4.8)
        elif kind == "full":
            fit_picture(slide, img(s["img"]), 0.92, 1.85, 11.5, 4.3)
        elif kind == "pair":
            a, b = s["imgs"]
            fit_picture(slide, img(a), 0.92, 1.85, 5.6, 4.3)
            fit_picture(slide, img(b), 6.82, 1.85, 5.6, 4.3)

        if kind in ("full", "pair") and s.get("take"):
            text_box(slide, s["take"], 0.92, 6.2, 11.5, 0.6, 18)
        if s.get("fig"):
            text_box(slide, "Figure " + s["fig"], 0.92, 6.95, 3.0, 0.35, 11, GRAY)

        notes = s.get("notes", "")
        if s.get("opt"):
            notes = "[OPTIONAL for a 45-minute talk] " + notes
        if notes:
            slide.notes_slide.notes_text_frame.text = notes

    if missing:
        sys.exit("Missing image files:\n  " + "\n  ".join(missing))
    add_sections(prs, SECTIONS)
    prs.save(str(out))
    n_opt = sum(1 for s in SLIDES if s.get("opt"))
    print(f"Wrote {out}: {len(SLIDES)} slides ({n_opt} marked optional)")
    print("Sections (first slide):")
    for name, i in SECTIONS:
        print(f"  {i + 1:3d}  {name}")


if __name__ == "__main__":
    ap = argparse.ArgumentParser()
    ap.add_argument("-o", "--out", default=str(TALKS / "Vis-MLM-talk.pptx"))
    ap.add_argument("--force", action="store_true", help="overwrite an existing file")
    args = ap.parse_args()
    out = Path(args.out)
    if out.exists() and not args.force:
        sys.exit(f"{out} exists. Use --force to overwrite it (hand edits will be lost), or -o for another name.")
    build(out)
