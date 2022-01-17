# Only change these variables: #################################################################
export OUT_DIR="~/Elephant_project/ReSeq/pilot/3_deepvar"
export REF="~/Elephant_project/mEleMax1/intermediates/bionano/l2/l2_s1.fa"
export BAM_DIR="~/Elephant_project/ReSeq/pilot/2_bam_dedup"
################################################################################################


echo ""
echo "=== STEP 1/x: Calling variants ===================================="
echo ""

LENGTH=$(ls $BAM_DIR/*.rmd.bam | wc -l)
mkdir -p $OUT_DIR/tmp_dir
DEEPVAR_JOB=$(sbatch --array=1-$LENGTH --output=$OUT_DIR/%x.%A_%a.out --error=$OUT_DIR/%x.%A_%a.err ReSeq_DeepVariant.job)
DEEPVAR_JOB_ID=$(echo $DEEPVAR_JOB | cut -d ' ' -f4)

echo ""
echo "=== STEP 2/x: Merge gVCF files ===================================="
echo ""

MERGE_JOB=$(sbatch --dependency=afterok:$DEEPVAR_JOB_ID --output=$OUT_DIR/%x.%j.out --error=$OUT_DIR/%x.%j.err ReSeq_GLnexus.job)
MERGE_JOB_ID=$(echo $MERGE_JOB | cut -d ' ' -f4)

