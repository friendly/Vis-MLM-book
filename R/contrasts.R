# contrasts

library(matlib)

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
