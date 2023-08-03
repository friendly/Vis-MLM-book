---
#'  title: prestige data, plots using ggplots
---

library("car") 
data(Prestige)
# make an ordered factor
Prestige$type <- factor(Prestige$type, levels=c("bc", "wc", "prof")) # reorder levels
head(Prestige)

library(ggplot2)
library(here)

#' Try the same as car::scatterplot
#' 
ggplot(data=Prestige, 
       aes(x = income, y = prestige)) +
  geom_point(size=2) +
  geom_smooth(method = "lm", color = "red", se=FALSE, size=2) +
  geom_smooth(method = "loess", color = "blue", size = 2, fill="blue", alpha=0.1) +
  stat_ellipse(geom = "polygon", alpha = 0.2, color = "green3") +
  geom_text(aes(label=ifelse(income>18000,
                             as.character(row.names(Prestige)),'')), 
            hjust=1, vjust=0) +
  theme_bw(base_size = 18)

# someting wrong here
ggsave(here("fig/prestige/prestige-scat-ggplot.png"), height=530, width=670, units = "px")

#' Stratify by type
ggplot(data=subset(Prestige, !is.na(type)), 
       aes(x = income, y = prestige, color = type, shape=type)) +
  geom_point(size=2) +
  geom_smooth(method = "lm", se=FALSE, size=2) +
  theme_bw(base_size = 18) +
  theme(legend.position = c(0.87, 0.25))

