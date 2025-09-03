# napistu-nextflow

Nextflow pipeline for building consensus pathway networks using Napistu.

## Quick Start

### NextFlow

NextFlow runs in a Java Virtual Machine (JVM). For Homebrew installation:

```bash
brew install openjdk@17
echo 'export JAVA_HOME="/opt/homebrew/opt/openjdk@17"' >> ~/.zshrc
```

Once, Java is setup, you can install Nextflow with

```bash
# Install Nextflow
curl -s https://get.nextflow.io | bash
# Move nextflow to the directory that's already in your PATH
mv nextflow ~/.local/bin/
# Test it works
nextflow info
```

### Running

#### Setup Docker

- e.g., install and load `Docker Desktop`

#### Test Pathway (merging a handful of Reactome pathways)

```bash
nextflow run workflows/test_pathway.nf -profile test_pathway,docker
```

#### Multi-source consensus

```bash
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