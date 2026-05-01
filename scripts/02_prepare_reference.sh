#!/bin/bash
set -e

REF_DIR="reference"
mkdir -p "$REF_DIR"

REF_GZ="${REF_DIR}/chr22.fa.gz"
REF_FA="${REF_DIR}/chr22.fa"

echo "Downloading hg38 chromosome 22 reference..."

if [ ! -f "$REF_GZ" ] && [ ! -f "$REF_FA" ]; then
  wget -O "$REF_GZ" http://hgdownload.soe.ucsc.edu/goldenPath/hg38/chromosomes/chr22.fa.gz
fi

if [ ! -f "$REF_FA" ]; then
  gunzip -c "$REF_GZ" > "$REF_FA"
fi

echo "Indexing reference with BWA..."
bwa index "$REF_FA"

echo "Indexing reference with samtools..."
samtools faidx "$REF_FA"

echo "Reference preparation completed:"
ls -lh "$REF_DIR"
