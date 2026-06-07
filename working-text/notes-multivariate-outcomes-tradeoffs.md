# Notes: Multivariate outcomes and decision rules in clinical trials

**Source:** https://xynthiakavelaars.github.io/OpenInferenceLab/posts/p02/
**Author:** Xynthia Kavelaars
**Topic:** Multiple outcomes, multiple decision rules in clinical trials

---

## What the post is about

A short, well-written blog post on the problem of making decisions when a treatment has
**multiple outcomes that may trade off against each other**. The running example: a cancer
treatment that improves cognition (+0.185) but worsens fatigue (-0.23). Which decision rule
should you use to declare "superiority"?

Four rules are compared:

| Rule | Description |
|------|-------------|
| **Single** | Test one pre-specified outcome only |
| **Any** | Improvement on ≥ 1 outcome (most permissive) |
| **All** | Improvement on every outcome (most restrictive) |
| **Compensatory** | Weighted combination: $w_1 \delta_1 + w_2 \delta_2 > 0$ |

The compensatory rule is the richest: varying weights from "fatigue dominant (0.25, 0.75)"
to "cognition dominant (0.90, 0.10)" produces p-values ranging from 0 to 1 for the **same data**.

R package: `bmco`, function `bmvb()` (Bayesian multivariate analysis).

---

## Where this could fit in the book

### Best fit: Ch 10 (Hotelling's $T^2$) or Ch 11 (MLM review)

The cancer/cognition/fatigue example is a natural motivation for **why we need multivariate
tests** rather than testing each outcome separately. The "Any" vs "All" vs compensatory
framing maps directly onto the tension between univariate and multivariate testing:

- Running separate $t$-tests = implicitly using the "Any" rule with no multiplicity control.
- Hotelling's $T^2$ = a specific multivariate summary, but with equal implicit weighting.
- The compensatory rule with varying weights = exactly the kind of "what combination matters?"
  question that discriminant analysis and canonical analysis address.

**Possible use:** A motivating paragraph or short callout box in §10.x or §11.x, noting
that the choice of multivariate test statistic embeds implicit assumptions about the
relative importance of the outcomes — much like the choice of weights in a compensatory rule.

### Also relevant: Ch 15 (Case studies)

The treatment-vs-control, two-outcome setup is simple enough to reproduce as a short
worked example. With 200 per group and two correlated outcomes, a HE plot would
immediately visualize the tradeoff: the H ellipse would point in the direction of
the treatment effect (improved cognition, worsened fatigue), and its overlap/non-overlap
with the E ellipse would tell the "superiority" story visually.

**Sketch of example:**
```r
library(heplots)
# Simulate data matching the post's parameters
set.seed(42)
n <- 200
control <- MASS::mvrnorm(n, mu = c(0, 0),     Sigma = matrix(c(1, 0.3, 0.3, 1), 2))
treated <- MASS::mvrnorm(n, mu = c(0.185, -0.23), Sigma = matrix(c(1, 0.3, 0.3, 1), 2))
df <- data.frame(
  group    = factor(rep(c("Control", "Treatment"), each = n)),
  cognition = c(control[,1], treated[,1]),
  fatigue   = c(control[,2], treated[,2])
)
mod <- lm(cbind(cognition, fatigue) ~ group, data = df)
heplot(mod, fill = TRUE)
```
The HE plot would show exactly the tradeoff the post describes — and could be annotated
with the direction vectors corresponding to different compensatory weights.

### Possible connection to §13 (equal covariance)

The compensatory rule also assumes the covariance structure is the same across groups —
a Box's M / homogeneity of covariance question that maps to Ch 13.

---

## Key quote worth using

> "Different rules produced vastly different superiority conclusions for the same data."

This is a crisp way to motivate *why the choice of multivariate summary statistic matters*,
which is a recurring theme in the book's treatment of Pillai, Wilks, Roy, etc.

---

## R package note

`bmco` / `bmvb()` is Bayesian and unlikely to be used directly in the book, but the
**conceptual framework** (decision rules as weighted combinations of outcomes) is
directly relevant to the frequentist material in Chs 10–12.

---

## Action items

- [ ] Consider a callout box in Ch 10 or 11 motivating the multivariate approach
      with the "different rules, same data" framing from this post.
- [ ] Consider a short HE-plot example in Ch 15 using simulated data matching
      the post's treatment/control scenario.
- [ ] Cite/link the post if used (it's a blog post, not a paper — use `@misc` in bib).
