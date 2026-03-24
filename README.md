# gb-utils

Various GenBank utility scripts for retrieving gene data from NCBI.

## Requirements

- `curl` — downloads data from the internet (pre-installed on most systems)
- `jq` — parses JSON responses

Install `jq`:

```bash
brew install jq        # Mac
sudo apt install jq    # Linux
```

## Scripts

### `gb_dataset.sh`

Fetches a deduplicated list of genes for a given species from the NCBI Datasets API and saves the results as a CSV file.

#### Usage

```bash
bash scripts/gb_dataset.sh <species_name> [output_file]
```

- `species_name` — scientific name using underscores instead of spaces (required)
- `output_file` — custom output filename (optional, defaults to `gene_report.csv`)

#### Examples

```bash
# Monarch butterfly (default output: danaus_plexippus_gene_report.csv)
bash scripts/gb_dataset.sh bunomys_penitus

# Green lizard with custom output filename
bash scripts/gb_dataset.sh timon_lepidus my_output.csv
```

#### Output

A CSV file named `{species}_gene_report.csv` with the following columns:

| Column | Description |
| --- | --- |
| `symbol` | Short gene name (e.g. COX1, BRCA1) |
| `type` | Gene type (e.g. PROTEIN_CODING, PSEUDO, ncRNA) |
| `description` | Full gene name or function |

## Project Structure

```bash
.
├── LICENSE
├── README.md
└── scripts
    └── gb_dataset.sh
```
