library(palmerpenguins)
library(dplyr)

# clean up variable names, etc.

peng <- penguins |>
  rename(
    bill_length = bill_length_mm, 
    bill_depth = bill_depth_mm, 
    flipper_length = flipper_length_mm, 
    body_mass = body_mass_g
  ) |>
  mutate(species = as.factor(species),
         island = as.factor(island),
         sex = as.factor(substr(sex,1,1))) |>
  tidyr::drop_na()

str(peng)

save(peng, file = here::here("data", "peng.RData"))
