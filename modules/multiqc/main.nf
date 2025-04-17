#!/usr/bin/env nextflow

process MULTIQC {
    container "ghcr.io/bf528/multiqc:latest"
    label "process_low"
    publishDir params.outdir

    input:
    path("*")

    output:
    path "*.html", emit: report

    shell
    """
    multiqc .
    """
}