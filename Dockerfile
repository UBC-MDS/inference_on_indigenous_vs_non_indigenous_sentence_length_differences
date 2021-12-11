# Docker file for the Indigeneous vs Non-indigenous aggregate sentence predictor
# Kyle Ahn, Dec, 2021 

# # use r-base:3.6.1 as base
FROM rocker/tidyverse

# Install R packages
# install the kableExtra package using install.packages
RUN Rscript -e "install.packages('kableExtra')"
RUN Rscript -e "install.packages('knitr')"
RUN Rscript -e "install.packages('docopt')"
RUN Rscript -e "install.packages('janitor')"
RUN Rscript -e "install.packages('infer')"
RUN Rscript -e "install.packages('testthat')"


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