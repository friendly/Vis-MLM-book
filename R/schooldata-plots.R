library(car)
library(corrgram)
library(tidyr)
library(dplyr)
library(ggplot2)
library(ggrepel)
# library(heplots)
# library(candisc)

data(schooldata, package = "heplots")

# initial screening
scatterplotMatrix(schooldata)

corrgram(schooldata, 
         upper.panel=panel.ellipse, 
         lower.panel=panel.pts)

# multivariate outliers
res <- cqplot(schooldata, id.n = 5)
res
outliers <- rownames(res) |> as.numeric()

# plot predictors vs each response
xvars <- names(schooldata)[1:5]
yvars <- names(schooldata)[6:8]

school_long <- schooldata |>
  tibble::rownames_to_column(var = "site") |>
  pivot_longer(cols = all_of(xvars), names_to = "xvar", values_to = "x") |>
  pivot_longer(cols = all_of(yvars), names_to = "yvar", values_to = "y") |>
  mutate(xvar = factor(xvar, xvars), yvar = factor(yvar, yvars))

# make plots
# How to do this with noteworthy?
p1 <- ggplot(school_long, aes(x, y)) +
  geom_point() +
  geom_smooth(method = "lm", se = FALSE, formula = y ~ x) +
  stat_ellipse(geom = "polygon", 
               level = 0.95, fill = "blue", alpha = 0.2) +
  facet_grid(yvar ~ xvar, scales = "free") +
  labs(x = "predictor", y = "response") +
  theme_bw(base_size = 16)

#p1 + facet_grid(xvar ~ yvar, scales = "free")

p1 + geom_text_repel(data = school_long |> filter(site %in% outliers[1:3]), 
                     aes(label = site))

