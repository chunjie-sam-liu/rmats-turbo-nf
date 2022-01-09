process QC {
  tag "QC-${name}"
  label "low_memory"
  publishDir "${params.publishDir}/qc/${rawTrim}", pattern: "*_fastqc.{zip,html}", mode: "symlink"

  input:
    tuple val(name), file(reads), val(singleEnd)
    val(rawTrim)

  output:
    file "*._fastqc.{zip,html}"

  script:
  """
  fastqc --casava --threads ${task.cpus} $reads
  """

}