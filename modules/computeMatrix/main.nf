#!/usr/bin/env nextflow

process COMPUTE_MATRIX {
    label 'process_high'
    container 'ghcr.io/bf528/deeptools:latest'
    publishDir params.outdir, mode: 'copy'

    input:
    tuple path(bw1), path(bw2)
    path(refbed)

    output:
    path("*.gz")

    shell:
    """
    computeMatrix scale-regions -S $bw1 $bw2 -R $refbed -b 2000 -o bwmatrix.gz -p $task.cpus
    """
}