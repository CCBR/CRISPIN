process COUNT {
    label 'dotmatch'
    container "${params.container_dotmatch}"

    input:
        path(lib)
        val(ids)
        path(fastqs)

    output:
        path("*.count.txt"), emit: count
        path("*.summary.json"), emit: summary

    script:
    """
    dotmatch count \\
      --targets ${lib} \\
      --reads ${fastqs} \\
      --sample-label ${ids.join(',')} \\
      --target-start ${params.dotmatch_target_start} \\
      --target-length ${params.dotmatch_target_length} \\
      --k ${params.dotmatch_mismatch} \\
      --metric hamming \\
      --ambiguity-policy ${params.dotmatch_ambiguity_policy} \\
      --format mageck \\
      --out ${params.exp_name}.dotmatch.count.txt \\
      --summary ${params.exp_name}.dotmatch.summary.json
    """

    stub:
    """
    printf 'sgRNA\\tGene\\t%s\\n' '${ids.join('\\t')}' > ${params.exp_name}.dotmatch.count.txt
    printf '{}\\n' > ${params.exp_name}.dotmatch.summary.json
    """
}
