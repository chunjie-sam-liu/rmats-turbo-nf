#!/usr/bin/env bash
# @AUTHOR: Chun-Jie Liu
# @CONTACT: chunjie.sam.liu.at.gmail.com
# @DATE: 2022-01-02 15:19:14
# @DESCRIPTION:


# singularity pull docker://chunjiesamliu/rmats-turbo:latest

# Number of input parameters
singularity exec ${HOME}/sif/rmats-turbo_latest STAR --runThreadN 80 \
  --runMode genomeGenerate \
  --genomeDir refdata/star-genome-index-grch38 \
  --genomeFastaFiles refdata/star-genome-index-grch38/Homo_sapiens.GRCh38.104.fa \
  --sjdbGTFfile refdata/star-genome-index-grch38/Homo_sapiens.GRCh38.104.gtf \
  --sjdbOverhang 100