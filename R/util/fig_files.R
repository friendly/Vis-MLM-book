# process figure files
# 
library(fs)
library(dplyr)
library(lubridate)
library(stringr)

figs <- dir_ls("figs", recurse = TRUE, type = "file")
str(figs)

head(figs)

path <- path_dir(figs)
chap <- sub("figs/", "", path)
file <- path_file(figs)
ext <- path_ext(figs)
size <- file_size(figs)
dup <- duplicated(file, fromLast = TRUE)
time <- file_info(figs)[, "change_time"]


fig_df <- data.frame(chap, file, ext, size, dup, time)
rownames(fig_df) <- NULL
str(fig_df)
head(fig_df)

table(dup)
View(fig_df)

fig_dup <- fig_df |> 
  filter(dup == TRUE) 


