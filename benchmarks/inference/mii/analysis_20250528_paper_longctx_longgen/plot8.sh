DDD="/data/users/adatkins/dev/phivnext/yoco/yocov2/DeepSpeedExamples/benchmarks/inference/mii/analysis_20250512_paper_124clients_existingresults/_data_with_8_16_fix"
RESULT_DIRS=(
    "${DDD}/phi4mini"
    "${DDD}/yocov1da"
    "${DDD}/yocov1"
    "${DDD}/yocov2"
    "${DDD}/yocov2noda"
    
)
MODEL_NAMES=(
    Phi4-mini
    Samba+YOCO+DA
    Samba+YOCO
    Phi4-mini-Flash
    SambaY
)

OUT_DIR="${DDD}/../_PLOTS8_1_2_4_8_16"

python src/plot_th_lat_modified.py --result_dirs "${RESULT_DIRS[@]}" --model_names "${MODEL_NAMES[@]}" --out_dir ${OUT_DIR}

# phi4mini -> Phi4-mini
# yocov1da -> Samba+YOCO+DA
# yocov1 -> Samba+YOCO
# yocov2-> Phi4-mini-Flash
# yocov2noda -> SambaY