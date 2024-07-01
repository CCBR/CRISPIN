
process MAGECK_TEST {

    tag { meta.control }
    container "${params.containers.mageck}"
    label 'process_single'

    input:
      tuple val(meta), path(count)

    output:
      tuple val(meta), path("*.gene_summary.txt"), emit: gene
      tuple val(meta), path("*.sgrna_summary.txt"), emit: sgrna

    script:
    """
    mageck test \\
      -k ${count} \\
      -t ${meta.ids} \\
      -c ${meta.control} \\
      -n ${count.getBaseName(2)}
    """

    stub:
    """
    for ext in gene sgrna; do
        touch ${count.getBaseName(2)}.\${ext}_summary.txt
    done
    """
}
