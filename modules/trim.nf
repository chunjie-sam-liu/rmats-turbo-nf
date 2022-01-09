process TRIM {
  publishDir "${params.publishDir}/trim", mode: "symlink"
  tag "TRIM-${name}"
  label "low_memory"

  input:
    tuple val(name), file(reads), val(singleEnd)
  output:
    tuple val(name), file(outputFileName), val(singleEnd), emit: trimmedReads

  script:
  outputFileName = singleEnd ? "${name}_trimmed.fastq.gz" : "${name}_trimmed_R{1,2}.fastq.gz"
  slidingWindow = params.slidingWindow ? "SLIDINGWINDOW:4:15" : ""
  adapter = params.adapter ? file(params.adapter) : singleEnd ? file("${baseDir}/adapters/TruSeq3-SE.fa") : file("${baseDir}/adapters/TruSeq3-PE.fa")
  """
  trim.sh ${name} ${reads} ${singleEnd} ${params.readLength} ${adapter} ${params.minLen} ${slidingWindow}

  # save .command.* logs
  ${params.saveScript}
  """
}