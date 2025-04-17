#!/usr/bin/env nextflow

process FIND_MOTIFS {
    label 'process_medium'
    container 'ghcr.io/bf528/homer:latest'
    publishDir params.outdir 

    input:
    path(peaks)
    path(genome)


    output:
    path("*"), emit: results

    shell:
    """
    findMotifsGenome.pl $peaks $genome $params.outdir -size given
    """
}