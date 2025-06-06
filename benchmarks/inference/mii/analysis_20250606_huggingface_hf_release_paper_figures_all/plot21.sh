DDD="/data/users/adatkins/dev/phivnext/yoco/yocov2/DeepSpeedExamples/benchmarks/inference/mii/analysis_20250606_huggingface_hf_release_paper_figures_all/_data_with_8_16_fix"
RESULT_DIRS=(
    "${DDD}/phi4mini"
    "${DDD}/yocov1da"
    "${DDD}/yocov1"
    "${DDD}/yocov2"
    "${DDD}/yocov2noda"
    
)
MODEL_NAMES=(
    Phi4-mini-reasoning
    Samba+YOCO+DA
    Samba+YOCO
    Phi4-mini-flash-reasoning
    SambaY
)

OUT_DIR="${DDD}/../_PLOTS21_1_2_4_8_16"

python src/plot_th_lat_modified.py --result_dirs "${RESULT_DIRS[@]}" --model_names "${MODEL_NAMES[@]}" --out_dir ${OUT_DIR}
