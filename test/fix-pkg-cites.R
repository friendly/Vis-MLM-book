# **pkgname** package [R-pkgname] -> `r package("pkgname", cite=TRUE)`
# **pkgname** package [![] `r package("pkgname", cite=FALSE)`

# In Find in Files: use find: \*\*(\w+)\*\*
#     Replace with:           `r pkg("\1", cite=FALSE)`
library(stringr)
text <- "
Among my favorite packages are the **ggplot2** package [@R-ggplot],
the **car** package [@R-car] and
the **matlib** package [@R-matlib] and
the uncited **ggridges** package, plus **ggrepel** package.
"

find <- c("\\*\\*(\\w+)\\*\\*\\s+package\\s+\\[@R-(\\w+)\\]",
          "\\*\\*(\\w+)\\*\\*\\s+package\\s+[^\\[]")
rep <- c('`r package("\\1", cite=TRUE)`',
         '`r package("\\1", cite=FALSE)`')

str_replace_all(text, find[1], rep[1]) |> cat()
# doesn't work
str_replace_all(text, find[2], rep[2]) |> cat()

xfun::gsub_file("C:/R/projects/Vis-MLM-book/03-multivariate_plots.qmd", find[1], rep[1])
xfun::gsub_file("C:/R/projects/Vis-MLM-book/04-pca-biplot.qmd", find[1], rep[1])

xfun::gsub_file("C:/R/Projects/Vis-MLM-book/child/02-anscombe.qmd", find[1], rep[1])
xfun::gsub_file("C:/R/Projects/Vis-MLM-book/child/03-data-ellipse.qmd", find[1], rep[1])
xfun::gsub_file("C:/R/Projects/Vis-MLM-book/child/03-grand-tour.qmd", find[1], rep[1])



qmd_files <- fs::dir_ls(here::here("child/"), glob = "*.qmd")


# use xfun::gsub_files() for this