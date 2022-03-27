download_sb_files <- function(sb_id, file_string, dest_folder) {
  
  sb_filenames <- item_list_files(sb_id)
  sb_files <- sb_filenames %>% filter(str_detect(fname, file_string))
  local_files <- file.path(dest_folder, sb_files$fname)
  
  if(any(!file.exists(local_files))){
    item_file_download(
      sb_id, 
      names = sb_files$fname, 
      destinations = local_files,
      overwrite_file = FALSE)
  }
  
  return(local_files)
  
}
get_temp_data <- function(date_list, lake_files){
  
  # predicted temp for all lakes at once
  temp_data <- purrr::map(lake_files, function(lake_file){
    nc <- nc_open(lake_file)
    
    time_origin <- ncdf4::ncatt_get(nc, 'time', attname = 'units')$value %>% 
      str_remove("days since ")
    time <- ncvar_get(nc, 'time') + as.Date(time_origin)
    time_idx <- which(time %in% date_list)
    
    lake_lat <- ncvar_get(nc, 'lat')
    lake_lon <- ncvar_get(nc, 'lon')
    lake_id <- ncvar_get(nc, 'site_id')
    
    lake_data <- ncvar_get(nc, 'surftemp', 
                           start = c(first(time_idx), 1), 
                           count = c(last(time_idx) - first(time_idx) + 1, -1))
 
    tibble(
      site_id = lake_id,
      lat = lake_lat,
      lon = lake_lon,
      temp = t(lake_data)
    ) 
    
  }) %>% bind_rows()
}
get_daily_temps <- function(temp_data, date_list, proj){
 
  tibble(date = date_list$date, 
         temp_data %>% select(site_id, lat, lon),
         surftemp = temp_data$temp[,date_list$order]
  ) %>% 
    st_as_sf(coords = c("lon", "lat"), crs = 4326) %>% 
    st_transform(proj) 
    
}