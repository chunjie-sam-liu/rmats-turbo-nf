#!/usr/bin/env nextlfow

nextflow.enable.dsl=2

// import modules
include {FASTQ} from "./modules/fastq"
include {TRIM} from "./modules/trim"
include { QC; QC as QCT} from "./modules/qc"
// include {BAM} from "./modules/bam"

workflow {
  reads_ch = Channel
    .fromPath(params.reads)
    .ifEmpty {exit 1, "Cant find reads file: ${params.reads}"}
    .splitCsv(by:1, strip: true)
    .map{val -> tuple(file(val[0].trim()).simpleName, file(val[0].trim()))}

// get fastq files
  FASTQ(reads_ch)
  FASTQ.out.rawReads | view
  // raw quality control
  QC(FASTQ.out.rawReads, "raw")
  // trim
  TRIM(FASTQ.out.rawReads)
  TRIM.out.trimmedReads | view
  // trimmed quality control
  QCT(TRIM.out.trimmedReads, "trimmed")

}

workflow.onComplete {
  log.info ( workflow.success ? "\nDone! Open the following report in your browser" : "Oops .. something went wrong" )
  }
