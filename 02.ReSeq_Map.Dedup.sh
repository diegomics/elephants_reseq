# Only change and check these variables: #######################################################
export OUT_DIR="~/Elephant_project/ReSeq/pilot"
export ASSEMBLY="~/Elephant_project/mEleMax1/intermediates/bionano/l2/l2_s1.fa"
export ASSEMBLY_NAME=$(basename $ASSEMBLY .fa)
export FQ_DIR="~/Elephant_project/novaseq/trimmed"
################################################################################################


echo ""
echo "=== STEP 1/3: Indexing ===================================="
echo ""

mkdir -p $OUT_DIR/0_idx
INDEX_JOB=$(sbatch --output=$OUT_DIR/0_idx/%x.%j.out --error=$OUT_DIR/0_idx/%x.%j.err ReSeq.index.job)
INDEX_JOB_ID=$(echo $INDEX_JOB | cut -d ' ' -f4)


echo ""
echo "=== STEP 2/3: Mapping/Sorting ============================="
echo ""

LENGTH=$(ls $FQ_DIR/*R1*.fastq.gz | wc -l)
mkdir -p $OUT_DIR/1_bam_sort
MAP_JOB=$(sbatch --dependency=afterok:$INDEX_JOB_ID --array=1-$LENGTH --output=$OUT_DIR/1_bam_sort/%x.%A_%a.out --error=$OUT_DIR/1_bam_sort/%x.%A_%a.err ReSeq_Map.Sort.job)
MAP_JOB_ID=$(echo $MAP_JOB | cut -d ' ' -f4)


echo ""
echo "=== STEP 3/3: Deduplication  =============================="
echo ""

LENGTH=$(ls ${OUT_DIR}/1_bam_sort/*.bam | wc -l)
mkdir -p $OUT_DIR/2_bam_dedup
sbatch --dependency=afterok:$INDEX_JOB_ID:$MAP_JOB_ID --output=$OUT_DIR/2_bam_dedup/%x.%A_%a.out --error=$OUT_DIR/2_bam_dedup/%x.%A_%a.err ReSeq_Dedup.job
                                                                                                                                                                                                        
