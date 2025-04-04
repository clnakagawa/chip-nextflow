#!/usr/bin/env nextflow

process CORR_PLOT {
    label 'process_medium'
    container 'ghcr.io/bf528/deeptools:latest'
    publishDir params.outdir, mode: 'copy'

    input:
    path(summary)

    output:
    path("*.png")

    shell:
    """
    plotCorrelation -in $summary -c spearman -p heatmap -o plot.png
    """

}