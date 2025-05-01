# illustrating contrasts

library(matlib)

levels <- letters[1:4]
C <- contr.treatment(levels) |> print()

mu <- matrix(paste0("\\mu_", letters[1:4]), 4, 1)

X <- cbind(Avg= 1/4, C)
X

options(print.latexMatrix = list(display.labels=FALSE))

matX <- latexMatrix(X, fractions = TRUE)
Eqn(matX,  "\\times", latexMatrix(mu), " = ",
    matX %*% latexMatrix(mu))

C <- contr.sum(levels) |> print()

# basic example

X <- expand.grid(Treat = LETTERS[1:3],
                 Sex = c("F", "M"))
y <- outer(c(10, 20, 30), c(-5, 5), "+") |>
  c() + round(rnorm(n=6, sd = 2), 2)
df <- cbind(y, X)

# dummy variables = contr.treatment
model.matrix(y ~ Treat + Sex, data = df)

# sum-to-zero
contrasts(df$Treat) <- contr.sum(3)
contrasts(df$Sex) <- contr.sum(2)
model.matrix(y ~ Treat + Sex, data = df)

## Polynomial contrasts

M <- outer(1:8, 0:3, `^`)
colnames(M) <- c("int", "lin", "quad", "cubic")
M

# orthogonalize
M1 <- GramSchmidt(M, normalize = FALSE)

matplot(GramSchmidt(M), 
        type = "b",
        pch = as.character(0:3),
        cex = 1.5,
        cex.lab = 1.5,
        lty = 1,
        lwd = 2,
        xlab = "X",
        ylab = "Coefficient")


# contrasts
c1 <- c(1, 1, -1,-1)
c2 <- c(1, -1, 0, 0)
c3 <- c(0, 0, 1, -1)
latexMatrix(matrix(c1, nrow=1))

C <- cbind(c1,c2,c3) 
#rownames(C) <- paste0("gp", 1:4)
rownames(C) <- outer(LETTERS[1:2], 1:2, paste0) |> t() |> c()
C
t(C) %*% C

# Factorial from kronecker product

C.group <- contr.sum(3) |> print()
C.sex <- contr.treatment(2) |> print()

X.group <- cbind(1, C.group)
rownames(X.group) <- paste0("A", 1:3)
colnames(X.group) <- c("", "G13", "G23")
X.group

X.sex   <- cbind(1, C.sex)
rownames(X.sex) <- c("F", "M")
colnames(X.sex) <- c("", "MvF")

#kronecker(X.group, X.sex)

kronecker(X.sex, X.group, make.dimnames = TRUE) 

kronecker(X.group, X.sex, make.dimnames = TRUE) 









