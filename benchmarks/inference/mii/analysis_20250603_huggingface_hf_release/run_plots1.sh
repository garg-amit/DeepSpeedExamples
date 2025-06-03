DDD="/data/users/adatkins/dev/phivnext/yoco/yocov2/DeepSpeedExamples/benchmarks/inference/mii/analysis_20250603_huggingface_hf_release"
RESULT_DIRS=(
    "${DDD}/_data/phi4mini"
    "${DDD}/_data/yocov2"
    "${DDD}/_data/qwen25_7B"
    
)
MODEL_NAMES=(
    Phi4-mini
    Phi4-mini-Flash
    Qwen2.5-7B
)

OUT_DIR="${DDD}/plots1"

python src/plot_th_lat_modified_huggingface_hf_release_plots.py --result_dirs "${RESULT_DIRS[@]}" --model_names "${MODEL_NAMES[@]}" --out_dir ${OUT_DIR}

# phi4mini -> Phi4-mini
# yocov1da -> Samba+YOCO+DA
# yocov1 -> Samba+YOCO
# yocov2-> Phi4-mini-Flash
# yocov2noda -> SambaY