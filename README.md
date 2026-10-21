# CRISPIN 🍪

**CRISP**r screen sequencing analysis pipel**IN**e

> formerly known as CRUISE

🚧 **This project is under active development. It is not yet ready for production use.** 🚧

[![build](https://github.com/CCBR/CRISPIN/actions/workflows/build.yml/badge.svg)](https://github.com/CCBR/CRISPIN/actions/workflows/build.yml)
[![docs](https://github.com/CCBR/CRISPIN/actions/workflows/docs-mkdocs.yml/badge.svg)](https://ccbr.github.io/CRISPIN/)
[![DOI](https://zenodo.org/badge/DOI/10.5281/zenodo.13844209.svg)](https://doi.org/10.5281/zenodo.13844209)
[![release](https://img.shields.io/github/v/release/CCBR/CRISPIN?color=blue&label=latest%20release)](https://github.com/CCBR/CRISPIN/releases/latest)

## Set up

CRISPIN is installed on the [Biowulf HPC](#biowulf).
For installation in other execution environments,
refer to the [docs](https://ccbr.github.io/crispin).

### Biowulf

CRISPIN is available on [Biowulf](https://hpc.nih.gov/) in the `ccbrpipeliner` module.
You'll first need to start an interactive session and create a directory from where you'll run crispin.

```sh
# start an interactive node
sinteractive --mem=2g --cpus-per-task=2 --gres=lscratch:200
# make a working directory for your project and go to it
mkdir -p /data/$USER/crisprseq
cd /data/$USER/crisprseq
# load the ccbrpipeliener module
module load ccbrpipeliner
```

## Usage

Initialize and run crispin with test data:

```sh
# copy the crispin config files to your current directory
crispin init
# preview the crispin jobs that will run with the test dataset
crispin run --mode local -profile test -preview
# launch a crispin run on slurm with the test dataset
crispin run --mode slurm -profile test,biowulf
```

To run CRISPIN on your own data, you'll need to create a sample sheet.
Take a look at the example:
[assets/samplesheet_test_biowulf.csv](https://github.com/CCBR/CRISPIN/tree/main/assets/samplesheet_test_biowulf.csv).

You'll also need to select an appropriate library for your dataset.
CRISPIN is bundled with several libraries in [assets/lib](https://github.com/CCBR/CRISPIN/tree/main/assets/lib),
or you can download your own.
Once you've created a samplesheet with paths to your fastq files,
run crispin with the `--input` option to specify the path to your sample sheet
and `--library` for the path to your library file:

```sh
crispin run --mode slurm -profile biowulf --input samplesheet.csv --library assets/lib/yusa_library.csv
```

### Optional DotMatch guide counting

MAGeCK counting remains the default. For a fixed-length guide library and a
known post-trimming guide window, the count step can use DotMatch instead:

```sh
crispin run --mode slurm -profile biowulf \
  --input samplesheet.csv \
  --library assets/lib/yusa_library.csv \
  --count_method dotmatch \
  --dotmatch_target_start 23 \
  --dotmatch_target_length 19
```

The DotMatch count output is MAGeCK-compatible. Assignment summaries are kept
alongside the count output, and the `radius` ambiguity policy is conservative
by default. Confirm the read window and review the summary before treating
rescued assignments as final results.

## Help & Contributing

Come across a **bug**? Open an [issue](https://github.com/CCBR/CRISPIN/issues) and include a minimal reproducible example.

Have a **question**? Ask it in [discussions](https://github.com/CCBR/CRISPIN/discussions).

Want to **contribute** to this project? Check out the [contributing guidelines](https://github.com/CCBR/CRISPIN/tree/main/docs/CONTRIBUTING.md).

## References

This repo was originally generated from the [CCBR Nextflow Template](https://github.com/CCBR/CCBR_NextflowTemplate).
The template takes inspiration from nektool[^1] and the nf-core template.
If you plan to contribute your pipeline to nf-core, don't use this template -- instead follow nf-core's instructions[^2].

[^1]: nektool https://github.com/beardymcjohnface/nektool

[^2]: instructions for nf-core pipelines https://nf-co.re/docs/contributing/tutorials/creating_with_nf_core
