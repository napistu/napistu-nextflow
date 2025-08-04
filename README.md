# napistu-nextflow

Nextflow pipeline for building consensus pathway networks using Napistu.

## Quick Start

```bash
# Install Nextflow
curl -s https://get.nextflow.io | bash

# Run the pipeline
nextflow run . --species "Homo sapiens" --outdir results -profile docker

# Test run (reduced resources)
nextflow run . -profile test,docker
```

## Parameters

- `--species`: Target species (default: "Homo sapiens")
- `--outdir`: Output directory (default: "results")

## Outputs

- `sbml_dfs.pkl`: Final consensus model
- `napistu_graph.pkl`: Network graph representation  
- `precomputed_distances.parquet`: Distance matrix
- `human_consensus.tar.gz`: Packaged results

## Your Bugfix Scenario

```bash
# After fixing bug in napistu-py and releasing new container:
nextflow run . --container "your-registry/napistu-base:v1.2.1" -resume
```