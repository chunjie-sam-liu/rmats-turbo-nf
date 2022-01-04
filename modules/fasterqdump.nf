
params.outdir="data/results"

process FASTERQDUMP {
  tag "FASTERQDUMP"
  publishDir params.outdir

  input:
    path sra

  script:
  """
  fasterqdump.sh "$sra" params.outdir
  """

}