RESULT_DIRS=(
    "/home/azureuser/src/DeepSpeedExamples/benchmarks/inference/mii/results_vllm_vllm_chat_completion/"
    # "/home/azureuser/src/DeepSpeedExamples/benchmarks/inference/mii/results_vllm_text_vllm_chat_completion/"
)
MODEL_NAMES=(
    "_home_azureuser_cloudfiles_code_Users_vadimma_models_vllm_lora_MoE_weijian_phio-final-trial2-hf_hf-models_phio_-tp1-bs768-replicas1-prompt500-gen500"
    # "_home_azureuser_cloudfiles_code_Users_vadimma_models_vllm_lora_MoE_weijian_phio-final-trial2-hf_hf-models_phio_-tp1-bs768-replicas1-prompt500-gen500"
)

OUT_DIR=./plots/

python src/plot_th_lat_modified.py --result_dirs "${RESULT_DIRS[@]}" --model_names "${MODEL_NAMES[@]}" --out_dir ${OUT_DIR}
