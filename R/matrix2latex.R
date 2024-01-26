#' ---
#' title: convert matrix to latex
#' ---

# from: https://stackoverflow.com/questions/20749444/converting-r-matrix-into-latex-matrix-in-the-math-or-equation-environment

matrix2latex <- function(mat, 
                         type = c("b", "p", "", "B", "v", "V"),
                         digits = 2) {

  matr <- round(mat, digits = digits)  
  type <- match.arg(type)
  begin <- paste0("\\begin{", type, "matrix", "}")
  end   <- paste0("\\end{", type, "matrix", "}")

  # printmrow <- function(x) {
  #   cat(cat(x,sep=" & "),"\\\\ \n")
  # }
  printmrow <- function(x) {
    ret <- paste("  ", paste(x, collapse = " & "), "\\\\ \n")
    sprintf(ret)
  }
  

  # cat(begin,"\n")
  # body <- apply(mat, 1, printmrow)
  # cat(end)
  
  out <- apply(mat, 1, printmrow)
  out <- paste(
    begin, "\n",
    paste(out, collapse = " "),
    end, "\n"
    )
  cat(out)
}

bmatrix = function(x, digits=NULL, ...) {
  library(xtable)
  default_args = list(include.colnames=FALSE, 
                      only.contents=TRUE,
                      include.rownames=FALSE, 
                      hline.after=NULL, 
                      comment=FALSE,
                      print.results=FALSE)
  passed_args = list(...)
  calling_args = c(list(x=xtable(x, digits=digits)),
                   c(passed_args,
                     default_args[setdiff(names(default_args), names(passed_args))]))
  cat("\\begin{bmatrix}\n",
      do.call(print.xtable, calling_args),
      "\\end{bmatrix}\n")
}

