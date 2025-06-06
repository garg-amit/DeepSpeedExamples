DDD="/data/users/adatkins/dev/phivnext/yoco/yocov2/DeepSpeedExamples/benchmarks/inference/mii/analysis_20250606_huggingface_hf_release_paper_figures/_data_with_8_16_fix"
RESULT_DIRS=(
    "${DDD}/phi4mini"
    "${DDD}/yocov2"
    
)
MODEL_NAMES=(
    Phi4-mini-reasoning
    Phi4-mini-flash-reasoning
)

OUT_DIR="${DDD}/../_PLOTS20_1_2_4_8_16"

python src/plot_th_lat_modified.py --result_dirs "${RESULT_DIRS[@]}" --model_names "${MODEL_NAMES[@]}" --out_dir ${OUT_DIR}
