
process COUNT {
    label 'mageck'
    container "${params.container_mageck}"

    input:
        file(lib)
        val(ids)
        path(fastqs)

    output:
      path("*.count.txt"), emit: count
      path("*.count_normalized.txt"), emit: count_norm
      path("*.countsummary.txt"), emit: count_sum

    script:
    """
    mageck count \\
      -l ${lib} \\
      --fastq ${fastqs} \\
      --sample-label ${ids.join(',')} \\
      -n ${params.exp_name}
    """

    stub:
    """
    for ext in count count_normalized countsummary; do
        touch ${params.exp_name}.\${ext}.txt
    done
    uname -a > output.txt
    echo ${task.container} >> output.txt
    """

}

process TEST {
    label 'mageck'
    container "${params.container_mageck}"

    input:
      path(count)
      val(treatment)
      val(control)

    output:
      path("*.gene_summary.txt"), emit: gene
      path("*.sgrna_summary.txt"), emit: sgrna

    script:
    """
    mageck test \\
      -k ${count} \\
      -t ${treatment.join(',')} \\
      -c ${control.join(',')} \\
      -n ${count.getBaseName(2)}
    """

    stub:
    """
    for ext in gene sgrna; do
        touch ${count.getBaseName(2)}.\${ext}_summary.txt
    done
    """
}

process MLE {
    label 'mageck'
    label 'process_higher'
    container "${params.container_mageck}"

    input:
        path(count)
        path(design)

    output:
        path("*.gene_summary.txt"), emit: gene
        path("*.sgrna_summary.txt"), emit: sgrna

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

process VISPR { // TODO
    label 'vispr'
    container "${params.container_vispr}"

    output:
        path("output.txt")

    script:
    """
    uname -a >> output.txt
    which vispr >> output.txt
    """
}
