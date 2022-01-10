process STAR {
  tag "STAR-${name}"
  label "mega_memory"
  publishDir "${params.publishDir}/bam/bam", pattern: "*{out.bam,out.bam.bai}*", mode: "symlink"
  publishDir "${params.publishDir}/bam/tab", pattern: "*{ReadsPerGene.out.tab,SJ.out.tab}*", mode: "copy"

  input:
    tuple val(name), file(reads), val(singleEnd)

  output:
    tuple val(name), file("${name}.Aligned.sortedByCoord.out.bam"), file("${name}.Aligned.sortedByCoord.out.bam.bai"), emit: indexedBam
    file "*ReadsPerGene.out.tab"
    file "*SJ.out.tab"
    file "*Unmapped*" optional true
    file "${name}.bw" optional true

  script:
  overhang = params.overhang ? params.overhang : params.readLength - 1
  endsType = params.softClipping ? "Local" : "EndToEnd"
  starMem = params.starMemory ? params.starMemory : task.memory
  saveUnmappedReads = params.saveUnmappedReads ? "--saveUnmappedReads Fastx" : ""
  q = {params.strType[params.stranded].strType}

  """
  star.sh ${params.starIndex} "${reads}" ${name} ${task.cpus} ${params.gtf} ${overhang} ${params.sjdbOverhangMin} ${params.sjOverhangMin} ${params.filterScore} ${params.mismatch} ${endsType} ${saveUnmappedReads}
  """

}