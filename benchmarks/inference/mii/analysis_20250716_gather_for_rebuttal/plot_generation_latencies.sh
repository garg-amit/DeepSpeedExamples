DDD="analysis_20250716_gather_for_rebuttal/_data/hf_release_yelong_generation_latencies"
RESULT_DIRS=(
    "${DDD}/qwen25_7B"
    "${DDD}/phi4mini"
    "${DDD}/yocov2_original"
    "${DDD}/results_20250715_benchmark_paper2_justmergedvllm_yocov2_cuda124_py312_nocppc_for_generation_latencies_vllm" # yocov2
)
MODEL_NAMES=(
    Qwen2.5-7B
    Phi4-mini-Reasoning
    Phi4-mini-Flash-Reasoning
    Phi4-mini-Flash-Reasoning-RR # rebased+released
)

OUT_DIR="${DDD}/../../_PLOTS_generation_latencies"

python src/plot_th_lat_modified_huggingface_hf_release_plots.py --result_dirs "${RESULT_DIRS[@]}" --model_names "${MODEL_NAMES[@]}" --out_dir ${OUT_DIR}
