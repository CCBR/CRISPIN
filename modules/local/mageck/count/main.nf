
process MAGECK_COUNT {

    tag { meta.control }
    container "${params.containers.mageck}"
    label 'process_single'

    input:
        tuple val(meta), path(fastqs_sample), path(fastqs_control)
        path(lib)

    output:
      tuple val(meta), path("*.count.txt"), emit: count
      tuple val(meta), path("*.count_normalized.txt"), emit: count_norm
      tuple val(meta), path("*.countsummary.txt"), emit: count_sum

    script:
    """
    mageck count \\
      -l ${lib} \\
      --fastq ${fastqs_sample} ${fastqs_control} \\
      --sample-label ${meta.ids},${meta.control} \\
      -n ${params.exp_name}
    """

    stub:
    """
    for ext in count count_normalized countsummary; do
        touch ${params.exp_name}.\${ext}.txt
    done
    uname -a > output.txt
    echo ${task.container} >> output.txt
    """

}
