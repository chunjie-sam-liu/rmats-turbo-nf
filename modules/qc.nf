process QC {
  tag "QC-${name}"
  label "low_memory"
  publishDir "${params.publishDir}/qc/${rawTrim}", pattern: "*_fastqc.{zip,html}", mode: "symlink"

  input:
    tuple val(name), file(reads), val(singleEnd)
    val(rawTrim)

  output:
    file "*_fastqc.{html,zip}", emit: qcResults

  script:
  """
  fastqc --casava --threads ${task.cpus} $reads
  """

}