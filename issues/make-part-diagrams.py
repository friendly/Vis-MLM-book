#!/usr/bin/env python3
# make-part-diagrams.py — one-off generator that wrote the initial
# latex/diagrams/{part,chap}*.tex sources (part-page and chapter-opener
# bubble diagrams, 2026-07-02). The .tex files are the maintained
# artifacts: edit those directly for label/layout tweaks.
# WARNING: re-running this OVERWRITES all latex/diagrams/*.tex sources,
# discarding any hand edits. Only re-run for wholesale restructuring,
# then rebuild PDFs with: sh latex/diagrams/make-diagrams.sh

import os

OUT = "/Users/gklorfine/Non-iCloud/Data-Vis_Lab/Vis-MLM-book/latex/diagrams"

# chapter number -> (part color, chapter title, root size/textwidth/titlefont,
#                    [satellite labels], clockwise-from, sibling angle, level distance)
CHAPTERS = {
    1: ("partI", "Warm-up Exercises", (3.3, 2.9, r"\normalsize"), [
        "1.1 The magic of graphs",
        "1.2 ONE, TWO, MANY",
        "1.3 Flatland",
        "1.4 EUREKA!",
        "1.5 Multivariate discoveries",
    ], 90, 72, 3.3),
    2: ("partI", "Introduction", (3.3, 2.9, r"\normalsize"), [
        "2.1 Why multivariate?",
        "2.2 Univariate to multivariate",
        "2.3 Visualization is harder",
        "2.4 Understanding MLM results",
    ], 90, 90, 3.3),
    3: ("partI", "Getting Started", (3.3, 2.9, r"\normalsize"), [
        "3.1 Why plot your data?",
        "3.2 Plots for data analysis",
    ], 180, 180, 3.3),
    4: ("partII", "Plots of Multivariate Data", (3.4, 3.0, r"\normalsize"), [
        "4.1 Bivariate summaries",
        "4.2 Data ellipses",
        "4.3 Meet the penguins",
        "4.4 Bagplots",
        "4.5 Bivariate density plots",
        "4.6 Simpson's paradox",
        "4.7 Normality \\& outliers",
        "4.8 Scatterplot matrices",
        "4.9 Corrgrams",
        "4.10 Generalized pairs plots",
        "4.11 Parallel coordinates",
        "4.12 Animated tours",
        "4.13 Network diagrams",
    ], 90, 27.7, 4.3),
    5: ("partII", "Dimension Reduction", (3.3, 2.9, r"\normalsize"), [
        "5.1 Flatland \\& Spaceland",
        "5.2 PCA",
        "5.3 Biplots",
        "5.4 Nonlinear reduction",
        "5.5 Variable ordering",
        "5.6 Eigenfaces",
        "5.7 Outlier detection",
    ], 90, 51.4, 3.5),
    6: ("partIII", "Overview of Linear Models", (3.4, 3.0, r"\normalsize"), [
        "6.1 The General Linear Model",
        "6.2 Model formulas",
        "6.3 Model matrices",
    ], 90, 120, 3.3),
    7: ("partIII", "Plots for Univariate Response Models", (3.5, 3.1, r"\small"), [
        "7.1 Regression quartet",
        "7.2 Coefficient displays",
        "7.3 Added-variable plots",
        "7.4 Effect displays",
        "7.5 Outliers \\& influence",
    ], 90, 72, 3.3),
    8: ("partIII", "Topics in Linear Models", (3.3, 2.9, r"\normalsize"), [
        "8.1 Data space \\& $\\boldsymbol{\\beta}$ space",
        "8.2 Measurement error",
    ], 180, 180, 3.3),
    9: ("partIII", "Collinearity \\& Ridge Regression", (3.4, 3.0, r"\normalsize"), [
        "9.1 What is collinearity?",
        "9.2 Measuring collinearity",
        "9.3 Tableplots",
        "9.4 Collinearity biplots",
        "9.5 Remedies",
        "9.6 Ridge regression",
        "9.7 Univariate ridge traces",
        "9.8 Bivariate ridge traces",
        "9.9 Low-rank views",
    ], 90, 40, 3.8),
    10: ("partIV", "Hotelling's $T^2$", (3.3, 2.9, r"\normalsize"), [
        "10.1 Generalized $t$-test",
        "10.2 $T^2$ properties",
        "10.3 HE plot \\& discriminant axis",
        "10.4 Discriminant analysis",
        "10.5 More variables",
        "10.6 Variance: $\\eta^2$",
        "10.7 The grand scheme",
    ], 90, 51.4, 3.5),
    11: ("partIV", "Multivariate Linear Models", (3.4, 3.0, r"\normalsize"), [
        "11.1 Structure of the MLM",
        "11.2 Fitting the model",
        "11.3 Multivariate tests",
        "11.4 ANOVA $\\rightarrow$ MANOVA",
        "11.5 Factorial MANOVA",
        "11.6 MRA $\\rightarrow$ MMRA",
        "11.7 Model diagnostics",
        "11.8 ANCOVA $\\rightarrow$ MANCOVA",
    ], 90, 45, 3.6),
    12: ("partIV", "Visualizing Multivariate Models", (3.5, 3.1, r"\small"), [
        "12.1 HE plot framework",
        "12.2 HE plot construction",
        "12.3 HE plots",
        "12.4 Significance vs.\\ effect scaling",
        "12.5 Contrasts \\& hypotheses",
        "12.6 HE plot matrices",
        "12.7 Canonical analysis",
        "12.8 Factorial MANOVA",
        "12.9 MMRA",
        "12.10 Canonical correlation",
        "12.11 MANCOVA models",
    ], 90, 32.7, 4.1),
    13: ("partIV", "Visualizing Equality of Covariance Matrices", (3.5, 3.1, r"\small"), [
        "13.1 Homogeneity in ANOVA",
        "13.2 Levene's test",
        "13.3 Homogeneity in MANOVA",
        "13.4 Box's $\\mathcal{M}$ test",
        "13.5 Visualizing heterogeneity",
        "13.6 Visualizing Box's $\\mathcal{M}$",
        "13.7 Low-rank views",
        "13.8 Other measures",
        "13.9 Multivariate Levene's test",
    ], 90, 40, 3.8),
    14: ("partIV", "Multivariate Influence \\& Robust Estimation", (3.5, 3.1, r"\small"), [
        "14.1 Multivariate influence",
        "14.2 Mysterious Case 9",
        "14.3 NLSY data",
        "14.4 Penguins: influence",
        "14.5 Robust estimation",
        "14.6 Penguins: robust",
    ], 90, 60, 3.4),
    15: ("partIV", "Discriminant Analysis", (3.3, 2.9, r"\normalsize"), [
        "15.1 Main ideas of LDA",
        "15.2 Theory",
        "15.3 Classification accuracy",
        "15.4 Classifying new penguins",
        "15.5 Classification: data space",
        "15.6 Classification: discriminant space",
        "15.7 Prediction regions",
        "15.8 Regions: discriminant space",
        "15.9 MANOVA \\& CDA",
        "15.10 Quadratic DA",
    ], 90, 36, 3.9),
}

