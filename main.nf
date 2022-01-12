#!/usr/bin/env nextlfow

nextflow.enable.dsl=2

// import modules
include { FASTQ } from "./modules/fastq"
include { TRIM } from "./modules/trim"
include { QC; QC as QCT} from "./modules/qc"
include { STAR } from "./modules/bam"
include { STRINGTIE; PREPDE; STRINGTIEMERGE } from "./modules/quant"
include { ASUNPAIRED } from "./modules/as"


workflow {
  reads_ch = Channel
    .fromPath(params.reads)
    .ifEmpty {exit 1, "Cant find reads file: ${params.reads}"}
    .splitCsv(by:1, strip: true)
    .map{val -> tuple(file(val[0].trim()).simpleName, file(val[0].trim()))}

// get fastq files
  FASTQ(reads_ch)
  // FASTQ.out.rawReads | view
  // raw quality control
  // QC(FASTQ.out.rawReads, "raw")
  // trim
  TRIM(FASTQ.out.rawReads)
  // TRIM.out.trimmedReads | view
  // trimmed quality control
  // QCT(TRIM.out.trimmedReads, "trimmed")
  // STAR Mapping
  STAR(TRIM.out.trimmedReads)
  // STAR.out.indexedBam | view
  // Quantification
  STRINGTIE(STAR.out.indexedBam)
  // STRINGTIE.out.gtf | view
  // STRINGTIE PREPDE
  PREPDE(STRINGTIE.out.dgeGtf.collect())
  // PREPDE.out.sampleLst | view
  // STRINGTIE MERGE
  STRINGTIEMERGE(STRINGTIE.out.gtf.collect())
  // STRINGTIEMERGE.out.mergedGtf | view
  // rMATS

  // mergedGtf_ch = Channel.fromPath(params.gtf)
  //   .combine(STRINGTIEMERGE.out.mergedGtf)
  //   .flatten()
  mergedGtf_ch = Channel.fromPath(params.gtf)

  if (params.rmats_pairs) {
    mergedGtf_ch | view
  } else {
    bams_ch = STAR.out.indexedBam
      .map {name, bam, bai -> [name, bam]}

    ASUNPAIRED(bams_ch, mergedGtf_ch)

  }
}

workflow.onComplete {
  log.info ( workflow.success ? "\nDone! Open the following report in your browser" : "Oops .. something went wrong" )
}
