process STRINGTIE {
  tag "STRINGTIE-${name}"
  label "high_memory"
  publishDir "${params.publishDir}/quant/stringtie", mode: "copy"


  input:
    tuple val(name), file(bam), file(bamIndex)
  output:
    path "${name}.gtf", emit: gtf
    path "${name}_for_DGE.gtf", emit: dgeGtf

  script:
  rf = params.stranded ? params.stranded == "first-strand" ? "--rf" : "--fr" : ""
  """
  stringtie.sh ${name} ${bam} ${params.gtf} ${task.cpus} "${rf}"
  """
}