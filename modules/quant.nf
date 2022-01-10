process QUANT {
  tag "QUANT-${name}"
  label "mega_memory"
  publishDir "${publishDir}/quant", mode: "copy"


  input:
    tuple val(name), file(bam), file(bamIndex)
  output:
    path "${name}.gtf", emit: gtf
    // file "${name}_for_DGE.gtf"

  script:
  rf = params.stranded ? params.stranded == "first-strand" ? "--rf" : "--fr" : ""
  """
  stringtie $bam -G ${params.gtf} -o ${name}.gtf $rf -a 8 -p ${task.cpus}
  stringtie $bam -G ${params.gtf} -o ${name}_for_DGE.gtf $rf -a 8 -e -p ${task.cpus}
  """
}