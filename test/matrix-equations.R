library(matlib)

sigma <- matrix(c(
  "\\sigma_1^2",               "\\textsf{sym}",
  "\\rho \\sigma_1 \\sigma_2", "\\sigma_2^2"), 2, 2, byrow = TRUE)


sig <- latexMatrix(sigma)

subsig <- function(i) {
  c(sig, "_{i}")
}

#Eqn(sig, "_1 = ", sig, "_2 = \\dots = ",)

Eqn(sig, "_1 = ",
    sig, "_2 = ",  
    "\\dots =", 
    sig, "_g")


# three subscripts

