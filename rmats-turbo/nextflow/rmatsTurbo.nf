nextflow.enable.dsl=2


process rmats_prep_single {
  tag "rmats_prep_single"
  label "mid_memory"
  publishDir "${params.publishDir}/rmats-prep", mode: 'symlink'

  input:
    tuple val(bam_name), file(bam)
    file(gtf)
    val(group)

  // output:
  //   path "*.rmats", emit: rmat
  //   path "*_read_outcomes_by_bam.txt", emit: rob

  script:
    bam_id = "${group}_${bam_name}"

    read_type_value = params.is_single_end ? "single" : "paired"
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

process rmats_prep_paired {
  tag "rmats_prep_single"
  label "mid_memory"
  publishDir "${params.publishDir}/rmats-prep", mode: 'symlink'

  input:
    tuple val(bam_name), file(bam)
    file(gtf)
    val(group)

  // output:
  //   path "*.rmats", emit: rmat
  //   path "*_read_outcomes_by_bam.txt", emit: rob

  script:
    bam_id = "${group}_${bam_name}"

    read_type_value = params.is_single_end ? "single" : "paired"
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
  statoff_opt = params.statoff ? "--statoff" : ""
  paired_stats_opt = params.paired_stats ? "--paired-stats" : ""
  darts_model_opt = params.darts_model ? "--darts-model" : ""
  darts_cutoff_opt = params.darts_model ? "--darts-cutoff ${params.darts_cutoff}" : ""
  novelSS_opt = params.novelSS ? "--novelSS" : ""
  mil_opt = params.novelSS ? params.mil ? "--mil ${params.mil}" : "" : ""
  mel_opt = params.novelSS ? params.mel ? "--mel ${params.mel}" : "" : ""
  individual_counts_opt = params.individual_counts ? "--individual-counts" : ""

  """
  mkdir fd_rmats


  """


}

workflow {
  // TURBOPREP(bams, gtfs)
  bam_g1_ch = Channel
    .fromPath(params.bam_g1)
    .ifEmpty {exit 1, "No bam files found in ${params.bam_g1}"}
    .splitCsv(by:1, strip: true)
    .map {
      // bam name, bam file
      row -> tuple(file(row[0].trim()).simpleName, file(row[0].trim()))
    }
  // print view the variable
  bam_g1_ch.view()

  // bam_g2 = Channel.fromPath(params.bam_g2)
  bam_g2_ch = Channel
    .fromPath(params.bam_g2)
    .ifEmpty {exit 1, "No bam files found in ${params.bam_g2}"}
    .splitCsv(by:1, strip: true)
    .map {
      // bam name, bam file
      row -> tuple(file(row[0].trim()).simpleName, file(row[0].trim()))
    }

  // print view the variable
  bam_g2_ch.view()

  gtf_ch = Channel.fromPath(params.gtf)
    .ifEmpty {exit 1, "No gtf file found in ${params.gtf}"}

  // print view the variable
  gtf_ch.view()

  // Start workflow
  // rmats_prep
  rmats_prep_single(bam_g1_ch, gtf_ch, "g1")
  rmats_prep_paired(bam_g2_ch, gtf_ch, "g2")
}