# Clinical Variant Summary: sample1

## Project

FASTQ germline variant calling pipeline for human sequencing data.

## Input data

- Sample name: sample1
- Data type: paired-end FASTQ
- Source accession: SRR098401 subset
- Number of reads used: 20,000 spots
- Reference used for demo: hg38 chromosome 22
- Target full reference for production: GRCh38/hg38

## Pipeline steps

1. FASTQ quality control using FastQC.
2. Read trimming and filtering using fastp.
3. Alignment to reference genome using BWA-MEM.
4. BAM sorting and indexing using samtools.
5. Germline variant calling using bcftools.
6. Variant filtering by quality and depth.
7. Variant table extraction for clinical interpretation.

## Generated files

- QC reports: `results/qc/`
- Clean FASTQ: `data/clean_fastq/`
- BAM file: `results/bam/sample1.sorted.bam`
- BAM index: `results/bam/sample1.sorted.bam.bai`
- Raw VCF: `results/vcf/sample1.raw.vcf.gz`
- Filtered VCF: `results/vcf/sample1.filtered.vcf.gz`
- Variant table: `results/annotation/sample1_variants_table.csv`

## Variant calling result

The filtered VCF contains 11 variants on chromosome 22.

## Clinical interpretation note

This output is not a final clinical diagnosis. For clinical interpretation, variants must be annotated using VEP or SnpEff and reviewed against clinical databases such as ClinVar, OMIM, and ACMG guidelines.

## Limitations

- The current run uses a small subset of reads for demonstration.
- The demo reference is chromosome 22 only, not the full GRCh38 genome.
- Clinical interpretation requires validated annotation databases and expert review.
