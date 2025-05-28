library(matlib)

RXY <- latexMatrix("\\mathbf{R}", nrow=2, ncol=2, matrix="bmatrix")
# use X, y as subscripts

RXY <- paste0("\\mathbf{R}_", c("{XX}", "{YX}", "{XY}", "{YY}")) |>
  matrix(nrow = 2, ncol = 2) 
RXY <- latexMatrix(RXY, matrix = "bmatrix") 

Eqn("\\mathbf{R}_{XY} =", RXY)

I <- "\\mathbf{I}_{s \times s}"
Rho <- latexMatrix("\\rho", nrow="s", ncol = "s", diag=TRUE)

RUV <- matrix(c(I, Rho, Rho, I), 2,2)
