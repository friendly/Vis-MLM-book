## Stepdown analysis of multivariate models in R
# https://stackoverflow.com/questions/79594493/stepdown-analysis-of-multivariate-models-in-r

Roy - Bargmann stepdown tests are commonly recommended for multivariate linear models fit with `lm()` as:

```
lm(cbind(y1, y2, y3, ...) ~ x1 + x2 + x3 + ...)
```

But I can't find any implementation in R for class `"mlm"` objects.  The idea is relatively straight-forward. Simple fit a
collection of models, with the Y variables in a defined order, where in each model after the first, a response on the
left-hand-side becomes a predictor on the right-hand-side.

```
lm(cbind(y1, y2, y3) ~ x1 + x2 + x3 + ...)
lm(cbind(    y2, y3) ~ x1 + x2 + x3 + y1 + ...)
lm(cbind(        y3) ~ x1 + x2 + x3 + y1, y2 + ...)
```

Sets of models like these can be fit `manuall` as above, but I'll looking for some way to generate this collection
in a function and return these in a list. 

I wonder if `update()` can help here or else some other way to manipulate the model formula.

Tests:

mod1 <- lm(cbind(read, math) ~ log2(income) + educ, 
           data= heplots::NLSY |> filter(income != 0))
mod2 <- lm(cbind(read,math) ~ antisoc + hyperact + log2(income) + educ, 
           data = heplots::NLSY |> filter(income != 0))

# extract univariate models
update(mod2, read ~ .) |> as.formula()
update(mod2, math ~ .)


update(mod1, cbind(read, math, antisoc, hyperact) ~ .)


# Ben Bolker

np <- 3; nr <- 5
resp_vars <- paste0("y", 1:np)
pred_vars <- paste0("x", 1:nr)
ffun <- function(i) {
   pp <- sprintf("cbind(%s)", paste(resp_vars[i:np], collapse = ", "))
   rr <- c(pred_vars, resp_vars[seq_len(i-1)])
   ff <- reformulate(rr, resp = pp)
}
(form_list <- lapply(1:np, ffun))


# MLM model equations

library(equatiomatic)
library(matlib)

mod_eq <- lm(cbind(read, math) ~ income + educ, 
           data= heplots::NLSY)

extract_eq(mod_eq)

$$
\operatorname{cbind(read,\ math)} = \alpha + \beta_{1}(\operatorname{income}) + \beta_{2}(\operatorname{educ}) + 
                                    \alpha + \beta_{4}(\operatorname{income}) + \beta_{5}(\operatorname{educ}) + \epsilon
$$

Should be:

(\mathbf{y}_\textrm{read}, \mathbf{y}_\textrm{math}) =
$$
\operatorname{(read,\ math)} = \boldsymbol{\alpha} + 
                               \boldsymbol{\beta}_{1}(\operatorname{income}) + 
                               \boldsymbol{\beta}_{2}(\operatorname{educ}) + 
                               \boldsymbol{\epsilon}
$$

## Stepdown procedure

from Tabachnick/Fidell:

ANCOVA is used after MANOVA (or MANCOVA) in Roy– Bargmann stepdown analysis
where the goal is to assess the contributions of the various DVs to a significant effect. One asks
whether, after adjusting for differences on higher- priority DVs serving as covariates, there is any
significant mean difference among groups on a lower- priority DV. That is, does a lower- priority
DV provide additional separation of groups beyond that of the DVs already used? In this sense,
ANCOVA is used as a tool in interpreting MANOVA results.



