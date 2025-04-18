#!/usr/bin/env nextflow

process PEAKCALL {
    label 'process_medium'
    container 'ghcr.io/bf528/macs3:latest'
    publishDir params.outdir 

    input:
    tuple val(name), path(ip), path(control)

    output:
    tuple val(name), path("*.narrowPeak")

    shell:
    """
    macs3 callpeak -t $ip -c $control -f BAM -g hs -n $name
    """
}