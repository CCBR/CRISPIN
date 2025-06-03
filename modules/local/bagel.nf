
process FOLD_CHANGE {
    label 'bagel'
    container "${params.container_bagel}"

    input:
        path(count)
        val(control)

    output:
        path("*.foldchange"), emit: fc
        path("*.normed_readcount"), emit: count_norm

    script:
    """
    BAGEL.py fc \\
      -i ${count} \\
      -o ${count.getBaseName(2)} \\
      -c ${control.join(',')}
    """

    stub:
    """
    for ext in foldchange normed_readcount; do
        touch ${count.getBaseName(2)}.\$ext
    done
    echo ${task.container} > output.txt
    """
}

process BAYES_FACTOR {
    label 'bagel'
    container "${params.container_bagel}"

    input:
        path(fold_change)

    output:
        path("*.bf"), emit: bf

    script:
    """
    BAGEL.py bf \\
      -i ${fold_change} \\
      -o ${fold_change.getBaseName(2)}.bf \\
      -e ${params.bagel_core_essential_genes} \\
      -n ${params.bagel_non_essential_genes} \\
      -c ${params.bagel_test_columns}
    """

    stub:
    """
    touch ${fold_change.getBaseName(2)}.bf
    """
}
process PRECISION_RECALL {
    label 'bagel'
    container "${params.container_bagel}"

    input:
        path(bayes_factor)

    output:
        path("*.pr"), emit: pr

    script:
    """
    BAGEL.py pr \\
      -i ${bayes_factor} \\
      -o ${bayes_factor.getBaseName(2)}.pr \\
      -e ${params.bagel_core_essential_genes} \\
      -n ${params.bagel_non_essential_genes}
    """

    stub:
    """
    touch ${bayes_factor.getBaseName(2)}.pr
    """
}
