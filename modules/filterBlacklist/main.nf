#!/usr/bin/env nextflow

process FILTER_BLACKLIST {
    label 'process_medium'
    container 'ghcr.io/bf528/bedtools:latest'
    publishDir params.outdir 

    input:
    path(peaks)
    path(blacklist)

    output:
    path("*.bed")

    shell:
    """
    bedtools intersect -a $peaks -b $blacklist -v > filtered_peaks.bed
    """
}