#!/usr/bin/env python

process ANNOTATE_PEAKS {
    label 'process_medium'
    container 'ghcr.io/bf528/homer:latest'
    publishDir params.outdir 

    input:
    path(peaks)
    path(genome)
    path(gtf)

    output:
    path("annotated_peaks.txt")

    shell:
    """
    annotatePeaks.pl $peaks $genome -gtf $gtf > annotated_peaks.txt
    """
}