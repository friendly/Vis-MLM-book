# workers data

workers <- read.csv(here::here("data", "workers.csv"))

save(workers, file = here::here("data", "workers.RData"))
