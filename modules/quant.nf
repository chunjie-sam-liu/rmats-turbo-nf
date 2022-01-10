process STRINGTIE {
  tag "QUANT-${name}"
  label "mega_memory"
  publishDir "${publishDir}/quant", mode: "copy"


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