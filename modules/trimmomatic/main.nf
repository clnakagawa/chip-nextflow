#!/usr/bin/env nextflow

process TRIMMOMATIC {
    container "ghcr.io/bf528/trimmomatic:latest"
    label "process_single"
    publishDir params.outdir

    input: 
    tuple val(sample), path(fastq)

    output:
    tuple val("${sample}"), path("${sample}_trimmed.fastq.gz") 

    shell:
    """
    trimmomatic SE -threads $task.cpus $fastq ${sample}_trimmed.fastq.gz ILLUMINACLIP:TruSeq3-SE:2:30:10 LEADING:3 TRAILING:3 SLIDINGWINDOW:4:15 MINLEN:36
    """


}