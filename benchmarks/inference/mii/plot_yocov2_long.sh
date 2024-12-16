DDD="/data/users/adatkins/dev/phivnext/yoco/yocov2/DeepSpeedExamples/benchmarks/inference/mii/analysis_longgen/data_new_16k"
RESULT_DIRS=(
    "${DDD}/phi4mini-llama-impl"
    "${DDD}/yocov2-without-DA"
)
MODEL_NAMES=(
    phi4mini-llama-impl
    yocov2-without-DA
)

OUT_DIR=/data/users/adatkins/dev/phivnext/yoco/yocov2/DeepSpeedExamples/benchmarks/inference/mii/analysis_longgen/plots_2024-12-16_data_new_16k/

python src/plot_th_lat_modified.py --result_dirs "${RESULT_DIRS[@]}" --model_names "${MODEL_NAMES[@]}" --out_dir ${OUT_DIR}
