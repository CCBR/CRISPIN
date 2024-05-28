

process MAGECK_MLE {
    tag { meta.control }
    label 'process_higher'
    container "${params.containers.mageck}"

    input:
        tuple val(meta), path(count)
        path(design)

    output:
        tuple val(meta), path("*.gene_summary.txt"), emit: gene
        tuple val(meta), path("*.sgrna_summary.txt"), emit: sgrna

    script:
    """
    export OMP_NUM_THREADS=1 # this number gets multiplied by --threads
    mageck mle \\
      -k ${count} \\
      -d ${design} \\
      -n ${count.getBaseName(2)} \\
      --threads ${task.cpus}
    """

    stub:
    """
    for ext in gene sgrna; do
        touch ${count.getBaseName(2)}.\${ext}_summary.txt
    done
    """
}
