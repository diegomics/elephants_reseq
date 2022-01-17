# elephants_reseq
:elephant: :elephant: :elephant: :elephant: :elephant: :elephant: :elephant: :elephant: :elephant: :elephant: :elephant: :elephant: :elephant: :elephant: :elephant: :elephant: :elephant: :elephant: :elephant: :elephant: :elephant: :elephant: :elephant: :elephant: :elephant: :elephant: :elephant: :elephant: :elephant: :elephant:
:elephant: :elephant: :elephant: :elephant: :elephant: :elephant: :elephant: :elephant: :elephant: :elephant: :elephant: :elephant: :elephant: :elephant: :elephant: :elephant: :elephant: :elephant: :elephant: :elephant: :elephant: :elephant: :elephant: :elephant: :elephant: :elephant: :elephant: :elephant: :elephant: :elephant:
:elephant: :elephant: :elephant: :elephant: :elephant: :elephant: :elephant: :elephant:

#### Pipeline for analysis related to the whole-genome resequencing of 68 [timber Asian elephants from Myanmar](https://elephant-project.science)

## Requirements:
* [Slurm](https://slurm.schedmd.com)
* [Singularity](https://sylabs.io)
* [Conda](https://docs.conda.io)

## Installation:
```bash
git clone https://github.com/diegomics/elephants_reseq
cd elephants_reseq
bash install_dependencies.sh
```
## Runnning the pipline:
* Edit `variables.cnf` file with the respective paths, values and parameters.
1) Run QC and filtering on Illumina NovaSeq paired-end _fastq_ files
```bash
bash 01.ReSeq_QC.Trim.sh
```
2) Index, map and deduplicate samples reads against a reference
```bash
bash 02.ReSeq_Map.Dedup.sh 
```
3) Call variants of the sampes, merge and filter 
```bash
bash 03.ReSeq_VarCall.sh
```