# part number -> (color, roman, part title, [(chap number, label)], from, sibling, dist)
PARTS = {
    1: ("partI", "I", "Orienting Ideas", [
        (1, "Warm-up Exercises"),
        (2, "Introduction"),
        (3, "Getting Started"),
    ], 90, 120, 4.7),
    2: ("partII", "II", "Exploratory Methods", [
        (4, "Plots of Multivariate Data"),
        (5, "Dimension Reduction"),
    ], 135, 180, 4.7),
    3: ("partIII", "III", "Univariate Linear Models", [
        (6, "Overview of Linear Models"),
        (7, "Plots for Univariate Response Models"),
        (8, "Topics in Linear Models"),
        (9, "Collinearity \\& Ridge Regression"),
    ], 135, 90, 4.8),
    4: ("partIV", "IV", "Multivariate Linear Models", [
        (10, "Hotelling's $T^2$"),
        (11, "Multivariate Linear Models"),
        (12, "Visualizing Multivariate Models"),
        (13, "Equality of Covariance Matrices"),
        (14, "Influence \\& Robust Estimation"),
        (15, "Discriminant Analysis"),
    ], 120, 60, 5.2),
}

CHAP_TEMPLATE = r"""% Chapter {num} opener diagram: "{title_plain}"
% Center bubble = chapter; satellites = its numbered sections.
% Section list mirrors the chapter .qmd — update here when sections change,
% then rebuild with ./make-diagrams.sh
\documentclass[border=8pt]{{standalone}}
\input{{diagram-common.tex}}
\begin{{document}}
\begin{{tikzpicture}}[
  sat/.style={{satbubble={color}, minimum size=2.1cm, text width=1.85cm,
              font=\sffamily\footnotesize}}]
% connection bands (drawn first; the bubbles cover their ends)
{bands}
% bubbles
\node[rootbubble={color}, minimum size={rsize}cm, text width={rwidth}cm{rfont}]
  {{\bubbletitle{{{num}}}{{{title}}}}};
{sats}
\end{{tikzpicture}}
\end{{document}}
"""

