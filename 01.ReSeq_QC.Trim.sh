# Only change and check these variables: #######################################################
export FQ_DIR="~/Elephant_project/ReSeq/genomic_data/novaseq"
export QC_DIR="${FQ_DIR}/QC"
export TRIM_DIR="${FQ_DIR}/trimmed"
export LENGTH=$(ls $FQ_DIR/*R1* | wc -l)
################################################################################################


echo ""
echo "=== STEP 1/3: FastQC ======================================"
echo ""

mkdir -p $QC_DIR
FASTQC_JOB=$(sbatch --array=1-$LENGTH --output=${QC_DIR}/%x.%A_%a.out --error=${QC_DIR}/%x.%A_%a.err ReSeq_FastQC.job)
FASTQC_JOB_ID=$(echo $FASTQC_JOB | cut -d ' ' -f4)


echo "=== STEP 2/3: Fastp     ======="

mkdir -p $TRIM_DIR
FASTP_JOB=$(sbatch --dependency=afterok:$FASTQC_JOB_ID --array=1-$LENGTH --output=${TRIM_DIR}/%x.%A_%a.out --error=${TRIM_DIR}/%x.%A_%a.err ReSeq_Fastp.job)
FASTP_JOB_ID=$(echo $FASTP_JOB | cut -d ' ' -f4)


echo "=== STEP 3/3: MultiQC   ======="

MULTI_JOB=$(sbatch --dependency=afterok:${FASTQC_JOB_ID}:${FASTP_JOB_ID} --output=${QC_DIR}/%x.%j.out --error=${QC_DIR}
