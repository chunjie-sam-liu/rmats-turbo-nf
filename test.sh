#!/usr/bin/env bash
# @AUTHOR: Chun-Jie Liu
# @CONTACT: chunjie.sam.liu.at.gmail.com
# @DATE: 2022-01-07 14:05:27
# @DESCRIPTION:

# Number of input parameters


nextflow run /home/liuc9/github/rmats-turbo-nf/main.nf \
  -config test.config \
  -profile base,singularity \
  -resume