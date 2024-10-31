# Copyright (c) Microsoft Corporation.
# SPDX-License-Identifier: Apache-2.0

# DeepSpeed Team

# MODELS=(meta-llama/Llama-2-7b-hf meta-llama/Llama-2-13b-hf meta-llama/Llama-2-70b-hf tiiuae/falcon-40B tiiuae/falcon-180B microsoft/phi-2 mistralai/Mixtral-8x7B-v0.1)
MODELS=(microsoft/Phi-3.5-mini-instruct)
MODELS=(/home/azureuser/cloudfiles/code/Users/gargamit/models/phio-vllm)
OUT_DIR=./results_vllm
LOAD_FORMAT=auto
for MODEL in ${MODELS[@]}; do
    python ./run_benchmark.py --backend vllm  --model ${MODEL} --mean_prompt_length 500 --mean_max_new_tokens 500 --tp_size 1 --out_json_dir ${OUT_DIR} --load_format ${LOAD_FORMAT} --stream 
    python ./run_benchmark.py --backend vllm  --model ${MODEL} --mean_prompt_length 1300 --mean_max_new_tokens 120 --tp_size 1 --out_json_dir ${OUT_DIR} --load_format ${LOAD_FORMAT} --stream
    python ./run_benchmark.py --backend vllm  --model ${MODEL} --mean_prompt_length 2600 --mean_max_new_tokens 60 --tp_size 1 --out_json_dir ${OUT_DIR} --load_format ${LOAD_FORMAT} --stream
    python ./run_benchmark.py --backend vllm  --model ${MODEL} --mean_prompt_length 4096 --mean_max_new_tokens 500 --tp_size 1 --out_json_dir ${OUT_DIR} --load_format ${LOAD_FORMAT} --stream
    python ./run_benchmark.py --backend vllm  --model ${MODEL} --mean_prompt_length 4096 --mean_max_new_tokens 1500 --tp_size 1 --out_json_dir ${OUT_DIR} --load_format ${LOAD_FORMAT} --stream
    python ./run_benchmark.py --backend vllm  --model ${MODEL} --mean_prompt_length 15000 --mean_max_new_tokens 1000 --tp_size 1 --out_json_dir ${OUT_DIR} --load_format ${LOAD_FORMAT} --stream
 
done
