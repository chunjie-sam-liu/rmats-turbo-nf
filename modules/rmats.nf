process TURBOPREP {
  tag "TURBOPREP"
  label "mid_memory"
  // publishDir "${publishDir}/as/turboprep", mode: "symlink"
  input:
    tuple val(name), file(bam)
    each file(gtf)
  // output:
    // path "*.rmats", emit: rmat
    // path "*_read_outcomes_by_bam.txt", emit: rob
    // path "${name}.txt"

  script:
  libType = params.stranded ? params.stranded == "first-strand" ? "fr-firststrand" : "fr-secondstrand" : "fr-unstranded"
  mode = params.singleEnd ? "single" : "paired"
  statoff = params.statoff ? "--statoff" : ""
  novelSS = params.novelSS ? "--novelSS" : ""
  allowClipping = params.softClipping ? "--allow-clipping" : ""
  """
  echo ${bam} > ${name}.txt

  """
}

// process TURBOPOST {
//   tag "TURBOPOST"
//   label "high_memory"

//   input:
//     file(bams)
//     file(rmats)
//     file(robs)
//     each file(gtf)

//   script:
//   libType = params.stranded ? params.stranded == "first-strand" ? "fr-firststrand" : "fr-secondstrand" : "fr-unstranded"
//   mode = params.singleEnd ? "single" : "paired"
//   statoff = params.statoff ? "--statoff" : ""
//   novelSS = params.novelSS ? "--novelSS" : ""
//   allowClipping = params.softClipping ? "--allow-clipping" : ""
//   """
//   mkdir prep
//   mv *.rmats prep/
//   mv *_read_outcomes_by_bam.txt prep/
//   ls *.bam |tr '\\n' ',' | sed 's/,\$/\\n/' > b1.txt
//   rmats.py \
//     --gtf ${gtf} \
//     --b1 b1.txt \
//     --od ./post \
//     --tmp ./prep \
//     -t ${mode} \
//     --libType ${libType} \
//     --readLength ${params.readLength} \
//     --variable-read-length \
//     --anchorLength 1 \
//     --nthread ${task.cpus} \
//     --task post \
//     --mil ${params.mil} \
//     --mel ${params.mel} \
//     ${statoff} \
//     ${novelSS} \
//     ${allowClipping}
//   """


// }

// process TURBOBOTH {
//   tag "TURBOBOTH"
//   label "high_memory"
// }