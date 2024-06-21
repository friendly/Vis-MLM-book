# model matrix

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



