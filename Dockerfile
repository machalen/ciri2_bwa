###########################################################
# Dockerfile to build container images for circRNA analysis
# Tool for making counts in the genomic analysis
# Based on Ubuntu
############################################################

#Set the image based on Ubuntu
FROM ubuntu:latest

#File Author/Maintainer
MAINTAINER Machalen, magdalena.arnalsegura@iit.it

#Instructions to build and run interactive
#docker build --no-cache -t ciri2_bwa:v1 .
#docker run -ti --rm ciri2_bwa:v1

#Update the repository sources list and install essential libraries
RUN apt-get update && apt-get install --yes build-essential gcc-multilib apt-utils \
	zlib1g-dev liblzma-dev wget git python-dev libbz2-dev
RUN DEBIAN_FRONTEND="noninteractive" apt-get -y install tzdata

#Install required libraries in ubuntu other packages
RUN apt-get update -y && apt-get install -y \
	unzip bzip2 g++ make ncurses-dev python default-jdk default-jre libncurses5-dev \
	libbz2-dev perl perl-base

#Install BWA
WORKDIR /usr/local
RUN git clone https://github.com/lh3/bwa.git
WORKDIR /usr/local/bwa
RUN make
ENV PATH /usr/local/bwa:$PATH

#Install CIRI2
WORKDIR /usr/local
RUN wget https://sourceforge.net/projects/ciri/files/CIRI2/CIRI_v2.0.6.zip/download && unzip download && rm download
#ENV PATH /usr/local/CIRI_v2.0.6:$PATH

#Install bedtools
WORKDIR /usr/local
RUN wget https://github.com/arq5x/bedtools2/releases/download/v2.29.2/bedtools-2.29.2.tar.gz
RUN tar -zxvf bedtools-2.29.2.tar.gz
WORKDIR /usr/local/bedtools2
RUN make
ENV PATH /usr/local/bedtools2/bin:$PATH

#Clean and set workingdir
RUN apt-get clean
RUN apt-get remove --yes --purge build-essential gcc-multilib apt-utils zlib1g-dev wget
WORKDIR /
