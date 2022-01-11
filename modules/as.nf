include { TURBOPREP; TURBOPOST } from "./rmats"


workflow ASUNPAIRED {
  take:
    bams
    gtfs

  main:
    TURBOPREP(bams, gtfs)
    TURBOPOST(bams.map {name, bam -> bam}.collect(), TURBOPREP.out.rmat.collect(), TURBOPREP.out.rob.collect(), gtfs)


}

// workflow ASPAIRED {
//   tag "ASPAIRED"
//   label "high_memory"
// }