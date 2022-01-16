# Only change these variables: #################################################################
export OUT_DIR="~/Elephant_project/ReSeq/pilot/vcf_deepvar"
export REF="~/Elephant_project/mEleMax1/intermediates/bionano/l2/l2_s1.fa"
export BAM_DIR="~/Elephant_project/ReSeq/pilot/bam_dedup"
################################################################################################


echo ""
echo "=== STEP 1/x: Calling variants ===================================="
echo ""

mkdir -p $OUT_DIR/deepvar/intermediate_results_dir
DEEPVAR_JOB=$(sbatch --output=$OUT_DIR/deepvar/%x.%j.out --error=$OUT_DIR/deepvar/%x.%j.err ReSeq_DeepVariant.job)
DEEPVAR_JOB_ID=$(echo $DEEPVAR_JOB | cut -d ' ' -f4)

echo ""
echo "=== STEP 2/x: Join gVCF files ===================================="
echo ""

