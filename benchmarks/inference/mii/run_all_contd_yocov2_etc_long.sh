# Copyright (c) Microsoft Corporation.
# SPDX-License-Identifier: Apache-2.0

# DeepSpeed Team

LOAD_FORMAT=dummy
BACKEND="vllm"

MODEL="/data/users/adatkins/dev/phivnext/yoco/yocov2/DeepSpeedExamples/benchmarks/inference/mii/dummy_checkpoints/yocov2_samba_no_da_hf"

## 12-15

OUT_DIR=./results_retry_all_eager_yocov2_without_da_contd

pkill -f vllm
pkill -f benchmark
sleep 10

python ./run_benchmark.py --backend ${BACKEND}  --model ${MODEL} --mean_prompt_length 4000 --mean_max_new_tokens 4000 --tp_size 1 --out_json_dir ${OUT_DIR} --load_format ${LOAD_FORMAT} --stream --cuda_visible_devices 6 --port 26506 --overwrite_results
pkill -f vllm
pkill -f benchmark
sleep 10

# python ./run_benchmark.py --backend ${BACKEND}  --model ${MODEL} --mean_prompt_length 500 --mean_max_new_tokens 8000 --tp_size 1 --out_json_dir ${OUT_DIR} --load_format ${LOAD_FORMAT} --stream --cuda_visible_devices 5 --port 26505 --overwrite_results
# pkill -f vllm
# pkill -f benchmark
# sleep 10

# python ./run_benchmark.py --backend ${BACKEND}  --model ${MODEL} --mean_prompt_length 4000 --mean_max_new_tokens 8000 --tp_size 1 --out_json_dir ${OUT_DIR} --load_format ${LOAD_FORMAT} --stream --cuda_visible_devices 7 --port 26507 --overwrite_results