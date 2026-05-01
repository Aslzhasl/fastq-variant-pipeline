#!/bin/bash
set -e

SAMPLE=$1

if [ -z "$SAMPLE" ]; then
  echo "Usage: ./scripts/04_variant_calling.sh sample_name"
  exit 1
fi

REF="reference/chr22.fa"
BAM="results/bam/${SAMPLE}.sorted.bam"
VCF_DIR="results/vcf"

mkdir -p "$VCF_DIR"

if [ ! -f "$REF" ]; then
  echo "Reference not found: $REF"
  exit 1
fi

if [ ! -f "$BAM" ]; then
  echo "BAM file not found: $BAM"
  exit 1
fi

echo "Calling variants with bcftools..."

bcftools mpileup -Ou -f "$REF" "$BAM" | \
bcftools call -mv -Oz -o "${VCF_DIR}/${SAMPLE}.raw.vcf.gz"

echo "Indexing raw VCF..."
tabix -p vcf "${VCF_DIR}/${SAMPLE}.raw.vcf.gz"

echo "Filtering variants..."

bcftools filter \
  -e 'QUAL<20 || DP<5' \
  -Oz \
  -o "${VCF_DIR}/${SAMPLE}.filtered.vcf.gz" \
  "${VCF_DIR}/${SAMPLE}.raw.vcf.gz"

echo "Indexing filtered VCF..."
tabix -p vcf "${VCF_DIR}/${SAMPLE}.filtered.vcf.gz"

echo "Variant calling completed."
echo "Raw VCF: ${VCF_DIR}/${SAMPLE}.raw.vcf.gz"
echo "Filtered VCF: ${VCF_DIR}/${SAMPLE}.filtered.vcf.gz"

echo "Variant count:"
bcftools view -H "${VCF_DIR}/${SAMPLE}.filtered.vcf.gz" | wc -l

