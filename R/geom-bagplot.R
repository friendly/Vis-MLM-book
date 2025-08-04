# test gggda::geom_bagplot

library(gggda)
source(here::here("R", "penguin", "penguin-colors.R"))


p <- mtcars %>% 
  transform(cyl = factor(cyl)) %>% 
  ggplot(aes(x = wt, y = disp)) +
  geom_point() +
  theme_bw()
# basic bagplot
p + geom_bagplot()

p + geom_bagplot(
#  fraction = 0.4, coef = 1.2,
  bag.alpha = 0.5,
  aes(fill = cyl, linetype = cyl, color = cyl))

data(peng, package = "heplots")

ggplot(peng, 
       aes(x = bill_length, y = bill_depth,
           color = species, shape = species, fill=species)) +
  geom_smooth(method = "lm", formula = y ~ x,
              se=FALSE, linewidth=2) +
  geom_bagplot(bag.alpha = 0.5,
               outlier.size = 5,
               fraction = 0.5,    # bag fraction
               coef = 2.5,        # fence factor
               show.legend = FALSE) +
  theme_penguins("dark") +
  theme_bw(base_size = 14) +
  theme(legend.position = "inside",
        legend.position.inside = c(0.87, 0.15)) 


# Try to get row IDs of the 'outliers'
peng |>
  select(bill_length, bill_depth) |>
  peel_hulls(num = Inf) |>
    as.data.frame() |>
  merge(
    transform(peng, i = seq(nrow(peng))),
    by = "i"
  ) |> 
  subset(select = -c(x, y, prop)) |>
  sort_by(~ hull + i) -> peng_hulls

peng_hulls |>
  filter(hull == max(hull))

# use ddalpha:: depth to find largest depths
peng |>
  select(bill_length, bill_depth) -> peng.sub
peng.depth  <- 
  data.frame(
    ID = seq(nrow(peng)),
    depth = ddalpha::depth.(x = peng.sub, data=peng.sub)) 
peng.depth |>
  arrange(desc(depth)) |> head()

  


# From Cory Brunsten, gggda
# USJudgeRatings %>%
#   subset(select = c(INTG, DECI)) ->
#   judge_legit
# ddalpha::depth.(x = judge_legit, data = judge_legit)
# 
#   
# judge_ratings %>% 
#   subset(select = c(INTG, DECI)) %>% 
#   peel_hulls(num = Inf) %>% 
#   as.data.frame() %>% 
#   merge(
#     transform(judge_ratings, i = seq(nrow(judge_ratings))),
#     by = "i"
#   ) %>% 
#   subset(select = -c(i, x, y, prop)) %>% 
#   sort_by(~ hull + NAME) ->
#   judge_hulls
# judge_hulls %>% 
#   subset(subset = hull %in% range(hull))

