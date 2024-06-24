# model matrix

# expanding a formula

f1 = formula(y ~ a * b * c * d * e)
#To spell out the interaction terms, we extract the terms from the value returned by terms.formula():
  
terms = attr(terms.formula(f1), "term.labels")
#And then we can convert it back to a formula:
  
f1_exp = as.formula(sprintf("y ~ %s", paste(terms, collapse="+")))

f2 <- formula(y ~ (x1 + x2 + x3 + x4)^2)
terms = attr(terms.formula(f2), "term.labels")
f2_exp = as.formula(sprintf("y ~ %s", paste(terms, collapse="+"))) 

set.seed(42)
inc <- round(runif(n=9, 20, 40))
type <- rep(c("bc", "wc", "prof"), each =3)

mm <- model.matrix(~ inc + type) 
data.frame(type, mm)

model.matrix(~ inc * type)

model.matrix(~ inc : type)

# ordered factor
typ <- ordered(type)
model.matrix(~ inc + typ)



