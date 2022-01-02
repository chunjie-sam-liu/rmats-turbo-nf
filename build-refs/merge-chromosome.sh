#!/usr/bin/env bash
# @AUTHOR: Chun-Jie Liu
# @CONTACT: chunjie.sam.liu.at.gmail.com
# @DATE: 2021-11-05 20:58:19
# @DESCRIPTION:

# Number of input parameters

chrs=(1 2 3 4 5 6 7 8 9 10 11 12 13 14 15 16 17 18 19 20 21 22 X Y MT)
destdir=refdata/human-genome-ensembl-release-104

for chromosome in ${chrs[@]}; do
    echo "Processing chromosome ${chromosome}..."
    zcat ${destdir}/chr${chromosome}.fa.gz >> ${destdir}/Homo_sapiens.GRCh38.104.fa
done

