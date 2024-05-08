#library(spida2)
library(dplyr)

# data(coffee, package = "spida2")
# 
# coffee <- coffee[, -5]  # get old Stress2 example variable out of the way

# Occupation -> Group, re-assign categories
write.csv(coffee, file = here::here("data", "coffee.csv"), row.names = FALSE)

coffee <- read.csv(here::here("data", "coffee.csv"))
str(coffee)

coffee <- coffee[, -1]

save(coffee, file = here::here("data", "coffee.RData"))

library(car)

scatterplotMatrix(~ Heart + Coffee + Stress, data=coffee,
    smooth = FALSE,
    pch = 16,
    ellipse = list(levels = 0.68))

