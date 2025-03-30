#!/usr/bin/env nextflow

process SAMTOOLS_FLAGSTAT {
    label 'process_high'
    container 'ghcr.io/bf528/samtools:latest'
    publishDir params.outdir 

    input: 
    tuple val(sample), path(bam) 

    output:
    path("*flagstat.txt"), emit: flagstat

    shell:
    """ 
    samtools flagstat -@ $task.cpus -O tsv $bam > ${sample}.flagstat.txt
    """
}