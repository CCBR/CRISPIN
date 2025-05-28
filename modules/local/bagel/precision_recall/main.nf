

process BAGEL_PRECISION_RECALL {
    tag { meta.control }
    container "${params.containers.bagel}"
    label 'process_single'

    input:
        tuple val(meta), path(bayes_factor)

    output:
        tuple val(meta), path("*.pr"), emit: pr

    script:
    """
    BAGEL.py pr \\
      -i ${bayes_factor} \\
      -o ${bayes_factor.getBaseName(2)}.pr \\
      -e ${params.bagel.core_essential_genes} \\
      -n ${params.bagel.non_essential_genes}
    """

    stub:
    """
    touch ${bayes_factor.getBaseName(2)}.pr
    """
}
