
process FASTQ {
  tag "FASTQ-${acc}"
  label "mid_memory"
  publishDir "${params.publishDir}/fastq", mode: 'symlink'

  input:
    tuple val(acc), val(sraFile)
  output:
    tuple val(acc), file(outputFileName), val(params.singleEnd), emit: rawReads

  script:
  outputFileName = params.singleEnd ? "${acc}.fastq.gz" : "${acc}_{1,2}.fastq.gz"
  ngcCMD = params.ngcFile ? "--ngc ${params.ngcFile}" : ""

  """
  fastq.sh ${sraFile} "${ngcCMD}"
  pigz *fastq
  """

}