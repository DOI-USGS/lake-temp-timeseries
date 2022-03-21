get_daily_temp <- function(date, lake_files){
  
  # predicted temp for all lakes at once
  plot_data <- purrr::map(lake_files, function(lake_file){
    nc <- nc_open(lake_file)
    
    time_origin <- ncdf4::ncatt_get(nc, 'time', attname = 'units')$value %>% str_remove("days since ")
    time <- ncvar_get(nc, 'time') + as.Date(time_origin)
    time_idx <- which(time == date)
  
    all_surftemp <- ncvar_get(nc, 'surftemp', start = c(time_idx, 1), count = c(1, -1))
    lake_lat <-  ncvar_get(nc, 'lat')
    lake_lon <-  ncvar_get(nc, 'lon')
    lake_id <-  ncvar_get(nc, 'site_id')
    nc_close(nc)
    tibble(surftemp = all_surftemp, lat = lake_lat, lon = lake_lon, site_id = lake_id)
  }) %>% bind_rows() %>% 
    st_as_sf(coords = c("lon", "lat"), crs = 4326) %>% 
    st_transform(proj)  
}
