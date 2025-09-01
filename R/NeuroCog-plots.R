#' ---
#' title: NeuroCog data- plots
#' ---

library(heplots)
library(car)
library(tidyr)
library(dplyr)
# library(broom)
# library(broom.helpers)
# library(purrr)
library(ggplot2)
library(corrgram)
library(ggbiplot)


data(NeuroCog, package="heplots")
str(NeuroCog)

#' Reshape from wide to long for boxplots
NC_long <- NeuroCog |>
  dplyr::select(-SocialCog, -Age, -Sex) |>
  tidyr::gather(key = response, value = "value", Speed:ProbSolv)

NC_long |>
  group_by(Dx) |>
  sample_n(4) |> ungroup()

#' Boxplots for each variable
ggplot(NC_long, aes(x=Dx, y=value, fill=Dx)) +
  geom_jitter(shape=16, alpha=0.8, size=1, width=0.2) +
  geom_violin(alpha = 0.1) +
  geom_boxplot(width=0.5, alpha=0.4, 
               outlier.alpha=1, outlier.size = 3, outlier.color = "red") +
  scale_x_discrete(labels = c("Schizo", "SchizAff", "Control")) +
  facet_wrap(~response, scales = "free_y", as.table = FALSE) +
  theme_bw() +
  theme(legend.position="bottom",
        axis.title = element_text(size = rel(1.2)),
        axis.text  = element_text(face = "bold"),
        strip.text = element_text(size = rel(1.2)))


#' scatmat
col <- c("red", "darkgreen", "blue")
scatterplotMatrix(~ Speed + Attention + Memory + Verbal + Visual + ProbSolv | Dx,
                  data=NeuroCog,
                  plot.points = FALSE,
                  smooth = FALSE,
                  legend = FALSE,
                  col = col,
                  ellipse=list(levels=0.68))


#' corrgram
NeuroCog |>
  select(-Dx) |>
  corrgram(order = TRUE,
           diag.panel = panel.density,
           upper.panel = panel.pie)


#' biplot


neuro.pca <- NeuroCog |>
  select(Speed:Visual) |> 
  prcomp(scale. = TRUE)
summary(neuro.pca)

ggbiplot(neuro.pca, 
         obs.scale = 1, var.scale = 1,
         groups = NeuroCog$Dx, 
         varname.size = 5,
         var.factor = 1.5,
         ellipse = TRUE) +
  scale_color_discrete(name = 'groups') +
  theme_minimal() +
  theme(legend.direction = 'horizontal', legend.position = 'top')

