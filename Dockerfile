# Docker file for the Indigeneous vs Non-indigenous aggregate sentence predictor
# Kyle Ahn, Dec 11th, 2021 

# # use rocker/tidyverse as base image
FROM rocker/tidyverse

# Install R packages
RUN apt-get update -qq && apt-get --no-install-recommends install \
  && install2.r --error \
  --deps TRUE \
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

COPY environment.yml .
RUN conda env create -f environment.yml
SHELL ["conda", "run", "-n", "myenv", "/bin/bash", "-c"]