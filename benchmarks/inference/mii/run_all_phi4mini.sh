# Copyright (c) Microsoft Corporation.
# SPDX-License-Identifier: Apache-2.0

# DeepSpeed Team

MODELS=(
    /data/users/adatkins/dev/phivnext/yoco/yocov2/DeepSpeedExamples/benchmarks/inference/mii/dummy_checkpoints/phi4mini_tied-gqa3-swa2k-attn_head24_no_swa_llama_impl
    /data/users/adatkins/dev/phivnext/yoco/yocov2/DeepSpeedExamples/benchmarks/inference/mii/dummy_checkpoints/phi4mini_tied-gqa3-swa2k-attn_head24_no_swa_phi_impl
)
OUT_DIR=./results_phi4mini
LOAD_FORMAT=dummy
BACKEND="vllm"

for MODEL in ${MODELS[@]}; do
    python ./run_benchmark.py --backend ${BACKEND}  --model ${MODEL} --mean_prompt_length 500 --mean_max_new_tokens 500 --tp_size 1 --out_json_dir ${OUT_DIR} --load_format ${LOAD_FORMAT} --stream
    python ./run_benchmark.py --backend ${BACKEND}  --model ${MODEL} --mean_prompt_length 4096 --mean_max_new_tokens 500 --tp_size 1 --out_json_dir ${OUT_DIR} --load_format ${LOAD_FORMAT} --stream
done
