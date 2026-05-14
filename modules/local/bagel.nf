
// Nextflow v2 strict parser compliant: Helper method for species-specific gene sets
def get_bagel_gene_sets(String species) {
    Map bagel_gene_sets = [
        human: [
            core: '/opt2/bagel-2.0-115/CEGv2.txt',
            noncore: '/opt2/bagel-2.0-115/NEGv1.txt'
        ],
        mouse: [
            core: '/opt2/bagel-2.0-115/CEGv2_mouse.txt',
            noncore: '/opt2/bagel-2.0-115/NEGv1_mouse.txt'
        ]
    ]
    
    if (!bagel_gene_sets.containsKey(species)) {
        error("Unsupported bagel_species '${species}'. Supported species: ${bagel_gene_sets.keySet().join(', ')}")
    }
    
    return bagel_gene_sets[species]
}

// Helper to resolve gene set file paths based on species or explicit params
def resolve_bagel_genes() {
    Map genes = get_bagel_gene_sets(params.bagel_species)
    
    // Allow explicit params to override species defaults
    String core_genes = params.bagel_core_essential_genes
    String noncore_genes = params.bagel_non_essential_genes
    
    // If using default species-based path, apply species-specific path
    if (core_genes == '/opt2/bagel-2.0-115/CEGv2.txt') {
        core_genes = genes.core
    }
    if (noncore_genes == '/opt2/bagel-2.0-115/NEGv1.txt') {
        noncore_genes = genes.noncore
    }
    
    return [core: core_genes, noncore: noncore_genes]
}

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
    def bagel_genes = resolve_bagel_genes()
    """
    BAGEL.py bf \\
      -i ${fold_change} \\
      -o ${fold_change.getBaseName(2)}.bf \\
      -e ${bagel_genes.core} \\
      -n ${bagel_genes.noncore} \\
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
    def bagel_genes = resolve_bagel_genes()
    """
    BAGEL.py pr \\
      -i ${bayes_factor} \\
      -o ${bayes_factor.getBaseName(2)}.pr \\
      -e ${bagel_genes.core} \\
      -n ${bagel_genes.noncore}
    """

    stub:
    """
    touch ${bayes_factor.getBaseName(2)}.pr
    """
}
