#!/usr/bin/env nextflow

process FIND_MOTIFS {
    label 'process_high'
    container 'ghcr.io/bf528/homer:latest'
    publishDir params.outdir 

    input:
    path(peaks)
    path(genome)


    output:
    path("homermotifs/"), emit: results

    shell:
    """
    findMotifsGenome.pl $peaks $genome homermotifs/ -size 200 -mask
    """
}