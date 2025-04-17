#!/usr/bin/env nextflow

process SAMTOOLS_FLAGSTAT {
    label 'process_low'
    container 'ghcr.io/bf528/samtools:latest'
    publishDir params.outdir 

    input: 
    tuple val(sample), path(bam) 

    output:
    path("*flagstat.txt"), emit: flagstat

    shell:
    """ 
    samtools flagstat -@ $task.cpus $bam > ${sample}_flagstat.txt
    """
}