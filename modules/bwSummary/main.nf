#!/usr/bin/env nextflow

process BW_SUMMARY {
    label 'process_medium'
    container 'ghcr.io/bf528/deeptools:latest'
    publishDir params.outdir, mode: 'copy'

    input:
    path("*")

    output:
    path("*.npz"), emit: summary

    shell:
    """
    multiBigwigSummary bins -b *.bw -o results.npz
    """

}