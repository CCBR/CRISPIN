
process BAGEL_FOLD_CHANGE {
    tag { meta.control }
    container "${params.containers.bagel}"
    label 'process_single'

    input:
        tuple val(meta), path(count)

    output:
        tuple val(meta), path("*.foldchange"), emit: fc
        tuple val(meta), path("*.normed_readcount"), emit: count_norm

    script:
    """
    BAGEL.py fc \\
      -i ${count} \\
      -o ${count.getBaseName(2)} \\
      -c ${meta.control}
    """

    stub:
    """
    for ext in foldchange normed_readcount; do
        touch ${count.getBaseName(2)}.\$ext
    done
    echo ${task.container} > output.txt
    """
}
