DDD="/data/users/adatkins/dev/phivnext/yoco/yocov2/DeepSpeedExamples/benchmarks/inference/mii/sorted_results_long"
RESULT_DIRS=(
    "${DDD}/llama32-3B"
    "${DDD}/phi4mini-llama-impl"
    "${DDD}/phi4mini-phi-impl"
    "${DDD}/yocov2-without-DA"
)
MODEL_NAMES=(
    llama32-3B 
    phi4mini-llama-impl
    phi4mini-phi-impl
    yocov2-without-DA
)

OUT_DIR=./plots_yocov2_long/

python src/plot_th_lat_modified.py --result_dirs "${RESULT_DIRS[@]}" --model_names "${MODEL_NAMES[@]}" --out_dir ${OUT_DIR}
