# Content Errors Audit

Errors found across chapters during a full-book audit (2026-05-22). Issues already listed in
`reviews/reviewer-GavinK-comments.Rmd` or `issues/Ch06-issues.md` are excluded.

---

## Error kinds (tags)

| Tag | Description |
|-----|-------------|
| **doubled-word** | Adjacent duplicate word (e.g., "the the", "a an") |
| **typo** | Misspelling, wrong character, or wrong symbol |
| **grammar** | Wrong verb form, wrong pronoun, missing or extra word |
| **fragment** | Incomplete sentence left dangling in the text |
| **punctuation** | Missing or incorrect punctuation |
| **editorial** | `**TODO**` / `**FIXME**` marker left in rendered text |
| **wrong-operator** | Incorrect R operator used in prose (e.g., `:` vs `::`) |

---

## 1. Garbled list of methods (Ch02, lines 181–182)

**Tags**: [punctuation], [grammar]

```
This idea can be applied using *animated tours* of high-D
data (@sec-animated-tours),
principal components analysis
and *biplots* (@sec-biplot)
*canonical correlation plots* and with *canonical discriminant HE plots* (@sec-candisc).
```

A comma is missing after `(@sec-biplot)`, leaving two list items run together. The phrase "and with" immediately before "canonical discriminant HE plots" is also grammatically awkward. The list items should be separated and the conjunction cleaned up, e.g.:

```
... and *biplots* (@sec-biplot),
*canonical correlation plots*, and *canonical discriminant HE plots* (@sec-candisc).
```

---

## 2. Missing opening quotation mark in prose (Ch04, line 928)

**Tags**: [typo], [punctuation]

```
or filled (`geom = polygon"`)
```

The opening `"` before `polygon` is missing. Should be:

```
or filled (`geom = "polygon"`)
```

---

## 3. Doubled word "the the" in PCA math section (Ch05, line 343)

**Tags**: [doubled-word]

> "The eigenvalues, $\lambda_1, \lambda_2, \dots, \lambda_p$ are the variances of the **the** components"

Delete one "the":

> "are the variances of the components"

---

## 4. Doubled word "the the" in biplot section (Ch05, line 895)

**Tags**: [doubled-word]

> "almost 70% of the variance of `murder` is represented in the **the** 2D plot"

Delete one "the":

> "is represented in the 2D plot"

---

## 5. Misspelling of "collinearity" (Ch07, line 34)

**Tags**: [typo]

> "understand the nature of _colinearity_"

Should be:

> "understand the nature of _collinearity_"

---

## 6. Wrong possessive "Cooks's distance" (Ch07, line 90)

**Tags**: [typo]

> "Actual influence is measured by Cooks's distance"

Should be:

> "Actual influence is measured by Cook's distance"

---

## 7. Spurious "the" before "how" (Ch07, line 1779)

**Tags**: [typo], [grammar]

> "we can see directly **the** how individual cases become individually or jointly influential"

Delete the spurious "the":

> "we can see directly how individual cases become individually or jointly influential"

---

## 8. Visible TODO marker (Ch07, line 1793)

**Tags**: [editorial]

```
**TODO**: Fix up the code displayed here, from R/Duncan/Duncan-reg.R
```

This author note appears in the rendered text, just before the `avPlots()` code chunk. It should be removed or converted to a comment (`<!-- … -->`).

---

## 9. Dangling sentence fragment after bullet (Ch08, lines 285–287)

**Tags**: [fragment], [grammar]

```
*  Any _joint_ hypothesis (e.g., $\mathcal{H}_0:\beta_{\mathrm{Stress}}=0, \beta_{\mathrm{Coffee}}=0$)
can be tested visually, simply by observing whether the
hypothesized point, $(0, 0)$ here, lies inside or outside the joint confidence ellipse.
That hypothesis is rejected
*  The shadows of this ellipse on the horizontal and vertical axes
```

The sentence "That hypothesis is rejected" is incomplete; it has no continuation before the next bullet begins. The missing text likely explains when — e.g., "That hypothesis is rejected if the hypothesized point lies outside the ellipse."

---

## 10. Visible TODO marker (Ch08, line 323)

**Tags**: [editorial]

```
**TODO**: Maybe include this code only in the HTML version?
```

This appears in the rendered prose before the `car::confidenceEllipse()` code block. Should be removed or converted to a comment.

---

## 11. Missing period after cross-reference (Ch09, lines 22–23)

**Tags**: [punctuation]

```
This chapter illustrates the nature of collinearity geometrically, using data and confidence
ellipsoids (@sec-what-is-collin)
It describes diagnostic measures to assess these effects …
```

There is no period after `(@sec-what-is-collin)` before the new sentence begins. Add a period:

```
ellipsoids (@sec-what-is-collin).
It describes diagnostic measures…
```

---

