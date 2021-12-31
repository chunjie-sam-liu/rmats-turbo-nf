#!/usr/bin/env bash
# @AUTHOR: Chun-Jie Liu
# @CONTACT: chunjie.sam.liu.at.gmail.com
# @DATE: 2021-12-31 13:19:37
# @DESCRIPTION:

# Number of input parameters
fasterq-dump --outdir ./ --bufsize 1G --curcache 1G --mem 1G --threads 5 --split-files ./SRR8615581.sra