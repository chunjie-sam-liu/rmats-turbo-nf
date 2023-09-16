#!/usr/bin/env nextlfow

nextflow.enable.dsl=2

// import modules
include { FASTQ } from "./modules/fastq"
include { TRIM } from "./modules/trim"
include { QC; QC as QCT} from "./modules/qc"
include { STAR } from "./modules/bam"
// include { STRINGTIE; PREPDE; STRINGTIEMERGE } from "./modules/quant"
include { STRINGTIE as STRINGTIE_A; STRINGTIE as STRINGTIE_N; PREPDE as PREPDE_A; PREPDE as PREPDE_N; STRINGTIEMERGE } from "./modules/quant"
include { ASUNPAIRED } from "./modules/as"


workflow {
  if (params.sras) {
    sra_ch = Channel
      .fromPath(params.sras)
      .ifEmpty {exit 1, "Cant find reads file: ${params.sras}"}
      .splitCsv(by:1, strip: true)
      .map{val -> tuple(file(val[0].trim()).simpleName, file(val[0].trim()))}

      // get fastq files
    FASTQ(sra_ch)
    fastq_ch = FASTQ.out.rawReads
  }
  if (params.fastqs) {
    fastq_ch = Channel
      .fromFilePairs(params.fastqs)
      .map {acc, fqs -> tuple(acc, fqs, params.singleEnd)}
  }

  if (params.bams) {

    bams_ch_raw = Channel
      .fromPath(params.bams)
      .ifEmpty {exit 1, "Cant find reads file: ${params.sras}"}
      .splitCsv(by:1, strip: true)
      .map{
        val -> tuple(file(val[0]).simpleName, file(val[0]), file("${val[0]}.bai"))
      }

    mergedGtf_ch = Channel.fromPath(params.gtf)

    // bams_ch_raw.view()

    STRINGTIE_A(bams_ch_raw, "annotated", file(params.gtf))
    PREPDE_A(STRINGTIE_A.out.dgeGtf.collect(), "annotated")
    STRINGTIEMERGE(STRINGTIE_A.out.gtf.collect())

    if (params.rmats_pairs) {
      mergedGtf_ch | view
    } else {
      bams_ch = bams_ch_raw
        .map {name, bam, bai -> [name, bam]}

      ASUNPAIRED(bams_ch, mergedGtf_ch)
    }

  } else {
    // raw quality control
  QC(fastq_ch, "raw")
  // trim
  TRIM(fastq_ch)
  // TRIM.out.trimmedReads | view
  // trimmed quality control
  QCT(TRIM.out.trimmedReads, "trimmed")
  // STAR Mapping
  STAR(TRIM.out.trimmedReads)
  // STAR.out.indexedBam | view
  // Quantification
  STRINGTIE_A(STAR.out.indexedBam, "annotated", file(params.gtf))
  // STRINGTIE.out.gtf | view
  // STRINGTIE PREPDE
  PREPDE_A(STRINGTIE_A.out.dgeGtf.collect(), "annotated")
  // PREPDE.out.sampleLst | view
  // STRINGTIE MERGE
  STRINGTIEMERGE(STRINGTIE_A.out.gtf.collect())
  // STRINGTIEMERGE.out.mergedGtf | view
  // rMATS

  // mergedGtf_ch = Channel.fromPath(params.gtf)
  //   .combine(STRINGTIEMERGE.out.mergedGtf)
  //   .flatten()
  mergedGtf_ch = Channel.fromPath(params.gtf)

  if (params.rmats_pairs) {
    mergedGtf_ch | view
    } else {
      bams_ch = STAR.out.indexedBam
        .map {name, bam, bai -> [name, bam]}

      ASUNPAIRED(bams_ch, mergedGtf_ch)

    }
  }


}

workflow.onComplete {
  log.info ( workflow.success ? "\nDone! Open the following report in your browser" : "Oops .. something went wrong" )
}
