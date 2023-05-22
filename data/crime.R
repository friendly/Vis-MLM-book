library(tidyverse)

crime <- read_csv(here::here("data", "crime.csv"))

crime <- crime |>
  bind_cols(region = state.region) 

write_csv(crime, here::here("data", "crime.RData"))

