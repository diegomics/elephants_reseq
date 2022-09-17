source variables.cnf


if [[ "${READ_TYPE}" == "illumina" ]]
then
        echo ""
        echo "=== STEP 1/3: Indexing ===================================="
        echo ""
        mkdir -p "${OUT_DIR}/0_idx/logs"
        INDEX_JOB=$(sbatch --mail-user=${USER_MAIL} --mail-type=${MAIL_TYPE} --partition=${PARTITION} --qos=${QUEUE} --output=${OUT_DIR}/0_idx/logs/%x.%j.out --error=${OUT_DIR}/0_idx/logs/%x.%j.err slurm/ReSeq_index.job)
        INDEX_JOB_ID=$(echo ${INDEX_JOB} | cut -d ' ' -f4)


        echo ""
        echo "=== STEP 2/3: Mapping/Sorting ============================="
        echo ""
        LENGTH=$(ls ${TRIM_DIR}/*R1*.fq.gz | wc -l)
        mkdir -p "${OUT_DIR}/1_bam_sort/logs"
        mkdir -p "${OUT_DIR}/5_bam_eval"
        MAP_JOB=$(sbatch --dependency=afterok:${INDEX_JOB_ID} --mail-user=${USER_MAIL} --mail-type=${MAIL_TYPE} --partition=${PARTITION} --qos=${QUEUE} --array=1-${LENGTH} --output=${OUT_DIR}/1_bam_sort/logs/%x.%A_%a.out --error=${OUT_DIR}/1_bam_sort/logs/%x.%A_%a.err slurm/ReSeq_Map.Sort_short.job)
        MAP_JOB_ID=$(echo ${MAP_JOB} | cut -d ' ' -f4)


        echo ""
        echo "=== STEP 3/3: Deduplication  =============================="
        echo ""

        LENGTH=$(ls ${OUT_DIR}/1_bam_sort/*.bam | wc -l)
        mkdir -p $OUT_DIR/2_bam_dedup
        sbatch --dependency=afterok:$INDEX_JOB_ID:$MAP_JOB_ID --output=$OUT_DIR/2_bam_dedup/%x.%A_%a.out --error=$OUT_DIR/2_bam_dedup/%x.%A_%a.err ReSeq_Dedup.job

        LENGTH=$(ls ${TRIM_DIR}/*R1*.fq.gz | wc -l)
        mkdir -p "${OUT_DIR}/2_bam_dedup/logs"
        DEDUP_JOB=$(sbatch --dependency=afterok:${INDEX_JOB_ID}:${MAP_JOB_ID} --mail-user=${USER_MAIL} --mail-type=${MAIL_TYPE} --partition=${PARTITION} --qos=${QUEUE} --array=1-${LENGTH} --output=${OUT_DIR}/2_bam_dedup/logs/%x.%A_%a.out --error=${OUT_DIR}/2_bam_dedup/logs/%x.%A_%a.err slurm/ReSeq_Dedup.job)
        DEDUP_JOB_ID=$(echo ${DEDUP_JOB} | cut -d ' ' -f4)


elif  [[ "${READ_TYPE}" == "hifi" ]]
then
        echo ""
        echo "=== STEP 1/2: Mapping/Sorting ============================="
        echo ""

        LENGTH=$(ls $FQ_DIR/*.fastq.gz | wc -l)
        mkdir -p $OUT_DIR/1_bam_sort
        MAP_JOB=$(sbatch --array=1-$LENGTH --output=$OUT_DIR/1_bam_sort/%x.%A_%a.out --error=$OUT_DIR/1_bam_sort/%x.%A_%a.err ReSeq.Map.Sort_long.job)
        MAP_JOB_ID=$(echo $MAP_JOB | cut -d ' ' -f4)


        echo ""
        echo "=== STEP 2/2: Deduplication  =============================="
        echo ""

        LENGTH=$(ls ${OUT_DIR}/1_bam_sort/*.bam | wc -l)
        mkdir -p $OUT_DIR/2_bam_dedup
        sbatch --dependency=afterok:$INDEX_JOB_ID:$MAP_JOB_ID --output=$OUT_DIR/2_bam_dedup/%x.%A_%a.out --error=$OUT_DIR/2_bam_dedup/%x.%A_%a.err ReSeq_Dedup.job

else
        echo "Error: Invalid read type! Check READ_TYPE variable in variables.cnf"
fi
