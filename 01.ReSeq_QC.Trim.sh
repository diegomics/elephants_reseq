source variables.cnf

echo ""
echo "=== STEP 1/3: FastQC ======================================"
echo ""

export LENGTH=$(ls $FQ_DIR/*R* | wc -l)
mkdir -p ${QC_DIR}/logs
FASTQC_JOB=$(sbatch --mail-user=${USER_MAIL} --mail-type=${MAIL_TYPE} --partition=${PARTITION} --qos=${QUEUE} --array=1-$LENGTH --output=${QC_DIR}/logs/%x.%A_%a.out --error=${QC_DIR}/logs/%x.%A_%a.err slurm/ReSeq_FastQC.job)
FASTQC_JOB_ID=$(echo $FASTQC_JOB | cut -d ' ' -f4)


echo "=== STEP 2/3: Fastp ======================================="

export LENGTH=$(ls $FQ_DIR/*R1* | wc -l)
mkdir -p ${TRIM_DIR}/logs
FASTP_JOB=$(sbatch --dependency=afterok:$FASTQC_JOB_ID --mail-user=${USER_MAIL} --mail-type=${MAIL_TYPE} --partition=${PARTITION} --qos=${QUEUE} --array=1-$LENGTH --output=${TRIM_DIR}/logs/%x.%A_%a.out --error=${TRIM_DIR}/logs/%x.%A_%a.err slurm/ReSeq_Fastp.job)
FASTP_JOB_ID=$(echo $FASTP_JOB | cut -d ' ' -f4)


echo "=== STEP 3/3: MultiQC ====================================="

MULTI_JOB=$(sbatch --dependency=afterok:${FASTQC_JOB_ID}:${FASTP_JOB_ID} --mail-user=${USER_MAIL} --mail-type=${MAIL_TYPE} --partition=${PARTITION} --qos=${QUEUE} --output=${QC_DIR}/logs/%x.%j.out --error=${QC_DIR}/logs/%x.%j.err slurm/ReSeq_MultiQC.job)
