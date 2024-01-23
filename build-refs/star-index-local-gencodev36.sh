#!/usr/bin/env bash
# @AUTHOR: Chun-Jie Liu
# @CONTACT: chunjie.sam.liu.at.gmail.com
# @DATE: 2024-01-22 16:00:37
# @DESCRIPTION:

# Number of input parameters
param=$#

# Number of input parameters
${HOME}/tools/STAR-2.7.9a/bin/Linux_x86_64/STAR --runThreadN 80 \
  --runMode genomeGenerate \
  --genomeDir /home/liuc9/data/refdata/star-genome-index-grch38-gencode-v36 \
  --genomeFastaFiles /home/liuc9/data/refdata/star-genome-index-grch38-gencode-v36/Homo_sapiens.GRCh38.104.fa \
  --sjdbGTFfile /mnt/isilon/xing_lab/liuc9/refdata/star-genome-index-grch38-gencode-v36/gencode.v36.annotation.chrom.gtf \
  --sjdbOverhang 100
