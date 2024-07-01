

process MAGECK_VISPR { // TODO
    label 'vispr'
    container "${params.containers.vispr}"

    output:
        path("output.txt")

    script:
    """
    uname -a >> output.txt
    which vispr >> output.txt
    """
}
