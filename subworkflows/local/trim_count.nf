include { CUTADAPT               } from '../../modules/CCBR/cutadapt'
include { COUNT as MAGECK_COUNT } from "../../modules/local/mageck.nf"
include { COUNT as DOTMATCH_COUNT } from "../../modules/local/dotmatch.nf"

workflow TRIM_COUNT {
    take:
        raw_reads
        library

    main:
        CUTADAPT(raw_reads)
        CUTADAPT.out.reads
        .multiMap { meta, fastq ->
            id: meta.id
            fastq: fastq
        }
        .set{ reads }

        if (params.count_method == 'dotmatch') {
            DOTMATCH_COUNT(library,
                           reads.id.collect(),
                           reads.fastq.collect()
                          )
        } else {
            MAGECK_COUNT(library,
                         reads.id.collect(),
                         reads.fastq.collect()
                        )
        }

    emit:
        count = params.count_method == 'dotmatch' ? DOTMATCH_COUNT.out.count : MAGECK_COUNT.out.count
        trimmed_reads = CUTADAPT.out.reads
}
