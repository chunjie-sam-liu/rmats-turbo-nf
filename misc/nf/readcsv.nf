#!/usr/bin/env nextflow
nextflow.enable.dsl=2


process get_accession {
  publishDir "$params.outdir/fastq", mode: 'symlink'
  tag "${sraID}"
  label "tiny_memory"
  echo false

  input:
    tuple val(sraID), val(accession)
    // file(reads) from ch_reads
  output:
    tuple val(sraID), path("${sraID}_1.fastq.gz"), path("${sraID}_2.fastq.gz"), emit: a

  script:
  """
  echols.sh ${sraID}
  """
}

workflow {
  accession_ids_ch = Channel
    .fromPath(params.reads)
    .ifEmpty {exit 1, "Cant find reads file: ${params.reads}"}
    .splitCsv(by:1, strip: true)
    .map{val -> tuple(file(val[0].trim()).simpleName, file(val[0].trim()))}

  // accession_ids_ch | view
  // accession_ids_ch | view

  get_accession(accession_ids_ch)

  get_accession.out.a | view
  get_accession.out.a \
    | view \
    | collectFile(name: "fastq_files.txt") \
    | view {"Filename ${it}, and content is ${it.text}"}
}