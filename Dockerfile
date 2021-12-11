# Docker file for the Indigeneous vs Non-indigenous aggregate sentence predictor
# Kyle Ahn, Dec 11th, 2021 

# # use rocker/tidyverse as base image
FROM rocker/tidyverse:4.1

# Install R packages
RUN apt-get update -qq && apt-get --no-install-recommends install \
  && install2.r --error \
  --deps TRUE \
  readr \
  kableExtra \
  knitr \
  docopt \
  janitor \
  infer \
  testthat

# Install miniconda3 python distribution
RUN wget \
    https://repo.anaconda.com/miniconda/Miniconda3-latest-Linux-x86_64.sh \
    && mkdir /root/.conda \
    && bash Miniconda3-latest-Linux-x86_64.sh -b \
    && rm -f Miniconda3-latest-Linux-x86_64.sh

# Set miniconda3 python path
ENV PATH="/root/miniconda3/bin:${PATH}"

# Set conda-forge channel
RUN conda config --append channels conda-forge

# Install python packages
RUN conda install -y -c anaconda \
    docopt=0.6.2 \
    numpy=1.21.2 \
    pandas=1.3.2 \
    altair=4.1.0 \
    altair_saver=0.5.0