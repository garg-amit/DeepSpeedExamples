# Copyright (c) Microsoft Corporation.
# SPDX-License-Identifier: Apache-2.0

# DeepSpeed Team\\\\

# MODELS=(meta-llama/Llama-2-7b-hf meta-llama/Llama-2-13b-hf meta-llama/Llama-2-70b-hf tiiuae/falcon-40B tiiuae/falcon-180B microsoft/phi-2 mistralai/Mixtral-8x7B-v0.1)
MODELS=(
    /data/users/adatkins/dev/phivnext/yoco/yocov2/v2_hf_ws_3att/yocov2_samba_hf
)
OUT_DIR=./results_yocov2_sans_DA
LOAD_FORMAT=dummy
BACKEND="yoco"

for MODEL in ${MODELS[@]}; do
    python ./run_benchmark.py --backend ${BACKEND}  --model ${MODEL} --mean_prompt_length 500 --mean_max_new_tokens 500 --tp_size 1 --out_json_dir ${OUT_DIR} --load_format ${LOAD_FORMAT} --stream
    python ./run_benchmark.py --backend ${BACKEND}  --model ${MODEL} --mean_prompt_length 4096 --mean_max_new_tokens 500 --tp_size 1 --out_json_dir ${OUT_DIR} --load_format ${LOAD_FORMAT} --stream
done
