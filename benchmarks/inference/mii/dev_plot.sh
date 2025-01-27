RESULT_DIRS=(
    results_phi4_dev_vllm
)
MODEL_NAMES=(
    phi4
)

OUT_DIR=./plots_results_phi4_dev/

python src/plot_th_lat_modified.py --result_dirs "${RESULT_DIRS[@]}" --model_names "${MODEL_NAMES[@]}" --out_dir ${OUT_DIR}
