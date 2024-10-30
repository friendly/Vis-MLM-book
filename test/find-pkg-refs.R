# Search/replace for R packages

# **pkgname** package [R-cite] -> `r pkg("pkgname", cite=TRUE)`

pat <- "\*\*(.*)\*\* package \[@(.*)\]"

# **pkgname** package -> `r pkg("pkgname")`

pat <- "\*\*(.*)\*\* package"