# Make a collage from a collection of png/jpg files
# https://stackoverflow.com/questions/62516742/create-multi-panel-figure-using-png-jpeg-images

# read the the png files into a list
  pngfiles <-
  list.files(
    path = here::here("png_ouput_folder"),
    recursive = TRUE,
    pattern = "\\.png$",
    full.names = T
  )
 
 # read images and then create a montage
 # tile =2 , means arrange the images in 2 columns
 # geometry controls the pixel sixe, spacing between each image in the collage output. 

 magick::image_read(pngfiles) %>%
      magick::image_montage(tile = "2", geometry = "x500+10+5") %>%
      magick::image_convert("jpg") %>%
      magick::image_write(
        format = ".jpg", path = here::here(paste(name,"_collage.jpg",sep="")),
        quality = 100
      )
