process KALLISTOBAM {
  tag "KALLISTO-${name}"
  label "mid_memory"
  publishDir "${params.publishDir}/quant/kallisto", mode: "copy"

  input:
    tuple val(name), file(bam), file(bamIndex)
    file(ref_gtf_kallisto)

  script:
  """

  """
}

process KALLISTOFASTQ {
  tag "KALLISTO-${name}"
  label "mid_memory"
  publishDir "${params.publishDir}/quant/kallisto", mode: "copy"

  input:
    tuple val(name), file(fastq)
    file(ref_gtf_kallisto)

  script:
  """

  """
}