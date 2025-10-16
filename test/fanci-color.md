---
title: "Reprex"
format: html
---
  
  ```{r}
#| comment: ''
#| results: asis
#| echo: false
old_hook <- fansi::set_knit_hooks(knitr::knit_hooks, which = c("output", "warning", "error", "message"))
options(crayon.enabled = TRUE)
```

```{r}
cat(cli::col_red("This is red"), "\n")
cat(cli::col_blue("This is blue"), "\n")

message(cli::col_green("This is green"))

warning(cli::style_bold("This is bold"))
```