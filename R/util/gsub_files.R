# change function references to use func()

library(xfun)
library(stringr)

files <- list.files(here::here(), pattern = "\\d.*.qmd")

find <- r"(`(.*\\(\\)`))"

replace <- r'(`r func("\1")`)'


test <- "The functions `lm()` and `car::vif()` are good test cases"

gsub(find, replace, test, perl = TRUE)

cat(gsub("`([^`]*\\(\\))`", "`r func(\"\\1\")`", test, perl=TRUE))

str_match(test, find)

f <- r"(`.*`)"
str_match(test, f)

#gsub_file(files[4], find, replace, perl=TRUE)
#
gsub_file(files[4], "`([^`]*\\(\\))`", "`r func(\"\\1\")`", perl=TRUE)

