log.info """\
CRISPIN 🍪
=============
NF version   : $nextflow.version
runName      : $workflow.runName
username     : $workflow.userName
configs      : $workflow.configFiles
profile      : $workflow.profile
cmd line     : $workflow.commandLine
start time   : $workflow.start
projectDir   : $workflow.projectDir
launchDir    : $workflow.launchDir
workDir      : $workflow.workDir
homeDir      : $workflow.homeDir
input        : ${params.input}
"""
.stripIndent()

// SUBMODULES
include { INPUT_CHECK } from './subworkflows/local/input_check.nf'
include { MAGECK      } from './subworkflows/local/mageck.nf'
include { BAGEL       } from './subworkflows/local/bagel.nf'

// MODULES
include { CUTADAPT      } from './modules/CCBR/cutadapt'
include { MAGECK_COUNT  } from './modules/local/mageck/count'
include { DRUGZ         } from './modules/local/drugz'

workflow.onComplete {
    if (!workflow.stubRun && !workflow.commandLine.contains('-preview')) {
        println "Running spooker"
        def message = Utils.spooker(workflow)
        if (message) {
            println message
        }
    }
}

workflow {
    INPUT_CHECK(file(params.input))
    INPUT_CHECK.out.reads
        | set { raw_reads }

    if (params.count_table) {

        // if count table exists, re-populate metadata with linked controls
        ch_branched = raw_reads.branch { meta, fastqs ->
                treat: meta.control.length() > 0
                    return [ [control: meta.control], meta.id ]
                control: meta.control.length() == 0
                    return [ [control: meta.sample_basename], meta.id ]
                }
        ch_count = ch_branched.treat
                | groupTuple()
                | map { meta, ids ->
                    [ meta, ids.flatten().join(',')]
                    }
                | join( ch_branched.control )
                | map { meta, ids, ctrl ->
                    meta.ids = ids
                    [ meta ]
                    }
                | combine( Channel.fromPath(file(params.count_table, checkIfExists: true)) )
        ch_count | view
    } else {
        // trim reads and run mageck count
        CUTADAPT(raw_reads)

        // group samples with their controls
        ch_branched = CUTADAPT.out.reads.branch { meta, fastqs ->
                treat: meta.control.length() > 0
                    return [ [control: meta.control], meta.id, fastqs ]
                control: meta.control.length() == 0
                    return [ [control: meta.sample_basename], fastqs ]
                }
        ch_treat_ctrl_linked = ch_branched.treat
                | groupTuple()
                | map { meta, ids, fastqs ->
                    [ meta, ids.flatten().join(','), fastqs.flatten() ]
                    }
                | join( ch_branched.control )
                | map { meta, ids, sample_fastqs, ctrl_fastqs ->
                    meta.ids = ids
                    [ meta, sample_fastqs, ctrl_fastqs ]
                }

        MAGECK_COUNT(ch_treat_ctrl_linked,
                     file(params.library, checkIfExists: true)
                    )
        ch_count = MAGECK_COUNT.out.count
    }


    if (params.mageck.run) {
        MAGECK(ch_count)
    }
    if (params.drugz.run) {
        DRUGZ(ch_count)
    }
    if (params.bagel.run) {
        BAGEL(ch_count)
    }

}
