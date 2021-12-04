"Runs the hypothesis test for the dataset and computes the p-value, test statistic and plots the null-distribution.
Usage: src/hypothesis_test.r --processed_data_path=<processed_data_path> --results_dir_path=<results_path>
  
Options:
--processed_data_path=<processed_data_path>             Path to the processed data including the file name and extension to raw data
--results_dir_path=<results_dir_path>                   Path to where the results should be written.
" -> doc

library(tidyverse)
library(testthat)
library(infer)
library(knitr)
library(docopt)
opt <- docopt(doc)


test_input <- function(data_path) {
  #' tests whether the input file exists
  #'
  #' @param data_path path of the input data file
  #' @export
  #'
  #' @examples
  #' test_input("./data_file.csv")
  expect_true(
    file.exists(data_path),
    paste(data_path, "does not exist.")
  )
}

test_output <- function(dir_path) {
    #' tests whether all expected output files exist
    #' We expect p_value.rds, null_distribution.rds,
    #' ci_95.rds, and diff_medians.rds files.
    #'
    #' @param dir_path directory path where all the output files exist.
    #' @export
    #'
    #' @examples
    #' test_output("./data_folder")
  p_value_file <- paste(dir_path, "/p_value.rds", sep = "")
  expect_true(
    file.exists(p_value_file),
    paste(p_value_file, "does not exist.")
  )

  null_distribution_file <- paste(dir_path, "/null_distribution.rds", sep = "")
  expect_true(
    file.exists(null_distribution_file),
    paste(null_distribution_file, "does not exist.")
  )

  ci_95_file <- paste(dir_path, "/ci_95.rds", sep = "")
  expect_true(
    file.exists(ci_95_file),
    paste(ci_95_file, "does not exist.")
  )

  diff_means_file <- paste(dir_path, "/diff_medians.rds", sep = "")
  expect_true(
    file.exists(diff_means_file),
    paste(diff_means_file, "does not exist.")
  )
}


main <- function(processed_data_path, results_dir_path) {
  test_input(processed_data_path)

  # read data
  processed_offender <- read_csv(processed_data_path)[, 2:3]
  processed_offender <- processed_offender |> 
    mutate(race_grouping = as.factor(race_grouping))

  # get difference in medians as the test statistic
  diff_medians <- processed_offender |> 
    specify(formula = aggregate_sentence_length ~ race_grouping) |> 
    calculate(stat = "diff in medians",
              order = c("Indigenous", "Non Indigenous"))

  # null distribution by permutation test
  set.seed(2021)
  null_distribution <- processed_offender |>
    specify(formula = aggregate_sentence_length ~ race_grouping) |>
    hypothesize(null = "independence") |>
    generate(reps = 5000, type = "permute") |>
    calculate(stat = "diff in medians", 
              order = c("Indigenous", "Non Indigenous"))

  # 95% confidence interval of the null distribution
  ci_95 <- null_distribution |>
    get_confidence_interval(level = 0.95, type = "percentile")

  # plot of null distribution
  null_distribution_plot <- null_distribution |> 
    visualize() +
    geom_vline(xintercept = diff_medians$stat, color = "red") + 
    shade_confidence_interval(endpoints = ci_95, alpha = 0.2) + 
    labs(
        x = "Difference in medians of indigenous vs. non indigenous offenders",
        y = "Count",
        subtitle = "Red line shows observed difference in medians with 95% CI shaded"
    ) + theme_bw()

  p_value <- null_distribution |>
    get_pvalue(obs_stat = diff_medians, direction = "two_sided")

  saveRDS(p_value, paste(results_dir_path,"/p_value.rds", sep = ""))
  saveRDS(null_distribution_plot, paste(results_dir_path,"/null_distribution.rds", sep = ""))
  saveRDS(ci_95, paste(results_dir_path, "/ci_95.rds", sep = ""))
  saveRDS(diff_medians, paste(results_dir_path, "/diff_medians.rds", sep = ""))
  test_output(results_dir_path)
}

main(opt[["--processed_data_path"]], opt[["--results_dir_path"]])