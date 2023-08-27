#library(spida2)

data(coffee, package = "spida2")

coffee <- coffee[, -5]  # get old Stress2 example variable out of the way

save(coffee, file = here::here("data", "coffee.RData"))
