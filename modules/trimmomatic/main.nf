#!/usr/bin/env nextflow

process TRIMMOMATIC {
    container "ghcr.io/bf528/trimmomatic:latest"
    label "process_high"
    publishDir params.outdir

    input: 
    tuple val(sample), path(fastq)
    path(adapters)

    output:
    tuple val("${sample}"), path("${sample}_trimmed.fastq.gz"), emit: trimmed 
    path("*.log"), emit: log

    shell:
    """
    trimmomatic SE $fastq ${sample}_trimmed.fastq.gz ILLUMINACLIP:${adapters}:2:30:10 LEADING:3 TRAILING:3 SLIDINGWINDOW:4:15 2> ${sample}_trim.log
    """
}