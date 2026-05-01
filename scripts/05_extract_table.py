import sys
import gzip
from pathlib import Path

import pandas as pd


def open_vcf(path):
    path = str(path)
    if path.endswith(".gz"):
        return gzip.open(path, "rt")
    return open(path, "r")


def parse_info_field(info_text):
    info = {}
    for item in info_text.split(";"):
        if "=" in item:
            key, value = item.split("=", 1)
            info[key] = value
        else:
            info[item] = True
    return info


def parse_vcf(vcf_path, output_csv):
    rows = []

    with open_vcf(vcf_path) as f:
        for line in f:
            if line.startswith("#"):
                continue

            parts = line.strip().split("\t")
            if len(parts) < 10:
                continue

            chrom, pos, variant_id, ref, alt, qual, filt, info_text, fmt, sample = parts[:10]

            info = parse_info_field(info_text)

            fmt_keys = fmt.split(":")
            sample_values = sample.split(":")
            sample_dict = dict(zip(fmt_keys, sample_values))

            genotype = sample_dict.get("GT", ".")
            depth = info.get("DP", "")
            mapping_quality = info.get("MQ", "")
            allele_count = info.get("AC", "")
            allele_number = info.get("AN", "")

            rows.append({
                "chromosome": chrom,
                "position": int(pos),
                "id": variant_id,
                "ref": ref,
                "alt": alt,
                "quality": float(qual) if qual != "." else None,
                "filter": filt,
                "genotype": genotype,
                "depth": depth,
                "mapping_quality": mapping_quality,
                "allele_count": allele_count,
                "allele_number": allele_number,
                "gene": "",
                "variant_effect": "",
                "protein_effect": "",
                "clinical_significance": "",
                "clinvar_id": "",
                "omim_id": "",
                "acmg_classification": "",
                "interpretation_note": "Requires annotation with VEP/SnpEff and clinical database review"
            })

    df = pd.DataFrame(rows)

    output_csv = Path(output_csv)
    output_csv.parent.mkdir(parents=True, exist_ok=True)
    df.to_csv(output_csv, index=False)

    print(f"Saved variant table: {output_csv}")
    print(f"Total variants: {len(df)}")


if __name__ == "__main__":
    if len(sys.argv) != 3:
        print("Usage: python3 scripts/05_extract_table.py input.vcf.gz output.csv")
        sys.exit(1)

    parse_vcf(sys.argv[1], sys.argv[2])
