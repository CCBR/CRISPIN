
process FASTQC {
    tag { sample_id }

    container "${params.container_fastqc}"

    input:
        tuple val(sample_id), path(fastq)
    output:
        tuple val(sample_id), path("${sample_id}*.html")

    script:
    """
    fastqc \
        $fastq \
        -t $task.cpus \
        -o .
    """
}
