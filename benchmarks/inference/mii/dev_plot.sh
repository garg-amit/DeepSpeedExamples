RESULT_DIRS=(
    DEV_results_yocov2_sans_DA_vllmyoco
)
MODEL_NAMES=(
    yocov2_sans_DA
)

OUT_DIR=./DEV_plots_yocov2_sans_DA/

python src/plot_th_lat_modified.py --result_dirs "${RESULT_DIRS[@]}" --model_names "${MODEL_NAMES[@]}" --out_dir ${OUT_DIR}
