process STRINGTIE {
  tag "STRINGTIE-${name}"
  label "high_memory"
  publishDir "${params.publishDir}/quant/stringtie", mode: "copy"


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

process PREPDE {
  tag "PREPDE"
  label "mid_memory"
  publishDir "${params.publishDir}/quant/countmatrix", pattern: "{sample_lst.txt,*gene_count_matrix.csv,*transcript_count_matrix.csv}", mode: "copy"

  input:
    file(gtf)
  output:
    path "sample_lst.txt", emit: sampleLst
    path "*gene_count_matrix.csv", emit: geneCountMatrix
    path "*transcript_count_matrix.csv", emit: transcriptCountMatrix

  script:
  date = new Date().format("MM-dd-yyyy")
  run_prefix = "prepde_" + date
  """
  echo "${gtf.join("\n").toString().replace("_for_DGE.gtf", "")}" > samples.txt
  echo "${gtf.join("\n")}" > gtfs.txt
  paste -d ' ' samples.txt gtfs.txt > sample_lst.txt
  prepDE.py \
    -i sample_lst.txt \
    -l ${params.readLength} \
    -g ${run_prefix}_gene_count_matrix.csv \
    -t ${run_prefix}_transcript_count_matrix.csv
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

  script:
  """
  ls -1 *.gtf > assembly_gtf_list.txt
  stringtie --merge -G ${params.gtf} -o stringtie_merged.gtf assembly_gtf_list.txt -p $task.cpus
  gffcompare -R -V -r ${params.gtf} stringtie_merged.gtf ${baseDir}/bin/correct_gene_names.R
  gffread -E gffcmp.annotated.corrected.gff -T -o gffcmp.annotated.corrected.gtf
  """
}