## 12. Single colon instead of double colon for package operator (Ch09, line 227)

**Tags**: [typo], [wrong-operator]

> "First, I use `MASS:mvrnorm()` to construct"

The `::` namespace operator is written as a single `:`. Should be:

> "First, I use `MASS::mvrnorm()` to construct"

---

## 13. Doubled word "the the" before dataset name (Ch09, line 935)

**Tags**: [doubled-word]

> "I use the the `r dataset("genridge::Acetylene")` dataset"

Delete one "the":

> "I use the `r dataset("genridge::Acetylene")` dataset"

---

## 14. Wrong apostrophe — "it's" used as possessive (Ch10, line 118)

**Tags**: [typo], [grammar]

> "Aside from it's elegant geometric interpretation, Hotelling's $T^2$ has simple properties"

"it's" = "it is"; the possessive is "its":

> "Aside from its elegant geometric interpretation"

---

## 15. Redundant adjectives "different various" (Ch11, line 31)

**Tags**: [grammar]

> "reflects competency in different various subjects (reading, math, history, science, …)"

"different" and "various" are synonymous here; one should be removed:

> "reflects competency in various subjects"

---

## 16. Visible TODO marker — notation revision (Ch11, line 115)

**Tags**: [editorial]

```
**TODO**: Revise notation here, to be explicit and consistent about inclusion of $\boldsymbol{\beta}_0$ and size of $\mathbf{B}$.
```

Appears in the rendered text between a footnote and the MLM equation. Should be removed or converted to a comment.

---

## 17. Doubled word "the the" in ANCOVA example (Ch11, lines 2221–2222)

**Tags**: [doubled-word]

> "a hypothetical two-group design studying the\nthe effect of an exercise program"

Delete one "the":

> "a hypothetical two-group design studying the effect of an exercise program"

---

## 18. Visible TODO marker — coverage note (Ch11, line 2108)

**Tags**: [editorial]

```
**TODO** Sort out coverage here vs. @sec-influence-robust
```

Appears in the rendered text at the start of the multivariate influence section. Should be removed or commented out.

---

## 19. Visible TODO marker — section placement (Ch11, line 2187)

**Tags**: [editorial]

```
**TODO**: Consider moving this to @sec-vis-mlm and use much of the heplots MMRA vignette.
```

Appears at the start of the ANCOVA → MANCOVA section. Should be removed or commented out.

---

## 20. Doubled word "the the" in notation bullet (Ch14, line 133)

**Tags**: [doubled-word]

> "$\mathbf{H}_I$ is the $m \times m$ **the** submatrix of $\mathbf{H}$"

Delete one "the":

> "$\mathbf{H}_I$ is the $m \times m$ submatrix of $\mathbf{H}$"

---

## 21. Visible TODO marker — mvinfluence definition check (Ch14, line 284)

**Tags**: [editorial]

```
**TODO**: Check how these are defined in mvinfluence
```

Appears in the rendered text between two figure callouts. Should be removed or commented out.

---

## 22. Visible TODO marker — missing "What have we learned?" section (Ch14, line 645)

**Tags**: [editorial]

```
**TODO**: Add chapter "What have we learned?"
```

This appears as the very last line of the chapter, indicating the summary section was never written. Should be resolved (either write the section or remove the marker before publication).

---

## 23. Misspelling "substantitive" (Ch15, line 70)

**Tags**: [typo]

> "This example is concerned with the following substantitive questions:"

Should be:

> "This example is concerned with the following **substantive** questions:"

---

## 24. Missing word "groups" (Ch15, line 76)

**Tags**: [grammar]

> "Do the neurocognitive measures discriminate among **the** in the same or different ways?"

The word "groups" (or "them") is missing after "the":

> "Do the neurocognitive measures discriminate among **the groups** in the same or different ways?"

---

## 25. Missing period between two sentences (Ch15, lines 520–521)

**Tags**: [punctuation]

```
`r func("heplots::cqplot()")` implements this for `"mlm"` objects
Calling this function for the model `SC.mlm` produces @fig-SC-cqplot.
```

A period is missing after "objects" before the next sentence starts:

```
`r func("heplots::cqplot()")` implements this for `"mlm"` objects.
Calling this function for the model `SC.mlm` produces @fig-SC-cqplot.
```

---

## 26. Subject-verb agreement — "values … is" (Ch21, line 49)

**Tags**: [grammar]

> "predicted values from `predict()` for an LDA is the predicted _group membership_"

"predicted values" is plural; the verb should be "are":

> "predicted values from `predict()` for an LDA are the predicted _group membership_"

---

## 27. Doubled word "the the" in Acknowledgements (index.qmd, line 363)

**Tags**: [doubled-word]

> "participants in the **the** [ggplot2 extenders club]"

Delete one "the":

> "participants in the [ggplot2 extenders club]"
