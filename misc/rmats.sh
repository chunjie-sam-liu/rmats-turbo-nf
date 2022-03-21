#!/usr/bin/env bash
# @AUTHOR: Chun-Jie Liu
# @CONTACT: chunjie.sam.liu.at.gmail.com
# @DATE: 2022-01-11 14:47:12
# @DESCRIPTION:

# Number of input parameters


# unpaired data
rmats.py \
  --gtf $GTF \
  --tmp prep \
  --od post_1019 \
  --readLength 101 \
  --b1 bamConfiguration_prep/bam1.txt \
  -t paired \
  --anchorLength 1 \
  --nthread 1 \
  --libType fr-unstranded \
  --task prep \
  --variable-read-length

rmats.py \
  --gtf $GTF \
  --tmp prep \
  --od post_1019 \
  --readLength 101 \
  --b1 bamConfiguration_post/b1.txt \
  -t paired \
  --anchorLength 1 \
  --nthread 1 \
  --libType fr-unstranded \
  --task post \
  --variable-read-length \
  --statoff