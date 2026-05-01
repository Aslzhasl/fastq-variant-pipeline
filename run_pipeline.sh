#!/bin/bash
set -e

SAMPLE=$1

if [ -z "$SAMPLE" ]; then
  echo "Usage: ./run_pipeline.sh sample_name"
  echo "Example: ./run_pipeline.sh sample1"
  exit 1
fi

echo "=========================================="
echo "Running FASTQ variant calling pipeline"
echo "Sample: $SAMPLE"
echo "=========================================="

echo ""
echo "Step 1: FASTQ quality control and trimming"
./scripts/01_qc.sh "$SAMPLE"

echo ""
echo "Step 2: Reference preparation"
./scripts/02_prepare_reference.sh

echo ""
echo "Step 3: Alignment to reference genome"
./scripts/03_align.sh "$SAMPLE"

echo ""
echo "Step 4: Germline variant calling"
./scripts/04_variant_calling.sh "$SAMPLE"

echo ""
echo "Step 5: Variant table extraction"
python3 scripts/05_extract_table.py \
  "results/vcf/${SAMPLE}.filtered.vcf.gz" \
  "results/annotation/${SAMPLE}_variants_table.csv"

echo ""
echo "Pipeline completed successfully for sample: $SAMPLE"

echo ""
echo "Generated outputs:"
echo "- QC reports: results/qc/"
echo "- Clean FASTQ: data/clean_fastq/"
echo "- BAM/BAI: results/bam/"
echo "- VCF files: results/vcf/"
echo "- Variant table: results/annotation/${SAMPLE}_variants_table.csv"