PART_TEMPLATE = r"""% Part {roman} page diagram: "{title_plain}"
% Center bubble = part; satellites = its chapters (each chapter's sections
% appear on that chapter's opening page). Rebuild with ./make-diagrams.sh
\documentclass[border=8pt]{{standalone}}
\input{{diagram-common.tex}}
\begin{{document}}
% wider bands for the larger part-page bubbles
\setlength\bandroot{{0.66cm}}
\setlength\bandmid{{0.22cm}}
\setlength\bandtip{{0.38cm}}
\begin{{tikzpicture}}[
  sat/.style={{satbubble={color}, minimum size=3.0cm, text width=2.6cm,
              font=\sffamily\small}}]
% connection bands (drawn first; the bubbles cover their ends)
{bands}
% bubbles
\node[rootbubble={color}, minimum size=4.2cm, text width=3.7cm, font=\sffamily\bfseries\large]
  {{\bubbletitle{{Part {roman}}}{{{title}}}}};
{sats}
\end{{tikzpicture}}
\end{{document}}
"""


def strip_tex(s):
    for a, b in [("\\&", "&"), ("$", ""), ("\\boldsymbol{\\beta}", "beta"),
                 ("\\mathcal{M}", "M"), ("\\rightarrow", "->"), ("\\ ", " ")]:
        s = s.replace(a, b)
    return s


def angles(cfrom, sib, n):
    out = []
    for i in range(n):
        a = (cfrom - i * sib) % 360
        a = round(a, 1)
        out.append(int(a) if a == int(a) else a)
    return out


for num, (color, title, (rsize, rwidth, rfont), sats, cfrom, sib, dist) in CHAPTERS.items():
    angs = angles(cfrom, sib, len(sats))
    bands = "\n".join(f"\\band{{{color}}}{{{a}}}{{{dist}}}" for a in angs)
    satnodes = "\n".join(
        f"\\node[sat] at ({a}:{dist}) {{{lab}}};" for a, lab in zip(angs, sats))
    rfont_s = "" if rfont == r"\normalsize" else ", font=\\sffamily\\bfseries" + rfont
    src = CHAP_TEMPLATE.format(
        num=num, title=title, title_plain=strip_tex(title), color=color,
        rsize=rsize, rwidth=rwidth, rfont=rfont_s,
        bands=bands, sats=satnodes)
    with open(os.path.join(OUT, f"chap{num}.tex"), "w") as f:
        f.write(src)

for pnum, (color, roman, title, chaps, cfrom, sib, dist) in PARTS.items():
    angs = angles(cfrom, sib, len(chaps))
    bands = "\n".join(f"\\band{{{color}}}{{{a}}}{{{dist}}}" for a in angs)
    satnodes = "\n".join(
        f"\\node[sat] at ({a}:{dist}) {{{{\\large {n}}}\\\\[2pt] {lab}}};"
        for a, (n, lab) in zip(angs, chaps))
    src = PART_TEMPLATE.format(
        roman=roman, title=title, title_plain=strip_tex(title), color=color,
        bands=bands, sats=satnodes)
    with open(os.path.join(OUT, f"part{pnum}.tex"), "w") as f:
        f.write(src)

print("wrote", len(CHAPTERS), "chapter +", len(PARTS), "part diagram sources")
