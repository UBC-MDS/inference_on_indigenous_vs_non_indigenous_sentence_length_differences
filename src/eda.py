#Dependensies

import numpy as np
import pandas as pd
import altair as alt
import os
from altair_saver import save

script_dir = os.path.dirname(__file__) #<-- absolute dir the script is in
rel_path = "processed_offender_profile.csv"
abs_file_path = os.path.join(script_dir, rel_path)

df_init = pd.read_csv(abs_file_path)
#df_init = pd.read_csv('processed_offender_profile.csv')

alt.data_transformers.disable_max_rows() #normally, altair limits it to 5K rows
alt.renderers.enable('png')

df = df_init

#########################
########   INFO  ########
#########################

# Quick info confirming dtypes and no missing values. 
# Save it to data/processed folder

df_info = pd.DataFrame(df.info())
filename = 'dataset_info.csv'

dirname = '../data/processed'
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

dirname = '../data/processed'
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

dirname = '../data/processed'
if not os.path.exists(dirname):
    os.mkdir(dirname)

fullpath_summary_table = os.path.join(dirname, filename)
df_summary.to_csv(fullpath_summary_table)

#######################
###### BOX PLOTS ######
#######################

# Create box plots and 
# Save the boxplots to ~/doc/eda-box_plots.png

ratio_boxplots = alt.Chart(df).mark_boxplot().encode(
    x = alt.X('aggregate_sentence_length', type='quantitative'),
    y = alt.Y('race_grouping'), 
    color = 'race_grouping'
).properties(
    height = 350,
    width = 800
)

filename = 'eda-box_plots.png'

dirname = '../doc'
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
    x=alt.X('aggregate_sentence_length', scale=alt.Scale(domain=[700, 5000])),
    y='density:Q',
    color='race_grouping'
)

filename = 'eda-densities.png'

dirname = '../doc'
if not os.path.exists(dirname):
    os.mkdir(dirname)

fullpath_densities = os.path.join(dirname, filename)
densities.save(fullpath_densities)


