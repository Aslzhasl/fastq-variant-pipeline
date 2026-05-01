#!/bin/bash
set -e

RAW_DIR="data/raw_fastq"
CLEAN_DIR="data/clean_fastq"
QC_DIR="results/qc"

mkdir -p "$CLEAN_DIR" "$QC_DIR"

SAMPLE=$1

if [ -z "$SAMPLE" ]; then
  echo "Usage: ./scripts/01_qc.sh sample_name"
  exit 1
fi

R1="${RAW_DIR}/${SAMPLE}_R1.fastq.gz"
R2="${RAW_DIR}/${SAMPLE}_R2.fastq.gz"

if [ ! -f "$R1" ] || [ ! -f "$R2" ]; then
  echo "FASTQ files not found:"
  echo "$R1"
  echo "$R2"
  exit 1
fi

echo "Running FastQC before trimming..."
fastqc "$R1" "$R2" -o "$QC_DIR"

echo "Running fastp for adapter trimming and quality filtering..."
fastp \
  -i "$R1" \
  -I "$R2" \
  -o "${CLEAN_DIR}/${SAMPLE}_R1.clean.fastq.gz" \
  -O "${CLEAN_DIR}/${SAMPLE}_R2.clean.fastq.gz" \
  --detect_adapter_for_pe \
  --qualified_quality_phred 20 \
  --length_required 30 \
  --html "${QC_DIR}/${SAMPLE}_fastp.html" \
  --json "${QC_DIR}/${SAMPLE}_fastp.json"

echo "Running FastQC after trimming..."
fastqc "${CLEAN_DIR}/${SAMPLE}_R1.clean.fastq.gz" "${CLEAN_DIR}/${SAMPLE}_R2.clean.fastq.gz" -o "$QC_DIR"

echo "QC and cleaning completed for sample: $SAMPLE"
