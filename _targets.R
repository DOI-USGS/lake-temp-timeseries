library(targets)
library(sbtools)
library(tidyverse)
library(ncdf4)
library(sf)
library(lubridate)
library(maps)
library(showtext)
library(magick)

options(tidyverse.quiet = TRUE)

source("src/data_utils.R")
source("src/plot_utils.R")

day_start <- '01-01'
day_end <- '12-31'
year_start <- '2020'
year_end <- '2020'
proj <- '+proj=lcc +lat_1=30.7 +lat_2=29.3 +lat_0=28.5 +lon_0=-91.33333333333333 +x_0=999999.9999898402 +y_0=0 +ellps=GRS80 +datum=NAD83 +to_meter=0.3048006096012192 +no_defs'

list(
  tar_target(
    lake_files, # download files from https://doi.org/10.5066/P9CEMS0M 
    download_sb_files(sb_id = "60341c3ed34eb12031172aa6", 
                      file_string = "predicted_temp", 
                      dest_folder = "in"),
    format = "file"
  ),
  tar_target(
    date_list, 
    tibble(date = seq.Date(
      as.Date(sprintf('%s-%s', year_start, day_start)), 
      as.Date(sprintf('%s-%s', year_end, day_end)), by = "days"),
      order = seq(1, length(date)))
  ),
  tar_target(
    temp_data, # pulls all data at once, may want to split if > 1 yr
    get_temp_data(date_list$date, lake_files)
  ),
  tar_target(
    temp_daily, # split data by date
    get_daily_temps(temp_data, date_list, proj),
    pattern = map(date_list)
  ),
  tar_target(
    usa_sf, 
    get_usa(proj)
  ),
  tar_target(
    lake_temp_pngs, # create frames
    plot_lake_temp(temp_daily, 
                   time = date_list$date,
                   usa_sf,
                   file_out = sprintf('out/lake_temp_%s.png', date_list$order),
                   pal = "mako"),
    pattern = map(temp_daily, date_list),
    format = "file"
  ),
  tar_target(
    lake_temp_2020_gif, # animate frames
    combine_animation_frames_gif(
      out_file = 'out/lake_temp_2020.gif',
      frame_delay_cs = 14, 
      frame_rate = 60
    ),
    format = "file"
  )
)
