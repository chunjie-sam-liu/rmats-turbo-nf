#!/usr/bin/env bash
# @AUTHOR: Chun-Jie Liu
# @CONTACT: chunjie.sam.liu.at.gmail.com
# @DATE: 2022-01-10 10:46:07
# @DESCRIPTION:

# Number of input parameters

name=$1
bam=$2
gtf=$3
threads=$4
rf=$5

stringtie $bam -G ${gtf} -o ${name}.gtf $rf -a 8 -p ${threads}
stringtie $bam -G ${gtf} -o ${name}_for_DGE.gtf $rf -a 8 -e -p ${threads}