#' ---
#' title: 1970 Draft Lottery
#' ---
#' 

data(Draft1970, package = "vcdExtra")

library(ggplot2)
library(lubridate)
library(dplyr)

# scatterplot
plot(Rank ~ Day, data=Draft1970)
with(Draft1970, lines(lowess(Day, Rank), col="red", lwd=2))
abline(lm(Rank ~ Day, data=Draft1970), col="blue")

# boxplots
plot(Rank ~ Month, data=Draft1970, col="bisque")

library(tidyverse)
data(Draft1970, package = "vcdExtra")
Draft1970 |> 
  arrange(Rank) |> 
  relocate(Rank) |>
  mutate(mday = lubridate::mday(as.Date(Day, origin="1971-12-31"))) |> 
  mutate(Date = paste(Month, mday, sep=" ")) |> head(8)




# find 15th of each month
#dates <- as.Date(0:365, origin = "1970-01-01")
#mid <- floor_date(ymd(dates), 'month') + days(15) |> unique()

# markers for months
months <- data.frame(
  month =unique(Draft1970$Month),
  mid = seq(15, 365-15, by = 30))

ggplot2:: theme_set(theme_bw(base_size = 16))
gg <- ggplot(Draft1970, aes(x = Day, y = Rank)) +
  geom_point(size = 2.5, shape = 21, 
             alpha = 0.3, 
             color = "black", 
             aes(fill=Month)
             ) +
  scale_fill_manual(values = rainbow(12)) +
  geom_text(data=months, aes(x=mid, y=0, label=month)) +
  geom_smooth(method = "lm", formula = y~1,
              col = "black", fill="grey", alpha=0.6) +
  labs(x = "Day of the year",
       y = "Lottery rank") +
  theme(legend.position = "none") 
gg

gg +  
  # geom_smooth(method = "loess", formula = y~x,
  #             fill="blue", alpha=0.25) +
      geom_smooth(method = "lm", formula = y~x,
                  color="darkgreen", alpha=0.25) 

# start over; make the points uncolored
ggplot(Draft1970, aes(x = Day, y = Rank)) +
  geom_point(size = 2.5, shape = 21, 
             alpha = 0.3, 
             color = "black", 
             fill = "brown") +
  geom_smooth(method = "lm", formula = y~1,
              se = FALSE,
              col = "black", fill="grey", alpha=0.6) +
  geom_smooth(method = "loess", formula = y~x,
              color = "blue", se = FALSE,
              alpha=0.25) +
  geom_smooth(method = "lm", formula = y~x,
              color = "darkgreen",
              fill = "darkgreen", 
              alpha=0.25) +
  labs(x = "Day of the year",
       y = "Lottery rank")

# Spearman's Rho


stats::cor.test(~ Rank + Day, data=Draft1970, method="spearman")$estimate

stats::cor.test(~ Rank + Day, data=Draft1970, method="spearman") |> 
  purrr::pluck("estimate")

draft.mod <- lm(Rank ~ Day, data=Draft1970)
summary(draft.mod)
anova(draft.mod)

# make the table version
Draft1970$Risk <- cut(Draft1970$Rank, breaks=3, labels=c("High", "Med", "Low"))
with(Draft1970, table(Month, Risk))

# plot means

means <- Draft1970 |>
  group_by(Month) |>
  summarize(Day = mean(Day),
            se = sd(Rank/ sqrt(n())),
            Rank = mean(Rank)) 

ggplot(means, aes(x = Day, y = Rank)) +
  geom_point(size = 4) +
  geom_smooth(method = "lm", formula = y~x,
              color = "blue", fill = "blue", alpha = 0.2) +
  geom_errorbar(aes(ymin = Rank-se, ymax = Rank+se), 
                width = 8, linewidth = 1.3) +
  geom_text(data=months, aes(x=mid, y=100, label=month), nudge_x = 5) +
  ylim(100, 250) +
  labs(x = "Average day of the year",
       y = "Average lottery rank")

with(means, cor(Day, Rank))

lm(Rank ~ Day, data=means) |> coef()

# using sample

set.seed(42)
date = seq(as.Date("1971-01-01"), as.Date("1971-12-31"), by="+1 day")
rank = sample(seq_along(date))
draft1971 <- data.frame(date, rank)

head(draft1971, 4)
tail(draft1971, 4)

me <- as.Date("1971-05-07")
draft1971[draft1971$date == me,]



  

