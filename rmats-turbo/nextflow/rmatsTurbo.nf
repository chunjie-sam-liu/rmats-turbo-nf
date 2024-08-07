nextflow.enable.dsl=2


process rmats_prep {
  tag "RMATS-PREP"
  label "mid_memory"
  publishDir "${params.publishDir}/rmats-prep", mode: 'symlink'

  input:
    tuple val(name), file(bam)
    each file(gtf)
  output:
    path "*.rmats", emit: rmat
    path "*_read_outcomes_by_bam.txt", emit: rob

  script:
  read_type_value = params.singleEnd ? "single" : "paired"
  variable_read_length_opt = params.variable_read_length ? "--variable-read-length" : ""
  anchorLength_opt = params.anchorLength ? "--anchorLength ${params.anchorLength}" : ""
  novelSS_opt = params.novelSS ? "--novelSS" : ""
  mil_opt = params.novelSS ? params.mil ? "--mil ${params.mil}" : "" : ""
  mel_opt = params.novelSS ? params.mel ? "--mel ${params.mel}" : "" : ""
  allow_clipping_opt = params.allow_clipping ? "--allow-clipping" : ""

  """
  echo ${bam} > prep.txt

  python /rmats/rmats.py \
    --b1 prep.txt \
    --gtf ${gtf} \
    -t ${read_type_value} \
    --readLength ${params.readLength} \
    --nthread 1 \
    --od ${params.out_dir} \
    --tmp tmp_output_prep_${bam_id} \
    --task prep \
    --libType ${params.lib_type} \
    ${variable_read_length_opt} \
    ${anchorLength_opt} \
    ${novelSS_opt} \
    ${mil_opt} ${mel_opt} \
    ${allow_clipping_opt}

    mkdir outfd
    python /rmats/cp_with_prefix.py prep_${bam_id}_ outfd tmp_output_prep_${bam_id}/*.rmats
    cp tmp_output_prep_${bam_id}/*_read_outcomes_by_bam.txt outfd

  """
}

process rmats_post {
  tag "RMATS-POST"
  label "tera_memory"
  publishDir "${params.publishDir}/rmats-post", mode: 'copy'

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
  is_default_stats = (!params.paired_stats) && (!params.darts_model)
  cstat_opt = is_default_stats ? "--cstat ${params.cstat}" : ""


  """
  cstat_opt = params.paired_stats ? "" : "--cstat ${params.cstat}"

}

workflow {
  sayHello()
}