#' ---
#' title: Rohwer plots
#' ---

data(Rohwer, package = "heplots")
# Make SES == 'Lo' the reference category
Rohwer$SES <- relevel(Rohwer$SES, ref = "Lo")

library(dplyr)
library(ggplot2)

yvars <- c("SAT", "PPVT", "Raven" )      # outcome variables
xvars <- c("n", "s", "ns", "na", "ss")   # predictors
#xvars <- c("n", "s", "ns")               # make a smaller example

Rohwer_long <- Rohwer %>%
  dplyr::select(-group) |>
  tidyr::pivot_longer(cols = all_of(xvars), 
                      names_to = "xvar", values_to = "x") |>
  tidyr::pivot_longer(cols = all_of(yvars), 
                      names_to = "yvar", values_to = "y") |>
  dplyr::mutate(xvar = factor(xvar, levels = xvars),
                yvar = factor(yvar, levels = yvars))
Rohwer_long

ggplot(Rohwer_long, aes(x, y, color = SES, shape = SES, fill = SES)) +
  geom_jitter(size=0.8) +
  geom_smooth(method = "lm", 
              se = FALSE, 
              formula = y ~ x, 
              linewidth = 1.5) +
  stat_ellipse(geom = "polygon", alpha = 0.1) +
  labs(x = "Predictor (PA task)",
       y = "Response (Academic)") +
  facet_grid(yvar ~ xvar,            # plot matrix of Y by X
             scales = "free") +
  theme_bw(base_size = 16) +
  theme(legend.position = "bottom")
