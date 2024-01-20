#!/usr/bin/env bash
# @AUTHOR: Chun-Jie Liu
# @CONTACT: chunjie.sam.liu.at.gmail.com
# @DATE: 2022-03-21 16:51:52
# @DESCRIPTION:

# Number of input parameters
nextflow run /home/liuc9/github/rmats-turbo-nf/main.nf \
  -config test.config \
  -profile base,singularity \
  -resume