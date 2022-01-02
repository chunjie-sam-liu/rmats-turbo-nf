#!/usr/bin/env bash
# @AUTHOR: Chun-Jie Liu
# @CONTACT: chunjie.sam.liu.at.gmail.com
# @DATE: 2021-11-05 17:17:36
# @DESCRIPTION:

# Number of input parameters
nohup docker run -v /workspace/liucj/refdata/star-genome-index-grch38:/refdata \
  chunjiesamliu/rmats-turbo:latest \
  STAR --runThreadN 80 \
  --runMode genomeGenerate \
  --genomeDir /refdata \
  --genomeFastaFiles /refdata/Homo_sapiens.GRCh38.104.fa \
  --sjdbGTFfile /refdata/Homo_sapiens.GRCh38.104.gtf \
  --sjdbOverhang 100 &