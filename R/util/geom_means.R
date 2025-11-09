# geom_means()
# from: https://evamaerey.github.io/easy-geom-recipes/recipe1means.html

# Define compute.
compute_group_means <- function(data, ...){ 
  data |> 
    summarize(x = mean(x),
              y = mean(y))
}

StatMeans <- 
  ggplot2::ggproto(`_class` = "StatMeans",
                   `_inherit` = ggplot2::Stat,
                   compute_group = compute_group_means,
                   required_aes = c("x", "y"))

# user-facing function
stat_means <- function(mapping = NULL, data = NULL, 
                         geom = "point", position = "identity", 
                         ..., show.legend = NA, inherit.aes = TRUE) 
{
    layer(data = data, 
          mapping = mapping, 
          stat = StatMeans, 
          geom = geom, 
          position = position, 
          show.legend = show.legend, 
          inherit.aes = inherit.aes, 
          params = rlang::list2(na.rm = FALSE, ...))
}

# Can also use it as a `geom_means`
geom_means <- stat_means

# Test

if(FALSE){
library(tidyverse)
data(penguins, package = "datasets")
penguins_clean <- ggplot2::remove_missing(penguins) 
glimpse(penguins_clean)

penguins_clean |> 
  ggplot() + 
    aes(x = bill_dep,
        y = bill_len) + 
    geom_point() + 
    geom_point(stat = StatMeans, size = 7) + 
    labs(title = "Testing StatMeans")

penguins_clean |> 
  ggplot() + 
    aes(x = bill_dep,
        y = bill_len) + 
    geom_point() + 
    geom_means(size = 8, color = "red") +
    labs(title = "Testing geom_means")

# Test Stat group-wise behavior
last_plot() + 
  aes(color = species)

## Test user-facing.
penguins_clean |>
  ggplot() +
  aes(x = bill_dep, y = bill_len) +
  geom_point() +
  geom_means(size = 8, shape = "+")  + 
  labs(title = "Testing geom_means()")

# Test group-wise behavior
last_plot() + 
  aes(color = species) 

# Test geom flexibility of stat_*() function.

last_plot() + 
  stat_means(geom = "label", aes(label = species))  + 
  labs(subtitle = "and stat_means()")
}
