#!/usr/bin/env nextflow
nextflow.enable.dsl=2


process FASTQ {
  publishDir "$params.outdir/fastq", mode: 'symlink'
  tag "${sraID}"
  label "tiny_memory"
  echo false

  input:
    tuple val(acc), val(sraFile)
    // file(reads) from ch_reads
  output:
    tuple val(acc), file(outputFileName), val(params.singleEnd), emit: rawReads

  script:
  outputFileName = params.singleEnd ? "${acc}.fastq.gz" : "${acc}_{1,2}.fastq.gz"
  """
  echols.sh ${acc}
  # ls -l
  """
}

workflow {
  if (params.sras) {
    sra_ch = Channel
      .fromPath(params.sras)
      .ifEmpty {exit 1, "Cant find reads file: ${params.reads}"}
      .splitCsv(by:1, strip: true)
      .map{val -> tuple(file(val[0].trim()).simpleName, file(val[0].trim()))}
      FASTQ(sra_ch)

      fastq_ch = FASTQ.out.rawReads
  }
  if (params.fastqfiles) {
      fastq_ch = Channel
        .fromFilePairs(params.fastqfiles)
        .map {acc, fqs -> tuple(acc, fqs, params.singleEnd)}
  }

  fastq_ch.ifEmpty {
    exit 1, "No fastq files found"
  }
  fastq_ch | view



  // get_accession(accession_ids_ch)

  // get_accession.out.a | view
  // get_accession.out.a \
  //   | view \
  //   | collectFile(name: "fastq_files.txt") \
  //   | view {"Filename ${it}, and content is ${it.text}"}
}