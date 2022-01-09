process BAM {
  tag "BAM-${name}"
  label "mega_memory"
  publishDir "${params.publishDir}/bam", mode: "symlink"

  input:
    tuple val(name), file(reads), val(singleEnd)
}