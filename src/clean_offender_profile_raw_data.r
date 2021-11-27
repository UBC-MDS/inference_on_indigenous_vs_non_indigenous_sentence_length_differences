"Cleans, splits and pre-processes offender profile data from http://www.csc-scc.gc.ca/005/opendata-donneesouvertes/Open%20Data%20File%2020170409%20v3%20(English).csv.
Usage: src/sample_docopt.r --raw_data_path=<raw_data_path> --processed_dir_path=<processed_dir_path>
  
Options:
--raw_data_path=<raw_data_path>             Path to the raw data including the file name and extension to raw data
--processed_dir_path=<processed_dir_path>   Path to where the processed data should be written.
" -> doc

library(tidyverse)
library(docopt)
library(janitor)

set.seed(2020)

opt <- docopt(doc)

main <- function(raw_data_path, processed_dir_path) {
    # read data and convert class to factor
    raw_data <- readr::read_csv(raw_data_path)

    print(raw_data)
    # write scale factor to a file
    try({
        dir.create(processed_dir_path, showWarnings = FALSE)
    })
    
    processed_data <- raw_data |> clean_names() |>
      filter(sentence_type == "DETERMINATE") |>
      select(race_grouping, aggregate_sentence_length)

    z <- paste(processed_dir_path, "/processed_offender_profile.csv", sep = "")
    print(z)
    write.csv(
        processed_data,
        paste(processed_dir_path, "/processed_offender_profile.csv", sep = "")
    )
}

main(opt[["--raw_data_path"]], opt[["--processed_dir_path"]])
