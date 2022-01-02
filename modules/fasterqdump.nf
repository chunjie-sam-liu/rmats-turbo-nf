
params.outdir="data/results"

process FASTERQDUMP {
  tag "FASTERQDUMP"
  publishDir params.outdir

  input:
    tuple val(sample_id), path(sra)

  script:
  """
  fasterqdump.sh "$sra" params.outdir
  """

}