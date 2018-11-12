FROM continuumio/miniconda3


# Conda supports delegating to pip to install dependencies
# that aren’t available in anaconda or need to be compiled
# for other reasons. In our case, we need psycopg compiled
# with SSL support. These commands install prereqs necessary
# to build psycopg.
RUN git clone https://github.com/nickp60/ISEScan
WORKDIR ISEScan

RUN conda install -c conda-forge fastcluster
RUN conda install -c bioconda biopython==1.68 blast fraggenescan hmmer scipy

RUN apt-get update && apt-get install -y  build-essential

# I had to put the lib here for it to be recognized :(
RUN cd ssw201507 &&  gcc -Wall -O3 -pipe -fPIC -shared -rdynamic ssw.c ssw.h && cp a.out /ISEScan/libssw.so && cp a.out /usr/lib/x86_64-linux-gnu/libssw.so

RUN pip install fastcluster


# RUN export LD_LIBRARY_PATH=$LD_LIBRARY_PATH:/ISEScan/libssw.so
# RUN chmod +xrw /ISEScan/libssw.so
# RUN wc /ISEScan/libssw.so
# RUN ls -la /usr/lib/x86_64-linux-gnu/libssw.so
# RUN ls -la /ISEScan/libssw.so
############### configure
ADD ./constants.py /ISEScan/constants.py


RUN python3 isescan.py NC_012624.fna proteome hmm
