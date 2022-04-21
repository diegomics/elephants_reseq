source variables.cnf

echo ""
echo "=== STEP 1/2: Calling variants ===================================="
echo ""

LENGTH=$(ls ${OUT_DIR}/2_bam_dedup/*.rmd.bam | wc -l)
mkdir -p "${OUT_DIR}/4_deepvar/logs"
DEEPVAR_JOB=$(sbatch --mail-user=${USER_MAIL} --mail-type=${MAIL_TYPE} --partition=${PARTITION} --qos=${QUEUE} --array=1-${LENGTH} --output=${OUT_DIR}/4_deepvar/logs/%x.%A_%a.out --error=${OUT_DIR}/4_deepvar/logs/%x.%A_%a.err slurm/ReSeq_DeepVariant.job)
DEEPVAR_JOB_ID=$(echo $DEEPVAR_JOB | cut -d ' ' -f4)

echo ""
echo "=== STEP 2/2: Merge gVCF files ===================================="
echo ""

MERGE_JOB=$(sbatch --dependency=afterok:$DEEPVAR_JOB_ID --mail-user=${USER_MAIL} --mail-type=${MAIL_TYPE} --partition=${PARTITION} --qos=${QUEUE} --output=${OUT_DIR}/4_deepvar/logs/%x.%j.out --error=${OUT_DIR}/4_deepvar/logs/%x.%j.err slurm/ReSeq_GLnexus.job)
#MERGE_JOB_ID=$(echo $MERGE_JOB | cut -d ' ' -f4)
