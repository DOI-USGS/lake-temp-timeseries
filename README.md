# lake-temp-timeseries
A gif of surface temperatures for 185,549 lakes using data from [Willard et al. 2022](https://aslopubs.onlinelibrary.wiley.com/doi/10.1002/lol2.10249). The [data are sourced from ScienceBase](https://doi.org/10.5066/P9CEMS0M) using the [`sbtools`](https://github.com/USGS-R/sbtools) package for R, and placed in a subdirectory, `in/`. 


## Build the gif
This gif is created using a pipeline with the `targets` library for R. It takes approximately 3 hours to build the gif. 

To run the pipeline run `tar_make()` in the console. The final gif is created using the [`magick package`](https://github.com/ropensci/magick) and a system call to [`gifsicle`](https://www.lcdf.org/gifsicle/) to reduce the file size. You will need to install [`gifsicle`](https://www.lcdf.org/gifsicle/) on your computer to produce the final gif. If you would like to skip the final optimization step via `gifsicle`, modify the `lake_temp_2020_gif` target call to `reduce = FALSE`.


