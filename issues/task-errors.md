# Content Errors Audit

Errors found across chapters during a full-book audit (2026-05-22). Issues already listed in
`reviews/GavinK-comments.Rmd` or `issues/Ch06-issues.md` are excluded.

---

## Error kinds (tags)

| Tag | Description |
|-----|-------------|
| **doubled-word** | Adjacent duplicate word (e.g., "the the", "a an") |
| **typo** | Misspelling, wrong character, or wrong symbol |
| **grammar** | Wrong verb form, wrong pronoun, missing or extra word |
| **fragment** | Incomplete sentence left dangling in the text |
| **punctuation** | Missing or incorrect punctuation |
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

## 3. Garbled verb phrase "being appearing" (Ch05, line 43)

**Tags**: [grammar]

> "and capable of **being appearing** fatter or slimmer when rotated from different views"

"being appearing" is a doubled participle. Remove "being":

> "and capable of appearing fatter or slimmer when rotated from different views"

---

## 4. Misspelling "lower-dimenional" in figure caption (Ch05, line 75)

**Tags**: [typo]

> "transforms it to a **lower-dimenional** space"

Missing "s" in "dimensional":

> "transforms it to a lower-dimensional space"

---

## 5. Doubled word "the the" in PCA math section (Ch05, line 343)

**Tags**: [doubled-word]

> "The eigenvalues, $\lambda_1, \lambda_2, \dots, \lambda_p$ are the variances of the **the** components"

Delete one "the":

> "are the variances of the components"

---

## 6. Wrong numbered-item cross-reference "point (5)" (Ch05, line 493)

**Tags**: [typo]

> `The "scores" on the principal components can be calculated (point **(5)** above) as $\mathbf{PC} = \mathbf{X} \mathbf{V}$`

Item 5 in the preceding numbered list (line 343) covers eigenvalues, not scores. The formula
$\mathbf{PC} = \mathbf{X} \mathbf{V}$ is stated in item 4. The cross-reference should read:

> `(point (4) above)`

---

## 7. Wrong `prcomp()` option name `center.` (Ch05, line 686)

**Tags**: [typo], [wrong-operator]

> "`center` gives the means of the variables when the option `center. = TRUE` (the default)"

Only `scale.` carries a trailing dot in `prcomp()`; `center` does not. Should be:

> "when the option `center = TRUE` (the default)"

---

## 8. Doubled word "the the" in biplot section (Ch05, line 895)

**Tags**: [doubled-word]

> "almost 70% of the variance of `murder` is represented in the **the** 2D plot"

Delete one "the":

> "is represented in the 2D plot"

---

## 9. Misspelling "datsets" (Ch05, line 1217)

**Tags**: [typo]

> "in the dataset `datsets::state.x77`"

"datsets" should be "datasets":

> "in the dataset `datasets::state.x77`"

---

## 10. Garbled article "as a the" (Ch05, line 1256)

**Tags**: [grammar], [typo]

> "These can be calculated directly **as a the** coefficients of a multivariate regression"

One of the two articles must be removed:

> "These can be calculated directly as the coefficients of a multivariate regression"

---

## 11. Spurious unmatched closing parenthesis in inline math (Ch05, line 2155)

**Tags**: [punctuation]

> "the original $640 \times 955$**)**  image"

A stray `)` appears outside the math delimiters. Remove it:

> "the original $640 \times 955$ image"

---

## 12. Doubled preposition "to from" (Ch05, line 2183)

**Tags**: [grammar]

> "The transformation **to from** data space to principal components space"

Delete the first "to":

> "The transformation from data space to principal components space"

---

## 13. Doubled word "the the" before "largest" (Ch05, line 2223)

**Tags**: [doubled-word]

> "I find the noteworthy points with the three **the** largest $D^2$ values"

Delete one "the":

> "I find the noteworthy points with the three largest $D^2$ values"

---

## 14. Misspelling of "collinearity" (Ch07, line 34)

**Tags**: [typo]

> "understand the nature of _colinearity_"

Should be:

> "understand the nature of _collinearity_"

---

## 15. Wrong possessive "Cooks's distance" (Ch07, line 90)

**Tags**: [typo]

> "Actual influence is measured by Cooks's distance"

Should be:

> "Actual influence is measured by Cook's distance"

---

## 16. Spurious "the" before "how" (Ch07, line 1779)

**Tags**: [typo], [grammar]

> "we can see directly **the** how individual cases become individually or jointly influential"

Delete the spurious "the":

> "we can see directly how individual cases become individually or jointly influential"

---

## 17. Dangling sentence fragment after bullet (Ch08, lines 285–287)

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

## 18. Missing period after cross-reference (Ch09, lines 22–23)

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

## 19. Single colon instead of double colon for package operator (Ch09, line 227)

**Tags**: [typo], [wrong-operator]

> "First, I use `MASS:mvrnorm()` to construct"

The `::` namespace operator is written as a single `:`. Should be:

> "First, I use `MASS::mvrnorm()` to construct"

---

## 20. Doubled word "the the" before dataset name (Ch09, line 935)

**Tags**: [doubled-word]

> "I use the the `r dataset("genridge::Acetylene")` dataset"

Delete one "the":

> "I use the `r dataset("genridge::Acetylene")` dataset"

---

## 21. Wrong apostrophe — "it's" used as possessive (Ch10, line 118)

**Tags**: [typo], [grammar]

> "Aside from it's elegant geometric interpretation, Hotelling's $T^2$ has simple properties"

"it's" = "it is"; the possessive is "its":

> "Aside from its elegant geometric interpretation"

---

## 22. Redundant adjectives "different various" (Ch11, line 31)

**Tags**: [grammar]

> "reflects competency in different various subjects (reading, math, history, science, …)"

"different" and "various" are synonymous here; one should be removed:

> "reflects competency in various subjects"

---

## 23. Doubled word "the the" in ANCOVA example (Ch11, lines 2221–2222)

**Tags**: [doubled-word]

> "a hypothetical two-group design studying the\nthe effect of an exercise program"

Delete one "the":

> "a hypothetical two-group design studying the effect of an exercise program"

---

## 24. Doubled word "the the" in notation bullet (Ch14, line 133)

**Tags**: [doubled-word]

> "$\mathbf{H}_I$ is the $m \times m$ **the** submatrix of $\mathbf{H}$"

Delete one "the":

> "$\mathbf{H}_I$ is the $m \times m$ submatrix of $\mathbf{H}$"

---

## 25. Misspelling "substantitive" (Ch15, line 70)

**Tags**: [typo]

> "This example is concerned with the following substantitive questions:"

Should be:

> "This example is concerned with the following **substantive** questions:"

---

## 26. Missing word "groups" (Ch15, line 76)

**Tags**: [grammar]

> "Do the neurocognitive measures discriminate among **the** in the same or different ways?"

The word "groups" (or "them") is missing after "the":

> "Do the neurocognitive measures discriminate among **the groups** in the same or different ways?"

---

## 27. Missing period between two sentences (Ch15, lines 520–521)

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

## 28. Subject-verb agreement — "values … is" (Ch21, line 49)

**Tags**: [grammar]

> "predicted values from `predict()` for an LDA is the predicted _group membership_"

"predicted values" is plural; the verb should be "are":

> "predicted values from `predict()` for an LDA are the predicted _group membership_"

---

## 29. Doubled word "the the" in Acknowledgements (index.qmd, line 363)

**Tags**: [doubled-word]

> "participants in the **the** [ggplot2 extenders club]"

Delete one "the":

> "participants in the [ggplot2 extenders club]"
