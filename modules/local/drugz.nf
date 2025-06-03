
process DRUGZ {
    label 'drugz'
    container "${params.container_drugz}"

    input:
        path(count)
        val(treatment)
        val(control)

    output:
        path("*output.txt"), emit: txt
        path("*foldchange.txt"), emit: fc

    script:
    """
    drugz.py \\
      -i ${count} \\
      -o ${count.getBaseName(2)}.output.txt \\
      -f ${count.getBaseName(2)}.foldchange.txt \\
      -c ${control.join(',')} \\
      -x ${treatment.join(',')} \\
      -r ${params.drugz_remove_genes} \\
      --half_window_size ${params.drugz_half_window_size}
    """

    stub:
    """
    for ext in output foldchange; do
        touch ${count.getBaseName(2)}.\$ext.txt
    done
    """
}
