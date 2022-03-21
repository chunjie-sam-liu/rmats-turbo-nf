#!/usr/bin/env bash
# @AUTHOR: Chun-Jie Liu
# @CONTACT: chunjie.sam.liu.at.gmail.com
# @DATE: 2021-12-28 17:00:01
# @DESCRIPTION:

# Number of input parameters

srrList=`cut -f 51 test/GSE112037_metadata.tsv | sort | uniq |grep -v srr`

for srr in ${srrList[@]}
do
  bash /home/liucj/github/useful-scripts/download-sra.sh $srr test/data
done