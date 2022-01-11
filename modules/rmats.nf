process TURBOPREP {
  tag "TURBOPREP"
  label "high_memory"
  publishDir "${publishDir}/as/turboprep", mode: "symlink"
  input:
    tuple val(name), file(bam)
    each file(gtf)
  output:
    file("*.rmats"), emit: rmat
    file("*._433734_read_outcomes_by_bam.txt"), emit: rob
    file("${name}.txt")

  script:
  libType = params.stranded ? params.stranded == "first-strand" ? "fr-firststrand" : "fr-secondstrand" : "fr-unstranded"
  mode = params.singleEnd ? "single" : "paired"
  statoff = params.statoff ? "--statoff" : ""
  novelSS = params.novelSS ? "--novelSS" : ""
  allowClipping = params.softClipping ? "--allow-clipping" : ""
  """
  echo ${bam} >  ${name}.txt
  rmats.py \
    --gtf ${gtf} \
    --b1 ${name}.txt \
    --od ./ \
    --tmp ./ \
    -t ${mode} \
    --libType ${libType} \
    --readLength ${params.readLength} \
    --variable-read-length \
    --anchorLength 1 \
    --nthread ${task.cpus} \
    --task prep \
    --mil ${params.mil} \
    --mel ${params.mel} \
    ${statoff} \
    ${novelSS} \
    ${allowClipping}
  """
}

// process TURBOPOST {
//   tag "TURBOPOST"
//   label "high_memory"


// }

// process TURBOBOTH {
//   tag "TURBOBOTH"
//   label "high_memory"
// }