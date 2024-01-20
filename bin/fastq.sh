#!/usr/bin/env bash
# @AUTHOR: Chun-Jie Liu
# @CONTACT: chunjie.sam.liu.at.gmail.com
# @DATE: 2022-01-02 18:06:14
# @DESCRIPTION:

# Number of input parameters
sraFile=${1}
ngcCMD=${2}

fasterq-dump \
  ${ngcCMD} \
  --mem 1G \
  --threads 5 \
  --split-3 ${sraFile}