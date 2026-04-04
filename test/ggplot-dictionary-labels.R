# using dictionary labels in ggplot 4.0.0
#see https://tidyverse.org/blog/2025/09/ggplot2-4-0-0/#labels


library(ggplot2)
# pretty slick
l <- c(mpg = "Miles per gallon", 
       wt = "Weight (1,000 lbs)", `
       mpg/2` = "yes this works")
ggplot(mtcars, aes(mpg, wt)) + labs(dictionary = l)
ggplot(mtcars, aes(wt, mpg)) + labs(dictionary = l)
ggplot(mtcars, aes(wt, mpg/2)) + labs(dictionary = l)

# Also

df <- penguins

# Manually set label attributes.
# Other packages may offer better tooling than this.
attr(df$species, "label") <- "Penguin Species"
attr(df$bill_dep, "label") <- "Bill depth (mm)"
attr(df$bill_len, "label") <- "Bill length (mm)"
attr(df$body_mass, "label") <- "Body mass (g)"

ggplot(df, aes(bill_dep, bill_len, colour = sqrt(body_mass))) +
  geom_point(na.rm = TRUE)

dict <- tibble::tribble(
  ~var,    ~label,
  "species",  "Penguin Species",
  "bill_dep", "Bill depth (mm)",
  "bill_len", "Bill length (mm)",
  "body_mass", "Body mass (g)"
)

ggplot(penguins, aes(bill_dep, bill_len, colour = body_mass)) +
  geom_point(na.rm = TRUE) +
  # Or:
  # labs(dictionary = dplyr::pull(dict, label, name = var))
  labs(dictionary = setNames(dict$label, dict$var))


