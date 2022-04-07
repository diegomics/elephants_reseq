source variables.cnf

echo ""
echo "=== STEP 1/3: Indexing ===================================="
echo ""

mkdir -p ${OUT_DIR}/0_idx/logs
INDEX_JOB=$(sbatch --mail-user=${USER_MAIL} --mail-type=${MAIL_TYPE} --partition=${PARTITION} --qos=${QUEUE} --output=${OUT_DIR}/0_idx/logs/%x.%j.out --error=${OUT_DIR}/0_idx/logs/%x.%j.err ReSeq.index.job)
INDEX_JOB_ID=$(echo $INDEX_JOB | cut -d ' ' -f4)


echo ""
echo "=== STEP 2/3: Mapping/Sorting ============================="
echo ""

LENGTH=$(ls $FQ_DIR/*R1*.fastq.gz | wc -l)
mkdir -p ${OUT_DIR}/1_bam_sort/logs
MAP_JOB=$(sbatch --dependency=afterok:$INDEX_JOB_ID --mail-user=${USER_MAIL} --mail-type=${MAIL_TYPE} --partition=${PARTITION} --qos=${QUEUE} --array=1-${LENGTH} --output=${OUT_DIR}/1_bam_sort/logs/%x.%A_%a.out --error=${OUT_DIR}/1_bam_sort/logs/%x.%A_%a.err ReSeq_Map.Sort.job)
MAP_JOB_ID=$(echo $MAP_JOB | cut -d ' ' -f4)


echo ""
echo "=== STEP 3/3: Deduplication  =============================="
echo ""

LENGTH=$(ls ${OUT_DIR}/1_bam_sort/*.bam | wc -l)
mkdir -p ${OUT_DIR}/2_bam_dedup/logs
sbatch --dependency=afterok:${INDEX_JOB_ID}:${MAP_JOB_ID} --mail-user=${USER_MAIL} --mail-type=${MAIL_TYPE} --partition=${PARTITION} --qos=${QUEUE} --output=${OUT_DIR}/2_bam_dedup/logs/%x.%A_%a.out --error=${OUT_DIR}/2_bam_dedup/logs/%x.%A_%a.err ReSeq_Dedup.job
                                                                                                                                                                                                        
