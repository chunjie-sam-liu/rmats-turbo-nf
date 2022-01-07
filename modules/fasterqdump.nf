
process FASTERQDUMP {
  publishDir "${params.publishDir}/fastq", mode: 'symlink'
  tag "FASTERQDUMP-${acc}"
  label "low_memory"

  input:
    tuple val(acc), val(sraFile)
  output:
    tuple val(acc), file(outputFileName), val(params.singleEnd), emit: rawReads

  script:
  outputFileName = params.singleEnd ? "${acc}.fastq.gz" : "${acc}_{1,2}.fastq.gz"
  ngcCMD = params.ngcFile ? "--ngc ${params.ngcFile}" : ""

  """
  fasterqdump.sh ${sraFile} "${ngcCMD}"
  pigz *fastq

  # save .command.* logs
  ${params.saveScript}
  """

}