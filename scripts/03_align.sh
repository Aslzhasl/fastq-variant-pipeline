#!/bin/bash
set -e

SAMPLE=$1

if [ -z "$SAMPLE" ]; then
  echo "Usage: ./scripts/03_align.sh sample_name"
  exit 1
fi

REF="reference/chr22.fa"
CLEAN_DIR="data/clean_fastq"
BAM_DIR="results/bam"

mkdir -p "$BAM_DIR"

R1="${CLEAN_DIR}/${SAMPLE}_R1.clean.fastq.gz"
R2="${CLEAN_DIR}/${SAMPLE}_R2.clean.fastq.gz"

if [ ! -f "$REF" ]; then
  echo "Reference not found: $REF"
  echo "Run: ./scripts/02_prepare_reference.sh"
  exit 1
fi

if [ ! -f "$R1" ] || [ ! -f "$R2" ]; then
  echo "Clean FASTQ files not found:"
  echo "$R1"
  echo "$R2"
  exit 1
fi

echo "Aligning reads with BWA-MEM..."

bwa mem -t 4 "$REF" "$R1" "$R2" | \
samtools sort -@ 4 -o "${BAM_DIR}/${SAMPLE}.sorted.bam"

echo "Indexing BAM..."
samtools index "${BAM_DIR}/${SAMPLE}.sorted.bam"

echo "Alignment completed."
echo "BAM: ${BAM_DIR}/${SAMPLE}.sorted.bam"
echo "BAI: ${BAM_DIR}/${SAMPLE}.sorted.bam.bai"

echo "Alignment statistics:"
samtools flagstat "${BAM_DIR}/${SAMPLE}.sorted.bam" > "${BAM_DIR}/${SAMPLE}.flagstat.txt"
cat "${BAM_DIR}/${SAMPLE}.flagstat.txt"
