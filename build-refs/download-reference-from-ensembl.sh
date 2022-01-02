#!/usr/bin/env bash
# @AUTHOR: Chun-Jie Liu
# @CONTACT: chunjie.sam.liu.at.gmail.com
# @DATE: 2021-11-05 20:27:02
# @DESCRIPTION:

# Number of input parameters

chrs=(1 2 3 4 5 6 7 8 9 10 11 12 13 14 15 16 17 18 19 20 21 22 X Y MT)

destdir=refdata/human-genome-ensembl-release-104

echo "Downloading human genome reference from Ensembl..."
for chromosome in ${chrs[@]}; do
    echo "Downloading chromosome ${chromosome}..."
    cmd="nohup curl -s -o ${destdir}/chr${chromosome}.fa.gz ftp://ftp.ensembl.org/pub/release-104/fasta/homo_sapiens/dna/Homo_sapiens.GRCh38.dna.chromosome.${chromosome}.fa.gz 1>${destdir}/${chromosome}.nohup.out 2>&1 &"
    echo ${cmd}
    eval ${cmd}
done
