#!/usr/bin/env nextlfow

nextflow.enable.dsl=2

// import modules
include {FASTERQDUMP} from "./modules/fasterqdump"


workflow {
  sratsvfile = channle.from(params.sratsvfile)
  FASTERQDUMP(params.)
}

workflow.onComplete {
  log.info ( workflow.success ? "\nDone! Open the following report in your browser" : "Oops .. something went wrong" )
  }
