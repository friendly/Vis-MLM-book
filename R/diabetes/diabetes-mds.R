
library(MASS)
library(ggpubr)
library(dplyr)

data(Diabetes, package="heplots")

mds <- Diabetes |>
  dplyr::select(where(is.numeric)) |>
  dist() |>          
  isoMDS() |>
  purrr::pluck("points") 

colnames(mds) <- c("Dim1", "Dim2")
mds <- bind_cols(mds, group = Diabetes$group)

# Plot MDS
mplot <-
ggscatter(mds, x = "Dim1", y = "Dim2", 
          color = "group",
          shape = "group",
          size = 2,
          ellipse = TRUE,
          ellipse.type = "t") +
  geom_hline(yintercept = 0, color = "gray") +
  geom_vline(xintercept = 0, color = "gray") 
  


# project variables into this space

# mds_data <- cbind(scale(Diabetes[, 1:5]),
#                   mds)
# var.mod <- lm(cbind(relwt, glufast, glutest, instest, sspg) ~ 0 + Dim1 + Dim2, data=mds_data)
# #car::Anova(var.mod)
# t(coef(var.mod))

vectors <- cor(Diabetes[, 1:5], mds[, 1:2])
scale_fac <- 500
mplot +
  geom_segment(data=vectors,
               aes(x=0, xend=scale_fac*Dim1, y=0, yend=scale_fac*Dim2),
               arrow = arrow(length = unit(0.2, "cm"), type = "closed"),
               linewidth = 1.1) +
  geom_text(data = vectors,
            aes(x = 1.05*scale_fac*Dim1, y = 1.05*scale_fac*Dim2, label=row.names(vectors)),
            size = 4)

  