#!/usr/bin/env bash
# =============================================================
# gene_report.sh
# Fetches a list of genes for a given species from NCBI and
# saves the results as a CSV file.
#
# Requirements:
#   - curl  (downloads data from the internet)
#   - jq    (parses JSON responses)
#     Install: brew install jq        (Mac)
#              sudo apt install jq    (Linux)
#
# Usage:
#   bash gene_report.sh danaus_plexippus
#   bash gene_report.sh timon_lepidus out.csv
#
# Output CSV columns:
#   symbol      - short gene name (e.g. COX1, BRCA1)
#   type        - gene type (e.g. PROTEIN_CODING, PSEUDO, NCRNA)
#   description - full gene name/function
# =============================================================

set -e

if [[ -z "$1" ]]; then
  echo "Error: No species name provided."
  echo "Usage: bash gene_report.sh danaus_plexippus"
  exit 1
fi

SPECIES_SLUG="$1"
OUTPUT="${2:-gene_report.csv}"

# Convert underscores to spaces for the API query
SPECIES="${SPECIES_SLUG//_/ }"

# Encode spaces as %20 for the URL
ENCODED="${SPECIES// /%20}"

OUTFILE="${SPECIES_SLUG}_${OUTPUT}"

echo "Fetching gene report for: $SPECIES"

RESPONSE=$(curl -s "https://api.ncbi.nlm.nih.gov/datasets/v2/gene/taxon/${ENCODED}/dataset_report?page_size=1000")

if echo "$RESPONSE" | jq -e '.reports | length == 0' > /dev/null 2>&1; then
  echo "No genes found for: $SPECIES"
  exit 0
fi

if echo "$RESPONSE" | jq -e '.errors' > /dev/null 2>&1; then
  echo "API error for: $SPECIES"
  echo "$RESPONSE" | jq '.errors'
  exit 1
fi

echo "$RESPONSE" \
  | jq -r '.reports[].gene | [.symbol // "N/A", .type // "N/A", .description // "N/A"] | @csv' \
  | (echo "symbol,type,description" && cat) \
  > "$OUTFILE"

echo "Done! Results saved to: $OUTFILE"

