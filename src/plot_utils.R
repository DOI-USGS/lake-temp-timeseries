theme_lakes <- function(font_fam = "Source Sans Pro"){
  
  font_add_google(font_fam, regular.wt = 300, bold.wt = 700) # Monda, Almarai
  showtext_auto()
  
  theme_minimal(base_size = 14) +
  theme(
    legend.position = c(0.15, 0.1),
    #legend.position = "top",
    axis.text = element_text(face = "italic", size = 8),
    legend.text = element_text(size = 12, family = font_fam),
    plot.background = element_rect(fill = "white", color = NA),
    plot.title = element_text(face="bold", size = 32, family = font_fam),
    plot.subtitle = element_text(size = 20, family = font_fam)
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
      barwidth = 14, 
      barheight =  0.8,
      label.position = "bottom",
      title.position = "top",
      title.theme = element_text(family = "Source Sans Pro", 
                                 #face = "bold", 
                                 size = 20, 
                                 lineheight = 0.7
      )
    ))
  
  dpi <- 90
  ggsave(file_out, width = 10*dpi, height = 7.15*dpi, units = 'px', dpi = dpi)
}
resize_frames <- function(frames, scale_width, scale_percent = NULL, dir_out) {
  
  if(!dir.exists(dir_out)) dir.create(dir_out)
  
  frames_in <- frames %>%
    image_read() %>%
    image_join()
  info <- image_info(frames_in)
  
  # scale png frames proportionally 
  # either based on a percentage of current size or width
  if(!is.null(scale_percent)){
    scale_width <- info$width*(scale_percent/100)
  }
  
  frames_scaled <- frames_in %>%
    image_scale(scale_width) 
  
  png_names <-  sprintf('%s/%s', dir_out, gsub('out/', '', frames)) 
  map2(as.list(frames_scaled), png_names, ~image_write(.x, .y))
  
  return(png_names)

}
animate_frames_gif <- function(frames, out_file, reduce = TRUE, frame_delay_cs, frame_rate){
  frames %>%
    image_read() %>%
    image_join() %>%
    image_animate(
      delay = frame_delay_cs,
      optimize = TRUE,
      fps = frame_rate
    ) %>%
    image_write(out_file)
  
  if(reduce == TRUE){
    optimize_gif(out_file, frame_delay_cs)
  }
  
  return(out_file)
  
}
optimize_gif <- function(out_file, frame_delay_cs) {

  # simplify the gif with gifsicle - cuts size by about 2/3
  gifsicle_command <- sprintf('gifsicle -b -O3 -d %s --colors 256 %s',
                              frame_delay_cs, out_file)
  system(gifsicle_command)
  
  return(out_file)
}