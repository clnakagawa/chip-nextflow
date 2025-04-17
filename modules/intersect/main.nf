#!/usr/bin/env nextflow

process INTERSECT {
    label 'process_medium'
    container 'ghcr.io/bf528/bedtools:latest'
    publishDir params.outdir 

    input:
    tuple path(sample1), path(sample2)

    output:
    path("*.bed")

    shell:
    """
    bedtools intersect -a $sample1 -b $sample2 -f .5 -r > consensus_peaks.bed
    """
}