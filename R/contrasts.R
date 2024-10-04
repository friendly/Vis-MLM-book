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


# contrasts
library(matlib)
c1 <- c(1,1,-1,-1)
c2 <- c(1, -1, 0, 0)
c3 <- c(0, 0, 1, -1)
#symbolicMatrix(matrix(c1, nrow=1))

C <- cbind(c1,c2,c3) 
#rownames(C) <- paste0("gp", 1:4)
rownames(C) <- outer(LETTERS[1:2], 1:2, paste0) |> t() |> c()
C
t(C) %*% C




