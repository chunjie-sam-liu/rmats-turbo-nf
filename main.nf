#!/usr/bin/env nextlfow

nextflow.enable.dsl=2

// import modules
include {FASTERQDUMP} from "./modules/fasterqdump"


workflow {
  reads_ch = Channel
    .fromPath(params.reads)
    .ifEmpty {exit 1, "Cant find reads file: ${params.reads}"}
    .splitCsv(by:1, strip: true)
    .map{val -> tuple(file(val[0].trim()).simpleName, file(val[0].trim()))}

  FASTERQDUMP(reads_ch)
  FASTERQDUMP.out.rawReads | view
}

workflow.onComplete {
  log.info ( workflow.success ? "\nDone! Open the following report in your browser" : "Oops .. something went wrong" )
  }
