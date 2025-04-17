#!/usr/bin/env nextflow

process PLOT_PROFILE {
    label 'process_low'
    container 'ghcr.io/bf528/deeptools:latest'
    publishDir params.outdir, mode: 'copy'

    input:
    path(matrix)

    output:
    path("*.png")

    shell:
    """
    plotProfile -m $matrix -o profilePlot.png
    """
}