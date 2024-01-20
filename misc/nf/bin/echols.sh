#!/usr/bin/env bash
# @AUTHOR: Chun-Jie Liu
# @CONTACT: chunjie.sam.liu.at.gmail.com
# @DATE: 2022-01-07 14:41:21
# @DESCRIPTION:

sraID=$1

echo "${sraID}-JC" > ${sraID}_1.fastq.gz
echo "${sraID}-CJ" > ${sraID}_2.fastq.gz

# echo `fasterq-dump --version` > faster.txt