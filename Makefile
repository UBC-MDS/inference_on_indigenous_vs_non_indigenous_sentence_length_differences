# 
# Mukund Iyer & Kyle Ahn, Dec 2021

# This is a driver script that completes the inferential study on the 
# difference in median sentence length of indigenous vs non-indigenous inmates. 
# This script will take no input arguments. It two calls, 'clear' to clear
# the directory, and 'all' to run the whole analysis from top to bottom.

# example usage: 
# make all

all: src/eda_offender_profile_raw_data.pdf doc/sentence_length_diffs_inference_report.html

#download the data 
data/raw/offender_profile.csv: src/download_data.py
	python src/download_data.py --url="http://www.csc-scc.gc.ca/005/opendata-donneesouvertes/Open%20Data%20File%2020170409%20v3%20(English).csv" --file_path="./data/raw/offender_profile.csv"

# run eda report and save it as PDF in src folder
src/eda_offender_profile_raw_data.pdf:
	jupyter nbconvert --to pdf --execute "src/eda_offender_profile_raw_data.ipynb"
    
# run clean_offender_profile_raw_data.r to clean and process the data for EDA and hypothesis testing
data/processed/processed_offender_profile.csv: data/raw/offender_profile.csv src/clean_offender_profile_raw_data.r
	Rscript src/clean_offender_profile_raw_data.r --raw_data_path="./data/raw/offender_profile.csv" --processed_dir_path="./data/processed"

# run eda on cleaned and processed data
results/eda-densities.png results/eda-box_plots.png results/basic_summary_table.csv results/group_counts.csv dataset_info.csv: data/processed/processed_offender_profile.csv src/eda_processed_data.py
	python src/eda_processed_data.py --processed_data_path="./data/processed/processed_offender_profile.csv" --results_folder_path="./results"
  
# run hypothesis test and produce output in the results folder
results/ci_95.rds results/diff_medians.rds results/null_distribution.rds results/p_value.rds: data/processed/processed_offender_profile.csv src/hypothesis_test.r
	Rscript src/hypothesis_test.r --processed_data_path="./data/processed/processed_offender_profile.csv" --results_dir_path="./results"

# run to generate sentence_length_diffs_inference_report html and md to view
doc/sentence_length_diffs_inference_report.html: results/ci_95.rds results/diff_medians.rds results/null_distribution.rds results/p_value.rds results/eda-densities.png results/eda-box_plots.png results/basic_summary_table.csv results/group_counts.csv dataset_info.csv
	Rscript -e "rmarkdown::render('./doc/sentence_length_diffs_inference_report.rmd')"

#clean all the intermediate files in data, doc, and results folder.
clean:
	rm -f data/raw/*.csv
	rm -f data/processed/*.csv
	rm -f results/*.png
	rm -f results/*.rds
	rm -f results/*.csv
	rm -f doc/sentence_length_diffs_inference_report.html