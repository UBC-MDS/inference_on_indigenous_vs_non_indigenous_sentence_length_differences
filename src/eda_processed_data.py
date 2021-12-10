"""EDA on processed data.

This file takes the cleaned and processed data and performs some basic EDA
It creates:
  - info table describing the processed data. Saves to data/processed/dataset_info.csv
  - counts table returning counts of racial groups data/processed/group_counts.csv
  - summary table with mean/median/min/max values for aggregated sentence length for each grouping data/processed/basic_summary_table.csv
  - box plots graph and saves it to ~/doc/eda-box_plots.png
  - densities graph and saves it to ~/doc/eda-densities.png

Usage: eda_processed_data.py --processed_data_path=<relative_data_path> --results_folder_path=<relative_folder_path> 

Options:
--processed_data_path=<relative_data_path>     Relative path for processed data
--results_folder_path=<relative_folder_path>   Relative path for all the outputs
"""

#Dependensies

import numpy as np
import pandas as pd
import altair as alt
import os
from altair_saver import save
from docopt import docopt

opt = docopt(__doc__)

def test_df_rows_cols(df):
    """sanity check for invalid datafrmaes.

    Parameters
    ----------
    price : Pandas.DataFrame
        Any data frame to be tested

    Examples
    --------
    >>> test_df_rows_cols(input_df)
    """
    assert df.shape[0] > 0, "There are no observations in the provided processed data frame"
    assert df.shape[1] > 1, "There are less that two columns in the provided processed data"

def main(processed_data_path, results_folder_path):
    df_init = pd.read_csv(processed_data_path)
    alt.data_transformers.disable_max_rows() #normally, altair limits it to 5K rows
    alt.renderers.enable('png')
    
    df = df_init
    test_df_rows_cols(df)
    
    #########################
    ########   INFO  ########
    #########################
    
    # Quick info confirming dtypes and no missing values. 
    # Save it to data/processed folder
    
    df_info = pd.DataFrame(df.info())
    
    
    filename = 'dataset_info.csv'
    dirname = results_folder_path
    
    if not os.path.exists(dirname):
        os.mkdir(dirname)
    
    fullpath_data_info = os.path.join(dirname, filename)
    df_info.to_csv(fullpath_data_info)
    
    ##########################
    ########   COUNTS  ########
    ##########################
    
    #Let's take a glance at how many observations we have of each 
    #grouping and save it as csv in data/processed folder
    
    df_counts = pd.DataFrame(df['race_grouping'].value_counts())
    df_counts = df_counts.rename(columns={"race_grouping": "Count"})
    
    filename = 'group_counts.csv'
    dirname = results_folder_path

    if not os.path.exists(dirname):
        os.mkdir(dirname)
    
    fullpath_counts = os.path.join(dirname, filename)
    df_counts.to_csv(fullpath_counts)
    
    
    #####################
    ###### SUMMARY ######
    #####################
    
    # Let's do min max mean median by group for length of sentence 
    # and save it as csv in data/processed folder
    
    df_summary = df.groupby('race_grouping').agg({'aggregate_sentence_length': ['mean','median', 'min', 'max']})
    
    filename = 'basic_summary_table.csv'
    dirname = results_folder_path
    
    if not os.path.exists(dirname):
        os.mkdir(dirname)
    
    fullpath_summary_table = os.path.join(dirname, filename)
    df_summary.to_csv(fullpath_summary_table)
    
    #######################
    ###### BOX PLOTS ######
    #######################
    
    # Create box plots and 
    # Save the boxplots to ~/doc/eda-box_plots.png
    
    ratio_boxplots = alt.Chart(df).mark_boxplot(size=50).encode(
        x = alt.X('aggregate_sentence_length', title="Aggregate Sentence Length (days)", type='quantitative', axis=alt.Axis(format='~s'), scale=alt.Scale(type='log')),
        y = alt.Y('race_grouping', title=""), 
        color = alt.Color('race_grouping', title="Race Grouping")
    ).properties(
        title = "Aggregate Sentence Length by Racial Grouping",
        height = 350,
        width = 800
    )
    
    filename = 'eda-box_plots.png'
    dirname = results_folder_path
    
    if not os.path.exists(dirname):
        os.mkdir(dirname)
    
    fullpath_boxplots = os.path.join(dirname, filename)
    ratio_boxplots.save(fullpath_boxplots)
    
    
    #######################
    ###### DENSITIES ######
    #######################
    
    # Save the densities plot to ~/doc/eda-densities.png
    
    densities = alt.Chart(df).transform_density(
        'aggregate_sentence_length',
        groupby=['race_grouping'],
        as_=['aggregate_sentence_length', 'density'],
    ).mark_area(
        opacity=0.5,
        clip=True
    ).encode(
        x=alt.X('aggregate_sentence_length', title="Aggregate Sentence Length (days)", scale=alt.Scale(domain=[700, 5000]), axis=alt.Axis(format='~s')),
        y=alt.Y('density:Q', title="", axis=alt.Axis(labels=False)),
        color=alt.Color('race_grouping', title="Race Grouping")
    ).properties(
        title = "Aggregate Sentence Length by Racial Grouping: Density Plot",
        height = 350,
        width = 800
    )
    
    filename = 'eda-densities.png'
    dirname = results_folder_path
    
    if not os.path.exists(dirname):
        os.mkdir(dirname)
    
    fullpath_densities = os.path.join(dirname, filename)
    densities.save(fullpath_densities)
    
if __name__ == "__main__":
        main(opt["--processed_data_path"], opt["--results_folder_path"])
