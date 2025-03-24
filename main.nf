#!/usr/bin/env nextflow

include {FASTQC} from "./modules/fastqc"
include {TRIMMOMATIC} from "./modules/trimmomatic"
include {BOWTIE2_BUILD} from "./modules/b2build"
include {BOWTIE2_ALIGN} from "./modules/b2align"

workflow {
    // get channel of fastq files from samplesheet
    Channel.fromPath(params.subset_samplesheet)
    | splitCsv(header: true)
    | map { row -> tuple(row.name, file(row.path))}
    | set { fa_ch }

    FASTQC(fa_ch)
    TRIMMOMATIC(fa_ch) 

    BOWTIE2_BUILD(params.genome)
    BOWTIE2_ALIGN(TRIMMOMATIC.out, BOWTIE2_BUILD.out.index, BOWTIE2_BUILD.out.name)
}