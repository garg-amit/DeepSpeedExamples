DDD="/data/users/adatkins/dev/phivnext/yoco/yocov2/DeepSpeedExamples/benchmarks/inference/mii/analysis_20250528_paper_longctx_longgen/_data_mixture_old_data_new_llama32_qwen25"
RESULT_DIRS=(
    "${DDD}/qwen25_7B"
    "${DDD}/llama32_3B"
    "${DDD}/phi4mini"
    "${DDD}/yocov1da"
    "${DDD}/yocov1"
    "${DDD}/yocov2"
    "${DDD}/yocov2noda"
)
MODEL_NAMES=(
    Qwen-2.5-7B
    Llama3.2-3B
    Phi4-mini
    Samba+YOCO+DA
    Samba+YOCO
    Phi4-mini-Flash
    SambaY
)

OUT_DIR="${DDD}/../_PLOTS14_1_2_4_8_16_mixture_with_neurips_data"

python src/plot_th_lat_modified.py --result_dirs "${RESULT_DIRS[@]}" --model_names "${MODEL_NAMES[@]}" --out_dir ${OUT_DIR}

# phi4mini -> Phi4-mini
# yocov1da -> Samba+YOCO+DA
# yocov1 -> Samba+YOCO
# yocov2-> Phi4-mini-Flash
# yocov2noda -> SambaY