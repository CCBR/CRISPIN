
process DRUGZ {
    label 'drugz'
    container "${params.containers.drugz}"

    input:
        tuple val(meta), path(count)

    output:
        tuple val(meta), path("*output.txt"), emit: txt
        tuple val(meta), path("*foldchange.txt"), emit: fc

    script:
    """
    drugz.py \\
      -i ${count} \\
      -o ${count.getBaseName(2)}.output.txt \\
      -f ${count.getBaseName(2)}.foldchange.txt \\
      -c ${meta.control} \\
      -x ${meta.ids} \\
      -r ${params.drugz.remove_genes} \\
      --half_window_size ${params.drugz.half_window_size}
    """

    stub:
    """
    for ext in output foldchange; do
        touch ${count.getBaseName(2)}.\$ext.txt
    done
    """
}
