DDD="analysis_20250716_gather_for_rebuttal/_data/paper_ttft_tbt_throughput"
RESULT_DIRS=(
    "${DDD}/phi4mini"
    "${DDD}/yocov1da"
    "${DDD}/yocov1"
    "${DDD}/yocov2_original"
    "${DDD}/results_20250714_benchmark_paper2_justmergedvllm_yocov2_cuda124_py312_nocppc_paper_repro2_vllm_GOOD" # yocov2
    "${DDD}/yocov2noda"
    
)
MODEL_NAMES=(
    Phi4-mini-reasoning
    Samba+YOCO+DA
    Samba+YOCO
    Phi4-mini-Flash-Reasoning
    Phi4-mini-Flash-Reasoning-RR # rebased+released
    SambaY
)

OUT_DIR="${DDD}/../../_PLOTS_ttft_tbt_throughput"

python src/plot_th_lat_modified.py --result_dirs "${RESULT_DIRS[@]}" --model_names "${MODEL_NAMES[@]}" --out_dir ${OUT_DIR}
