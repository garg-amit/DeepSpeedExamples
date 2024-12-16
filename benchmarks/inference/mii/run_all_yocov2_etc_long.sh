# Copyright (c) Microsoft Corporation.
# SPDX-License-Identifier: Apache-2.0

# DeepSpeed Team

OUT_DIR=./results_retry_all_eager_phi4mini_llama_impl
LOAD_FORMAT=dummy
BACKEND="vllm"

MODEL="/data/users/adatkins/dev/phivnext/yoco/yocov2/DeepSpeedExamples/benchmarks/inference/mii/dummy_checkpoints/phi4mini_tied-gqa3-attn_head24_llama_impl"

# python ./run_benchmark.py --backend ${BACKEND}  --model ${MODEL} --mean_prompt_length 500 --mean_max_new_tokens 500 --tp_size 1 --out_json_dir ${OUT_DIR} --load_format ${LOAD_FORMAT} --stream --cuda_visible_devices 0 --port 26500 &



# python ./run_benchmark.py --backend ${BACKEND}  --model ${MODEL} --mean_prompt_length 500 --mean_max_new_tokens 4000 --tp_size 1 --out_json_dir ${OUT_DIR} --load_format ${LOAD_FORMAT} --stream --cuda_visible_devices 1 --port 26501 pkill -f benchmark
# pkill -f vllm
# pkill -f benchmark
# sleep 10

python ./run_benchmark.py --backend ${BACKEND}  --model ${MODEL} --mean_prompt_length 4000 --mean_max_new_tokens 4000 --tp_size 1 --out_json_dir ${OUT_DIR} --load_format ${LOAD_FORMAT} --stream --cuda_visible_devices 2 --port 26502 --overwrite_results
pkill -f vllm
pkill -f benchmark
sleep 10


python ./run_benchmark.py --backend ${BACKEND}  --model ${MODEL} --mean_prompt_length 500 --mean_max_new_tokens 8000 --tp_size 1 --out_json_dir ${OUT_DIR} --load_format ${LOAD_FORMAT} --stream --cuda_visible_devices 3 --port 26503 --overwrite_results
pkill -f vllm
pkill -f benchmark
sleep 10

python ./run_benchmark.py --backend ${BACKEND}  --model ${MODEL} --mean_prompt_length 4000 --mean_max_new_tokens 8000 --tp_size 1 --out_json_dir ${OUT_DIR} --load_format ${LOAD_FORMAT} --stream --cuda_visible_devices 4 --port 26504 --overwrite_results
pkill -f vllm
pkill -f benchmark
sleep 10


python ./run_benchmark.py --backend ${BACKEND}  --model ${MODEL} --mean_prompt_length 500 --mean_max_new_tokens 16000 --tp_size 1 --out_json_dir ${OUT_DIR} --load_format ${LOAD_FORMAT} --stream --cuda_visible_devices 5 --port 26505 --overwrite_results
pkill -f vllm
pkill -f benhcmark
sleep 10

python ./run_benchmark.py --backend ${BACKEND}  --model ${MODEL} --mean_prompt_length 4000 --mean_max_new_tokens 16000 --tp_size 1 --out_json_dir ${OUT_DIR} --load_format ${LOAD_FORMAT} --stream --cuda_visible_devices 6 --port 26506 --overwrite_results
pkill -f vllm
pkill -f benchmark
sleep 10

python ./run_benchmark.py --backend ${BACKEND}  --model ${MODEL} --mean_prompt_length 8000 --mean_max_new_tokens 16000 --tp_size 1 --out_json_dir ${OUT_DIR} --load_format ${LOAD_FORMAT} --stream --cuda_visible_devices 7 --port 26507 --overwrite_results
