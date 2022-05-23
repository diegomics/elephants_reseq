conda env create -f env.yml

source variables.cnf
${SINGULARITY_LOAD}
BIN_VERSION="1.3.0"
singularity pull docker://google/deepvariant:"${BIN_VERSION}"
singularity pull docker://ghcr.io/dnanexus-rnd/glnexus:v1.4.1
