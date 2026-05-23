# Chapter 6 Issues

Errors found in `06-linear_models.qmd` during review (2026-05-21).

---

## 1. Interaction formula — wrong algebraic expansion (line 340–342)

The expansion of `y ~ x1 * x2` is written as:

```
y = β₀ + β₁x₁ + β₂x₂ + β₁x₁ * β₂x₂
  = β₀ + (β₁ + β₂x₂)x₁ + β₂x₂
```

The interaction term is not `β₁x₁ · β₂x₂` — interactions in a GLM have their own independent parameter. The correct expansion is:

```
y = β₀ + β₁x₁ + β₂x₂ + β₃x₁x₂
  = β₀ + (β₁ + β₃x₂)x₁ + β₂x₂
```

The conclusion ("slope for x₁ changes with x₂") is correct, but the derivation is wrong.

---

## 2. Typo in design matrix column labels (line 555)

The design matrix is labeled:

```
X = [1, x_b, x_c, x_c]
```

The last column should be `x_d`, not a second `x_c`.

---

## 3. Wrong model name in prose (line 296)

> "The problem is that x = `Experience` in model `workers.mod` is represented not by the raw values…"

Should refer to `workers.mod2` (the quadratic `poly()` model), not `workers.mod` (the simple linear model).

---

## 4. Quadratic coefficient interpretation inconsistency (lines 306–309)

The hardcoded equation shows:

$$\widehat{\text{Income}} = 23.07 + 2.3(\text{Experience}) - 0.03(\text{Experience}^2)$$

The prose then says the yearly increase "decreases by $330." With Income in thousands, the quadratic term implies a decrease of about $60 per year, not $330. The displayed equation coefficients and the prose interpretation do not reconcile. Either the equation is truncated/rounded incorrectly, or the prose is wrong.

---

## 5. Dangling sentence fragment (lines 680–681)

The deviation coding section contains:

> "The parameters estimated with this coding are:
> With this coding, the intercept is…"

The first sentence introduces a list that never appears and is immediately replaced by a new sentence. The fragment "The parameters estimated with this coding are:" should be removed.
