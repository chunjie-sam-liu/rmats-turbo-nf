process BAM {
  tag "BAM-${name}"
  label "mega_memory"
  publishDir "${params.publishDir}/bam", mode: "symlink"

  input:
    tuple val(name), file(reads), val(singleEnd)

  // output:
  //   tuple val(name), file("${name}.Aligned.sortedByCoord.out.bam"), file("${name}.Aligned.sortedByCoord.out.bam.bai"), emit: bam

  script:
  overhang = params.overhang ? params.overhang : params.readLength - 1
  endsType = params.softClipping ? "Local" : "EndToEnd"
  starMem = params.starMemory ? params.starMemory : task.memory
  saveUnmappedReads = params.saveUnmappedReads ? "--saveUnmappedReads Fastx" : ""
  q = ${params.strType[$params.stranded].strType}

  // bam.sh ${params.starIndex} "${reads}" ${name} ${task.cpus} ${params.gtf} ${overhang} ${params.sjdbOverhangMin} ${params.sjOverhangMin} ${params.filterScore} ${params.mismatch} ${endsType} ${saveUnmappedReads}
  """
  echo $starMem
  """

}