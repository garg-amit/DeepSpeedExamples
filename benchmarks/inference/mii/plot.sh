RESULT_DIRS=(
    <result-dir1>
    <result-dir2>
    # Add more result directories as needed
)
MODEL_NAMES=(
    <model-name1> 
    <model-name2>
    # Add corresponding model names
)

OUT_DIR=./plots/

python src/plot_th_lat_modified.py --result_dirs "${RESULT_DIRS[@]}" --model_names "${MODEL_NAMES[@]}" --out_dir ${OUT_DIR}
