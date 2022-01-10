#!/usr/bin/env bash
# @AUTHOR: Chun-Jie Liu
# @CONTACT: chunjie.sam.liu.at.gmail.com
# @DATE: 2022-01-09 21:21:42
# @DESCRIPTION:

# Number of input parameters
starIndex=$1
reads=$2
name=$3
threads=$4
gtf=$5
overhang=$6
sjdbOverhangMin=$7
sjOverhangMin=$8
filterScore=$9
mismatch=${10}
endsType=${11}
saveUnmappedReads=${12}


STAR \
  --genomeDir ${starIndex} \
  --readFilesIn ${reads} \
  --readMatesLengthsIn NotEqual \
  --outFileNamePrefix ${name}. \
  --runThreadN ${threads} \
  --readFilesCommand zcat \
  --sjdbGTFfile ${gtf} \
  --sjdbOverhang ${overhang} \
  --alignSJDBoverhangMin ${sjdbOverhangMin} \
  --alignSJoverhangMin ${sjOverhangMin} \
  --outFilterScoreMinOverLread ${filterScore} \
  --outFilterMatchNminOverLread ${filterScore} \
  --outFilterMismatchNmax ${mismatch} \
  --outFilterMultimapNmax 20 \
  --alignMatesGapMax 1000000 \
  --outSAMunmapped Within \
  --outSAMattributes NH HI AS NM MD XS \
  --outSAMType BAM SortedByCoordinate \
  --outBAMsortingThreadN ${threads} \
  --outFilterType BySJout \
  --twopassMode Basic \
  --alignEndsType ${endsType} \
  --alignIntronMax 1000000 \
  ${saveUnmappedReads} \
  --quantMode GeneCounts \
  --outWigType None \
  # --outFilterIntronMotifs RemoveNoncanonicalUnannotated \
  --outSAMstrandField intronMotif

samtools index ${name}.Aligned.sortedByCoord.out.bam
# bamCoverage -b ${name}.Aligned.sortedByCoord.out.bam -o ${name}.bw

# samtools view -h ${name}.Aligned.sortedByCoord.out.bam \
#   | gawk -v q=${q} -f /usr/local/bin/tagXSstrandedData.awk \
#   | samtools view -bS - > Aligned.XS.bam \
#   && mv Aligned.XS.bam ${name}.Aligned.sortedByCoord.out.bam