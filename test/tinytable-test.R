#library(remotes)
remotes::install_github("vincentarelbundock/tinytable")

library(tinytable)
dat <- data.frame(matrix(1:20, ncol=5))
colnames(dat) <- NULL
bg <- hcl.colors(20, "Inferno")
col <- ifelse(as.matrix(dat) < 11, 
              tail(bg, 1), 
              head(bg, 1))

tt(dat, width = .5, theme = "void", placement = "H") |>
  style_tt(
    i = 1:4,
    j = 1:5,
    color = col,
    background = bg)

