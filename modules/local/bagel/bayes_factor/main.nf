
process BAGEL_BAYES_FACTOR {
    tag { meta.control }
    container "${params.containers.bagel}"
    label 'process_single'

    input:
        tuple val(meta), path(fold_change)

    output:
        tuple val(meta), path("*.bf"), emit: bf

    script:
    """
    BAGEL.py bf \\
      -i ${fold_change} \\
      -o ${fold_change.getBaseName(2)}.bf \\
      -e ${params.bagel.core_essential_genes} \\
      -n ${params.bagel.non_essential_genes} \\
      -c ${params.bagel.test_columns}
    """

    stub:
    """
    touch ${fold_change.getBaseName(2)}.bf
    """
}
