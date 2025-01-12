# Copyright (c) Microsoft Corporation.
# SPDX-License-Identifier: Apache-2.0

# DeepSpeed Team

# MODELS=(meta-llama/Llama-2-7b-hf meta-llama/Llama-2-13b-hf meta-llama/Llama-2-70b-hf tiiuae/falcon-40B tiiuae/falcon-180B microsoft/phi-2 mistralai/Mixtral-8x7B-v0.1)
MODELS=(microsoft/Phi-3.5-mini-instruct)
OUT_DIR=./results_vllm
LOAD_FORMAT=auto #dummy
MAX_PROMPT_LEN=8192
BACKEND=vllm_chat_completion #vllm #vllm_chat_completion
USE_IMAGE=True
USE_AUDIO=False
IMAGE_DIR=/home/azureuser/cloudfiles/code/Users/gargamit/DeepSpeedExamples/benchmarks/inference/mii/data/vision-ds
MODEL_MAX_LEN=32000
TP_SIZE=1
MODEL_SERVER_EXTRA_ARGS=""

# Set Attention backend
export VLLM_ATTENTION_BACKEND=XFORMERS

run_benchmark() {
    local mean_prompt_length=$1
    local mean_max_new_tokens=$2
    local use_flag=$3

    python ./run_benchmark.py --backend ${BACKEND} --model ${MODEL} --max_model_len ${MODEL_MAX_LEN} \
        --mean_prompt_length ${mean_prompt_length} --max_prompt_length ${MAX_PROMPT_LEN} \
        --mean_max_new_tokens ${mean_max_new_tokens} --tp_size ${TP_SIZE} --out_json_dir ${OUT_DIR} \
        --load_format ${LOAD_FORMAT} --stream ${use_flag} --extra_args "${MODEL_SERVER_EXTRA_ARGS}"
}

for MODEL in ${MODELS[@]}; do
    if [ "$USE_AUDIO" = True ]; then
        run_benchmark 500 500 "--use_audio"
        run_benchmark 1300 120 "--use_audio"
        run_benchmark 2600 60 "--use_audio"
        run_benchmark 4096 500 "--use_audio"
    elif [ "$USE_IMAGE" = True ]; then
        run_benchmark 500 500 "--use_image --image_dir ${IMAGE_DIR}"
        run_benchmark 1300 120 "--use_image --image_dir ${IMAGE_DIR}"
        run_benchmark 2600 60 "--use_image --image_dir ${IMAGE_DIR}"
        run_benchmark 4096 500 "--use_image --image_dir ${IMAGE_DIR}"
    else
        run_benchmark 500 500 "" 
        run_benchmark 1300 120 ""
        run_benchmark 2600 60 ""
        run_benchmark 4096 500 ""
    fi
done