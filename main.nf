#!/usr/bin/env nextflow

include {FASTQC} from "./modules/fastqc"
include {TRIMMOMATIC} from "./modules/trimmomatic"
include {BOWTIE2_BUILD} from "./modules/b2build"
include {BOWTIE2_ALIGN} from "./modules/b2align"
include {SAMTOOLS_SORT} from "./modules/samtoolsSort"
include {SAMTOOLS_INDEX} from "./modules/samtoolsInd"
include {SAMTOOLS_FLAGSTAT} from "./modules/samtoolsFstat"
include {MULTIQC} from "./modules/multiqc" 
include {BAMCOVERAGE} from "./modules/bamcoverage"
include {BW_SUMMARY} from "./modules/bwSummary"
include {CORR_PLOT} from "./modules/plotCorr"
include {PEAKCALL} from "./modules/macs3"
include {INTERSECT} from "./modules/intersect"
include {FILTER_BLACKLIST} from "./modules/filterBlacklist"
include {ANNOTATE_PEAKS} from "./modules/annotatePeaks"
include {COMPUTE_MATRIX} from "./modules/computeMatrix"
include {PLOT_PROFILE} from "./modules/plotProfile"
include {FIND_MOTIFS} from "./modules/motifFinding"

workflow {
    // get channel of fastq files from samplesheet
    Channel.fromPath(params.samplesheet)
    | splitCsv(header: true)
    | map { row -> tuple(row.name, file(row.path))}
    | set { fa_ch }

    // QC on raw fastqs
    FASTQC(fa_ch)

    // trim fastqs
    TRIMMOMATIC(fa_ch, params.adapter_fa) 

    // build index with bowtie on referece genome
    // align reads to bowtie2 index
    BOWTIE2_BUILD(params.genome)
    BOWTIE2_ALIGN(TRIMMOMATIC.out.trimmed, BOWTIE2_BUILD.out.index, BOWTIE2_BUILD.out.name) 

    // use modules from lab 7 to sort and index bam files
    SAMTOOLS_SORT(BOWTIE2_ALIGN.out.bam)
    SAMTOOLS_INDEX(SAMTOOLS_SORT.out.sorted)

    // run flagstat on sorted bams
    SAMTOOLS_FLAGSTAT(SAMTOOLS_SORT.out.sorted) 

    // run multiqc on fastqc, trim logs, and flagstat output
    SAMTOOLS_FLAGSTAT.out.flagstat 
    | mix(FASTQC.out.zip, TRIMMOMATIC.out.log)
    | collect( sort: true )
    | set { multiqc_ch } 

    MULTIQC(multiqc_ch)

    // run deeptools bamcoverage 
    BAMCOVERAGE(SAMTOOLS_INDEX.out.index) 

    // summary of bigwig files
    BAMCOVERAGE.out.bigwig 
    | map { it -> it[1] }
    | collect( sort: true )
    | set { bw_ch }

    BW_SUMMARY(bw_ch)

    // plot correlation
    CORR_PLOT(BW_SUMMARY.out.summary)

    // peak calling with MAC3
    SAMTOOLS_SORT.out.sorted
    | map { meta, path -> tuple(meta.replaceFirst(/.*?_/, ''), path) }
    | groupTuple()
    | map {meta, paths -> tuple(meta, *paths)}
    | set { macs_ch }

    macs_ch 
    | view()

    PEAKCALL(macs_ch)

    PEAKCALL.out 
    | map { it -> it[1] }
    | collect( sort: true ) 
    | set { peak_ch }

    INTERSECT(peak_ch)
    FILTER_BLACKLIST(INTERSECT.out, params.blacklist)
    ANNOTATE_PEAKS(FILTER_BLACKLIST.out, params.genome, params.gtf)

    bw_ch
    | map { file_list -> file_list.findAll { it.name.contains('IP_') }}
    | set { cm_ch }

    COMPUTE_MATRIX(cm_ch, params.refbed)
    PLOT_PROFILE(COMPUTE_MATRIX.out)

    FIND_MOTIFS(FILTER_BLACKLIST.out, params.genome)
}