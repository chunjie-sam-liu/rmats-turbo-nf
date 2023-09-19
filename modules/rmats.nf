process TURBOPREP {
  tag "TURBOPREP"
  label "mid_memory"
  publishDir "${params.publishDir}/as/turboprep", mode: "symlink"

  input:
    tuple val(name), file(bam)
    each file(gtf)
  output:
    path "*.rmats", emit: rmat
    path "*_read_outcomes_by_bam.txt", emit: rob
    path "${name}.txt"

  script:
  libType = params.stranded ? params.stranded == "first-stranded" ? "fr-firststrand" : "fr-secondstrand" : "fr-unstranded"
  mode = params.singleEnd ? "single" : "paired"
  variable_readLength_opt = params.variableReadLength ? "--variable-read-length" : ""
  anchorLength_opt = params.anchorLength ? "--anchorLength ${params.anchorLength}" : ""
  novelSS_opt = params.novelSS ? "--novelSS" : ""
  mil_opt = params.novelSS ? params.mil ? "--mil ${params.mil}" : "" : ""
  mel_opt = params.novelSS ? params.mel ? "--mel ${params.mel}" : "" : ""
  allow_clipping_opt = params.allowClipping ? "--allow-clipping" : ""

  """
  echo ${bam} > ${name}.txt
  rmats.py \
    --b1 ${name}.txt \
    --gtf ${gtf} \
    -t ${mode} \
    --readLength ${params.readLength} \
    --nthread ${task.cpus} \
    --od ./ \
    --tmp ./ \
    --task prep \
    --libType ${libType} \
    ${variable_readLength_opt} \
    ${anchorLength_opt} \
    ${novelSS_opt} \
    ${mil_opt} ${mel_opt} \
    ${allow_clipping_opt}
  """
}

process TURBOPOST {
  tag "TURBOPOST"
  label "tera_memory"
  publishDir "${params.publishDir}/as/turbopost", mode: "copy"

  input:
    file(bams)
    file(rmats)
    file(robs)
    each file(gtf)
  output:
    path "post/*.txt"
    path "b1.txt"

  script:
  anchorLength_opt = params.anchorLength ? "--anchorLength ${params.anchorLength}" : ""
  cstat_opt = params.pairedStats ? "" : "--cstat ${params.cstat}"
  statoff_opt = params.statoff ? "--statoff" : ""
  paired_stats_opt = params.pairedStats ? "--paired-stats" : ""
  novelSS_opt = params.novelSS ? "--novelSS" : ""
  mil_opt = params.novelSS ? params.mil ? "--mil ${params.mil}" : "" : ""
  mel_opt = params.novelSS ? params.mel ? "--mel ${params.mel}" : "" : ""


  """
  mkdir prep
  mv *.rmats prep/
  mv *_read_outcomes_by_bam.txt prep/
  ls *.bam |tr '\\n' ',' | sed 's/,\$/\\n/' > b1.txt
  rmats.py \
    --b1 b1.txt \
    --gtf ${gtf} \
    --readLength ${params.readLength} \
    --nthread ${task.cpus} \
    --od ./post \
    --tmp ./prep \
    --task post \
    ${anchorLength_opt} \
    --tstat ${params.tstat} \
    ${cstat_opt} \
    ${statoff_opt} ${paired_stats_opt} \
    ${novelSS_opt} \
    ${mil_opt} ${mel_opt}

  """


}

// process TURBOBOTH {
//   tag "TURBOBOTH"
//   label "high_memory"
// }