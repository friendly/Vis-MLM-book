library(tidyverse)

crime <- read_csv(here::here("data", "crime.csv"))

crime <- crime |>
  bind_cols(region = state.region) 

#rownames(crime) <- crime$st
write.csv(crime, here::here("data", "crime2.csv"))

# tibbles don't like rownames
crime <- as.data.frame(crime)
save(crime, file = here::here("data", "crime.RData"))



