#!/usr/bin/env nextflow
// nextflow.enable.dsl=2


Channel
  .fromPath(params.reads)
  .ifEmpty {exit 1, "Cant find reads file: ${params.reads}"}
  .splitCsv()
  .map(sample -> sample[0].trim())
  .set { accession_ids }


Channel
  .value(file(params.reads))
  .set { ch_reads }

process get_accession {
  // publishDir "${params.outdir}/process-logs/${task.process}/${accession}/", pattern: "command-logs-*", mode: 'copy'
  // tag "${accession}"
  // label "tiny_memory"
  echo true

  input:
    val(accession) from accession_ids
    file(reads) from ch_reads

  script:
  """
  echo "accession: ${accession}"
  """
}