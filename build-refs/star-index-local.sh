#!/usr/bin/env bash
# @AUTHOR: Chun-Jie Liu
# @CONTACT: chunjie.sam.liu.at.gmail.com
# @DATE: 2021-12-06 15:29:26
# @DESCRIPTION:

# Number of input parameters
${HOME}/tools/STAR-2.7.9a/bin/Linux_x86_64/STAR --runThreadN 80 \
  --runMode genomeGenerate \
  --genomeDir refdata/star-genome-index-grch38 \
  --genomeFastaFiles refdata/star-genome-index-grch38/Homo_sapiens.GRCh38.104.fa \
  --sjdbGTFfile refdata/star-genome-index-grch38/Homo_sapiens.GRCh38.104.gtf \
  --sjdbOverhang 100