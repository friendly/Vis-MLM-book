library(dplyr)
library(partykit)

# data(penguins, package = "palmerpenguins")
# peng <- penguins |>
#   rename(
#     bill_length = bill_length_mm, 
#     bill_depth = bill_depth_mm, 
#     flipper_length = flipper_length_mm, 
#     body_mass = body_mass_g
#   ) |>

data(peng, package = "heplots")

peng |>
  mutate(species = as.factor(species),
         island = as.factor(island),
         sex = as.factor(substr(sex,1,1))) |>
  tidyr::drop_na()
ctree(bill_depth + bill_length ~ ., data = peng) |> plot()
