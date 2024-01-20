process STRINGTIE {
  tag "STRINGTIE-${name}"
  label "mid_memory"
  publishDir "${params.publishDir}/quant/stringtie", mode: "copy"


  input:
    tuple val(name), file(bam), file(bamIndex)
    val(annonovel)
    file(ref_gtf)
  output:
    path "${name}.${annonovel}.gtf", emit: gtf
    path "${name}.${annonovel}_for_DGE.gtf", emit: dgeGtf
    path "${name}.${annonovel}.gene_abund.tab", emit: geneAbund

  script:
  rf = params.stranded ? params.stranded == "first-strand" ? "--rf" : "--fr" : ""
  """
  stringtie ${bam} -G ${ref_gtf} -o ${name}.${annonovel}.gtf ${rf} -a 8 -p ${task.cpus}
  stringtie ${bam} -G ${ref_gtf} -o ${name}.${annonovel}_for_DGE.gtf ${rf} -a 8 -p ${task.cpus} -e -A ${name}.${annonovel}.gene_abund.tab
  """
}

process STRINGTIEMERGE {
  tag "STRINGTIEMERGE"
  label "mid_memory"
  publishDir "${params.publishDir}/quant/stringtiemerge", mode: "copy"

  input:
    file("*.gtf")

  output:
    path "gffcmp.annotated.corrected.gtf", emit: mergedGtf
    path "gffcmp.*", emit: gffcmp
    path "stringtie_merged.gtf", emit: stringtieMergedGtf

  script:
  """
  ls -1 *.gtf > assembly_gtf_list.txt
  stringtie --merge -G ${params.gtf} -o stringtie_merged.gtf assembly_gtf_list.txt -p $task.cpus
  gffcompare -R -V -r ${params.gtf} stringtie_merged.gtf
  correct_gene_names.R
  gffread -E gffcmp.annotated.corrected.gff -T -o gffcmp.annotated.corrected.gtf
  """
}

process PREPDE {
  tag "PREPDE"
  label "mid_memory"
  publishDir "${params.publishDir}/quant/countmatrix", pattern: "{*_gene_count_matrix.csv,*_transcript_count_matrix.csv}", mode: "copy"

  input:
    file(gtf)
    val(annonovel)
  output:
    path "sample_lst.txt", emit: sampleLst
    path "*gene_count_matrix.csv", emit: geneCountMatrix
    path "*transcript_count_matrix.csv", emit: transcriptCountMatrix

  script:
  date = new Date().format("MM-dd-yyyy")
  run_prefix = "prepde_" + date
  """
  echo "${gtf.join("\n").toString().replace(".${annonovel}_for_DGE.gtf", "")}" > samples.txt
  echo "${gtf.join("\n")}" > gtfs.txt
  paste -d ' ' samples.txt gtfs.txt > sample_lst.txt
  prepDE.py \
    -i sample_lst.txt \
    -l ${params.readLength} \
    -g ${annonovel}_gene_count_matrix.csv \
    -t ${annonovel}_transcript_count_matrix.csv
  """
}
