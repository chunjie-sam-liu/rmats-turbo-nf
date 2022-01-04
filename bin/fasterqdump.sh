#!/usr/bin/env bash
# @AUTHOR: Chun-Jie Liu
# @CONTACT: chunjie.sam.liu.at.gmail.com
# @DATE: 2022-01-02 18:06:14
# @DESCRIPTION:

# Number of input parameters
sra=${1}
outdir=${2}

fasterq-dump \
  --bufsize 1G \
  --curcache 1G \
  --mem 1G \
  --threads 5 \
  --split-files ${sra} \
  --outdir ${outdir}