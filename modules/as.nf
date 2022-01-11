include { TURBOPREP } from "./rmats"


workflow ASUNPAIRED {
  take:
    bams
    gtfs

  main:
    TURBOPREP(bams, gtfs)


}

// workflow ASPAIRED {
//   tag "ASPAIRED"
//   label "high_memory"
// }