# outlier detection
library(heplots)
data(peng, package="heplots")
source(here::here("R", "penguin", "penguin-colors.R"))

clr <- peng.colors("dark")
pch <- c(19, 17, 15)   # ggplot defaults for a factor

cqplot(peng[, 3:6], 
   id.n = 3,
   col = clr[peng$species],
   pch = pch[peng$species],
   ref.col = "grey",
   what = "Penguin numeric variables") -> out

# extreme cases
cbind(id=rownames(out), 
      peng[rownames(out), c(1,3:6)])


