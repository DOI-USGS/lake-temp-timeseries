# lake-temp-timeseries
A gif of surface temperatures for 185,549 lakes using data from [Willard et al. 2022](https://aslopubs.onlinelibrary.wiley.com/doi/10.1002/lol2.10249). The [data are sourced from ScienceBase](https://doi.org/10.5066/P9CEMS0M) using the [`sbtools`](https://github.com/USGS-R/sbtools) package for R, and placed in a subdirectory, `in/`. 


## Build the gif
This gif is created using a pipeline with the `targets` library for R. It takes approximately 3 hours to build the gif. 

To run the pipeline run `tar_make()` in the console. The final gif is created using the [`magick package`](https://github.com/ropensci/magick) and a system call to [`gifsicle`](https://www.lcdf.org/gifsicle/) to reduce the file size. You will need to install [`gifsicle`](https://www.lcdf.org/gifsicle/) on your computer to produce the final gif. If you would like to skip the final optimization step via `gifsicle`, modify the `lake_temp_2020_gif` target call to `reduce = FALSE`.

## Disclaimer

This software is in the public domain because it contains materials that originally came from the U.S. Geological Survey, an agency of the United States Department of Interior. For more information, see the official USGS copyright policy at [http://www.usgs.gov/visual-id/credit_usgs.html#copyright](http://www.usgs.gov/visual-id/credit_usgs.html#copyright)

This information is preliminary or provisional and is subject to revision. It is being provided to meet the need for timely best science. The information has not received final approval by the U.S. Geological Survey (USGS) and is provided on the condition that neither the USGS nor the U.S. Government shall be held liable for any damages resulting from the authorized or unauthorized use of the information. Although this software program has been used by the USGS, no warranty, expressed or implied, is made by the USGS or the U.S. Government as to the accuracy and functioning of the program and related program material nor shall the fact of distribution constitute any such warranty, and no responsibility is assumed by the USGS in connection therewith.

This software is provided "AS IS."


[
  ![CC0](http://i.creativecommons.org/p/zero/1.0/88x31.png)
](http://creativecommons.org/publicdomain/zero/1.0/)
