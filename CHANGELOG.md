## CRISPIN development version

- Fix spelling of shared SIF directory on biowulf -- it is `/data/CCBR_Pipeliner/SIFs` with a lowercase "s" at the end. (#54, @kelly-sovacool)

## CRISPIN 1.0.1

- CRISPIN is now archived in Zenodo as v1.0.0. You can cite it with <https://doi.org/10.5281/zenodo.13844209>. (@kelly-sovacool)
- Fix bug in spooker handler. (#49, @kelly-sovacool)

## CRISPIN 1.0.0

- The pipeline name has been changed from CRUISE 🛳️ to CRISPIN 🍪. (#43, @kelly-sovacool)
- Run spooker on workflow completion.
- Print the recommended citation in bibtex format with `crispin --citation`. (#32, @kelly-sovacool)
- Fix citation information (#38, @kelly-sovacool)
- Improve the documentation website with a dropdown menu to select which version to view. The latest release is shown by default. (#45, @kelly-sovacool)

## CRUISE 0.1.1

### Bug fixes

- All scripts in the bin directory are now made executable for all users on biowulf (#25).
- Data directories are copied recursively during python package installation (#26).

## CRUISE 0.1.0

This is the first release of CRUISE 🎉

### New features

- Trim adapters with cutadapt.
- Run mageck count. (#9)
  - `mageck count` only runs if a count table **isn't** given.
- Optional: run mageck test and mle. (#9)
  - `mageck mle` only runs if a design matrix **is** given.
- Optional: run drugZ. (#10)
- Optional: run BAGEL2. (#11)
  - fc (fold change)
  - bf (bayes factor)
  - pr (precision recall)
- CLI (#16)
  - `cruise init` to initialize a project directory.
  - `cruise run`
    - `--mode slurm` to submit a slurm job to biowulf or frce.
    - `--main path/to/main.nf` to select a different local install of cruise, or specify the repo (`CCBR/CRUISE`) to get it from GitHub.
