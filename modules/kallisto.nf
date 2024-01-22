process KALLISTOBAM {
  tag "KALLISTO-${name}"
  label "mid_memory"
  publishDir "${params.publishDir}/quant/kallisto", mode: "copy"

  input:
    tuple val(name), file(bam), file(bamIndex)
    file(ref_gtf_kallisto)
  output:
    path "${name}_kallisto/${name}_abundance.tsv", emit: abundance

  script:
  """
  samtools sort -@ ${task.cpus} -n -o ${name}.sorted.bam ${bam}
  samtools fastq -@ ${task.cpus} \
    -1 ${name}_1.fastq.gz \
    -2 ${name}_2.fastq.gz \
    -0 /dev/null \
    -s /dev/null \
    -n ${name}.sorted.bam
  kallisto quant -i ${ref_gtf_kallisto} \
    -t ${task.cpus} \
    -o ${name}_kallisto \
    ${name}_1.fastq.gz ${name}_2.fastq.gz
  mv ${name}_kallisto/abundance.tsv ${name}_kallisto/${name}_abundance.tsv
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