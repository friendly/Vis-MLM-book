#' ---
#' title: Reconstructing an image using PCA
#' ---
#' 
# Adapted from: https://kieranhealy.org/blog/archives/2019/10/27/reconstructing-images-using-pca/

library(imager)
library(here)
library(dplyr)
library(purrr)
library(broom)
library(ggplot2)
library(gganimate)

img <- imager::load.image(here("images", "MonaLisa.jpg"))
dim(img)

#[1] 640 954   1   3

img <- imager::load.image(here("images", "MonaLisa-BW.jpg"))
dim(img)

#[1] 640 954   1   1

img_df_long <- as.data.frame(img)
head(img_df_long)

img_df <- tidyr::pivot_wider(img_df_long, 
                             names_from = y, 
                             values_from = value)
dim(img_df)

img_pca <- img_df %>%
  dplyr::select(-x) %>%
  prcomp(scale = TRUE, center = TRUE)
  
pca_tidy <- tidy(img_pca, matrix = "pcs")

pca_tidy %>%
    ggplot(aes(x = PC, y = percent)) +
    geom_line(linewidth = 2) +
    labs(x = "Principal Component", y = "Variance Explained") 

reverse_pca <- function(n_comp = 20, pca_object = img_pca){
  ## The pca_object is an object created by base R's prcomp() function.
  
  ## Multiply the matrix of rotated data by the transpose of the matrix 
  ## of eigenvalues (i.e. the component loadings) to get back to a 
  ## matrix of original data values

  recon <- pca_object$x[, 1:n_comp] %*% t(pca_object$rotation[, 1:n_comp])
  
  ## Reverse any scaling and centering that was done by prcomp()
  
  if(all(pca_object$scale != FALSE)){
    ## Rescale by the reciprocal of the scaling factor, i.e. back to
    ## original range.
    recon <- scale(recon, center = FALSE, scale = 1/pca_object$scale)
  }
  if(all(pca_object$center != FALSE)){
    ## Remove any mean centering by adding the subtracted mean back in
    recon <- scale(recon, scale = FALSE, center = -1 * pca_object$center)
  }
  
  ## Make it a data frame that we can easily pivot to long format
  ## (because that's the format that the excellent imager library wants
  ## when drawing image plots with ggplot)
  recon_df <- data.frame(cbind(1:nrow(recon), recon))
  colnames(recon_df) <- c("x", 1:(ncol(recon_df)-1))

  ## Return the data to long form 
  recon_df_long <- recon_df %>%
    tidyr::pivot_longer(cols = -x, 
                        names_to = "y", 
                        values_to = "value") %>%
    mutate(y = as.numeric(y)) %>%
    arrange(y) %>%
    as.data.frame()
  
  recon_df_long
}

# Let?s put the function to work by mapping it to our PCA object, and reconstructing our image based on the first 2, 3, 4, 5, 10, 20, 50, and 100 principal components.


## The sequence of PCA components we want
n_pcs <- c(2:5, 10, 15, 20, 50, 100)
names(n_pcs) <- paste("First", n_pcs, "Components", sep = "_")

## map reverse_pca() 
recovered_imgs <- map_dfr(n_pcs, 
                          reverse_pca, 
                          .id = "pcs") %>%
  mutate(pcs = stringr::str_replace_all(pcs, "_", " "), 
         pcs = factor(pcs, levels = unique(pcs), ordered = TRUE))

p <- ggplot(data = recovered_imgs, 
            mapping = aes(x = x, y = y, fill = value))
p_out <- p + geom_raster() + 
  scale_y_reverse() + 
  scale_fill_gradient(low = "black", high = "white") +
  facet_wrap(~ pcs, ncol = 3) + 
  guides(fill = "none") + 
  labs(title = "Recovering Mona Lisa from PCA of her pixels") + 
  theme(strip.text = element_text(face = "bold", size = rel(1.2)),
        plot.title = element_text(size = rel(1.5)))

p_out

dev.size(units = "px")
#[1] 631 913

# this doesn't work
ggsave("mona-pca.png", width = 640, height = 950, unit = "px")

# Do this as an animation

p_anim <- p + geom_raster() + 
  scale_y_reverse() + 
  scale_fill_gradient(low = "black", high = "white") +
#  facet_wrap(~ pcs, ncol = 2) + 
  transition_states(pcs, transition_length = 3, state_length = 1)
  guides(fill = "none") + 
  labs(title = "Recovering Mona Lisa from PCA of her pixels") + 
  theme(strip.text = element_text(face = "bold", size = rel(1.2)),
        plot.title = element_text(size = rel(1.5)))

p_anim
#Error: cannot allocate vector of size 55.9 Mb
anim_save("mona-pca.gif", p_anim,
    start_pause = 3, end_pause = 3) 
     