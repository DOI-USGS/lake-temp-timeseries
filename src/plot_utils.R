theme_lakes <- function(font_fam = "Source Sans Pro"){
  
  font_add_google(font_fam, regular.wt = 300, bold.wt = 700) # Monda, Almarai
  showtext_auto()
  
  theme_minimal(base_size = 18) +
  theme(
    legend.position = c(0.15, 0.1),
    #legend.position = "top",
    axis.text = element_text(face = "italic", size = 12),
    legend.text = element_text(size = 20, family = font_fam),
    plot.background = element_rect(fill = "white", color = NA),
    plot.title = element_text(face="bold", size = 50, family = font_fam),
    plot.subtitle = element_text(size = 40, family = font_fam)
  ) 
}
get_usa <- function(proj){
  usa <- maps::map("usa", plot=FALSE, boundary = TRUE) %>% 
    st_as_sf() %>%
    st_transform(proj) %>%
    rmapshaper::ms_simplify()
}
plot_lake_temp <- function(temp_data, time, usa_sf, file_out, pal){

  ggplot() +
    geom_sf(data = usa_sf,
            fill = "white",
            color = "grey" 
            ) +
    geom_sf(data = temp_data, 
            size = 0.2, 
            aes(color = surftemp)
            ) + 
    scale_color_viridis_c(
      option = pal,
      limits = c(0, 35),
      "Degrees (C)"
      ) +
    theme_lakes()  +
    coord_sf(label_axes = list(bottom = "E", right = "N")) +
    ggtitle("Surface temperatures for 185,549 lakes",
            subtitle = sprintf("%s", time)) +
    guides(color = guide_colorbar(
      direction = "horizontal",
      barwidth = 20, 
      barheight =  0.8,
      label.position = "bottom",
      title.position = "top",
      title.theme = element_text(family = "Source Sans Pro", 
                                 #face = "bold", 
                                 size = 30, 
                                 lineheight = 0.7
      )
    ))
  
  dpi <- 100
  ggsave(file_out, width = 14*dpi, height = 10*dpi, units = 'px', dpi = dpi)
}

combine_animation_frames_gif <- function(out_file, frame_delay_cs, frame_rate) {
  # modified from https://github.com/USGS-VIZLAB/gage-conditions-gif/blob/main/6_visualize/src/combine_animation_frames.R
  
  #build gif from pngs with magick and simplify with gifsicle
  #note that this will use all frames in tmp
  png_files <- list.files('tmp', pattern = "*.png", full.names = TRUE)
  tmp_dir <- 'tmp/magick'
  if(!dir.exists(tmp_dir)) dir.create(tmp_dir)
  
  # Resize to more reasonable resolutions for a gif
  file.copy(from = png_files, to = tmp_dir)
  moved_pngs <- gsub('tmp', tmp_dir, png_files)
  lapply(moved_pngs, function(fn) {
    system(sprintf('magick convert %s -resize 800x572 %s', fn, fn))
  })
  
  png_str <- paste(moved_pngs, collapse=' ')
  # create gif using magick
  magick_command <- sprintf(
    'convert -define registry:temporary-path=%s -limit memory 24GiB -delay %d -loop 0 %s %s',
    tmp_dir, frame_delay_cs, png_str, out_file)
  if(Sys.info()[['sysname']] == "Windows") {
    magick_command <- sprintf('magick %s', magick_command)
  }
  system(magick_command)
  
  # simplify the gif with gifsicle - cuts size by about 2/3
  gifsicle_command <- sprintf('gifsicle -b -O3 -d %s --colors 256 %s',
                              frame_delay_cs, out_file)
  system(gifsicle_command)
}