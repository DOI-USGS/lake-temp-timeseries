# lake-temp-timeseries
A gif of surface temperatures for 185,549 lakes. For this pipeline to work you must download all files from https://doi.org/10.5066/P9CEMS0M and place in a subdirectory, `in/`. 


## Build the gif
This gif is created using a pipeline with the `targets` library for R. To run the pipeline run `tar_make()` in the console. The final gif is created using system calls to [`magick`](https://imagemagick.org/index.php) and [`gifsicle`](https://www.lcdf.org/gifsicle/), and will require that they are installed on your computer to work.