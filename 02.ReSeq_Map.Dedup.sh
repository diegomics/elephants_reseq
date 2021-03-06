source variables.cnf

echo ""
echo "=== STEP 1/1: Indexing ===================================="
echo ""

mkdir -p "${OUT_DIR}/0_idx/logs"
INDEX_JOB=$(sbatch --mail-user=${USER_MAIL} --mail-type=${MAIL_TYPE} --partition=${PARTITION} --qos=${QUEUE} --output=${OUT_DIR}/0_idx/logs/%x.%j.out --error=${OUT_DIR}/0_idx/logs/%x.%j.err slurm/ReSeq_index.job)
INDEX_JOB_ID=$(echo ${INDEX_JOB} | cut -d ' ' -f4)


echo ""
echo "=== STEP 2/2: Mapping/Sorting ============================="
echo ""

LENGTH=$(ls ${TRIM_DIR}/*R1*.fq.gz | wc -l)
mkdir -p "${OUT_DIR}/1_bam_sort/logs"
mkdir -p "${OUT_DIR}/5_bam_eval"
MAP_JOB=$(sbatch --dependency=afterok:${INDEX_JOB_ID} --mail-user=${USER_MAIL} --mail-type=${MAIL_TYPE} --partition=${PARTITION} --qos=${QUEUE} --array=1-${LENGTH} --output=${OUT_DIR}/1_bam_sort/logs/%x.%A_%a.out --error=${OUT_DIR}/1_bam_sort/logs/%x.%A_%a.err slurm/ReSeq_Map.Sort.job)
MAP_JOB_ID=$(echo ${MAP_JOB} | cut -d ' ' -f4)


echo ""
echo "=== STEP 3/4: Deduplication  =============================="
echo ""

LENGTH=$(ls ${TRIM_DIR}/*R1*.fq.gz | wc -l)
mkdir -p "${OUT_DIR}/2_bam_dedup/logs"
DEDUP_JOB=$(sbatch --dependency=afterok:${INDEX_JOB_ID}:${MAP_JOB_ID} --mail-user=${USER_MAIL} --mail-type=${MAIL_TYPE} --partition=${PARTITION} --qos=${QUEUE} --array=1-${LENGTH} --output=${OUT_DIR}/2_bam_dedup/logs/%x.%A_%a.out --error=${OUT_DIR}/2_bam_dedup/logs/%x.%A_%a.err slurm/ReSeq_Dedup.job)
DEDUP_JOB_ID=$(echo ${DEDUP_JOB} | cut -d ' ' -f4)


echo ""
echo "=== STEP 4/4:: Filter masked regions  ====+============="
echo ""

LENGTH=$(ls ${TRIM_DIR}/*R1*.fq.gz | wc -l)
mkdir -p "${OUT_DIR}/3_bam_masked/logs"
FILT_JOB=$(sbatch --dependency=afterok:${DEDUP_JOB_ID} --mail-user=${USER_MAIL} --mail-type=${MAIL_TYPE} --partition=${PARTITION} --qos=${QUEUE} --array=1-${LENGTH} --output=${OUT_DIR}/3_bam_masked/logs/%x.%A_%a.out --error=${OUT_DIR}/3_bam_masked/logs/%x.%A_%a.err slurm/ReSeq_MaskFilt.job)
FILT_JOB_ID=$(echo ${FILT_JOB} | cut -d ' ' -f4)

#echo ""
#echo "=== OPTIONAL STEP: Cleaning  =============================="
#echo ""
#sbatch --dependency=afterok:${DEDUP_JOB_ID} --mail-user=${USER_MAIL} --mail-type=${MAIL_TYPE} --partition=${PARTITION} --qos=${QUEUE} --output=${OUT_DIR}/1_bam_sort/logs/%x.%j.out --error=${OUT_DIR}/1_bam_sort/logs/%x.%j.err slurm/ReSeq_Clean.job
