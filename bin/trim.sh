#!/usr/bin/env bash
# @AUTHOR: Chun-Jie Liu
# @CONTACT: chunjie.sam.liu.at.gmail.com
# @DATE: 2022-01-09 13:48:02
# @DESCRIPTION:

# Number of input parameters
name=${1}
reads=${2}
singleEnd=${3}
readLength=${4}
adapter=${5}
minLen=${6}
slidingWindow=${7}
#readLength=`zcat fastq.gz |head -2|tail -1|wc -L`

[[ singleEnd == "true" ]] && mode="SE" || mode="PE"
[[ singleEnd == "true" ]] && out="${name}_trimmed.fastq.gz" || out="${name}_trimmed_R1.fastq.gz ${name}_unpaired_R1.fastq.gz ${name}_trimmed_R2.fastq.gz ${name}_unpaired_R2.fastq.gz"
[[ singleEnd == "true" ]] && keepbothreads="" || keepbothreads=":2:true"
[[ readLength == "false" ]] && readLength=`zcat fastq.gz |head -2|tail -1|wc -L`

trimmomatic \
  ${mode} \
  -threads 5 \
  -phred33 \
  ${reads} \
  ${out} \
  ILLUMINACLIP:${adapter}:2:30:10${keepbothreads} \
  LEADING:3 \
  TRAILING:3 \
  MINLEN:${minLen} \
  CROP:${readLength} \
  $slidingWindow
