# Copyright (c) Microsoft Corporation.
# SPDX-License-Identifier: Apache-2.0

# DeepSpeed Team

# #OUT_DIR=./results_20250116_benchmark_yocov2newdrop_longer_eager
# OUT_DIR=../results_20250117_benchmark_yocov2newdrop_basic_plus_longer_no_eager
# LOAD_FORMAT=dummy
# BACKEND="vllm"

# # pkill -f vllm
# # sleep 10

# # MODEL="meta-llama/Llama-3.2-3B"

# # python ./run_benchmark.py --backend ${BACKEND}  --model ${MODEL} --mean_prompt_length 4000 --mean_max_new_tokens 4000 --tp_size 1 --out_json_dir ${OUT_DIR} --load_format ${LOAD_FORMAT} --stream --overwrite_results
# # pkill -f vllm
# # sleep 10
# # python ./run_benchmark.py --backend ${BACKEND}  --model ${MODEL} --mean_prompt_length 8000 --mean_max_new_tokens 500 --tp_size 1 --out_json_dir ${OUT_DIR} --load_format ${LOAD_FORMAT} --stream  --overwrite_results
# # pkill -f vllm
# # sleep 10
# # python ./run_benchmark.py --backend ${BACKEND}  --model ${MODEL} --mean_prompt_length 16000 --mean_max_new_tokens 500 --tp_size 1 --out_json_dir ${OUT_DIR} --load_format ${LOAD_FORMAT} --stream  --overwrite_results
# # pkill -f vllm
# # sleep 10

# # MODEL="microsoft/Phi-3.5-mini-instruct"

# # python ./run_benchmark.py --backend ${BACKEND}  --model ${MODEL} --mean_prompt_length 4000 --mean_max_new_tokens 4000 --tp_size 1 --out_json_dir ${OUT_DIR} --load_format ${LOAD_FORMAT} --stream --overwrite_results
# # pkill -f vllm
# # sleep 10
# # python ./run_benchmark.py --backend ${BACKEND}  --model ${MODEL} --mean_prompt_length 8000 --mean_max_new_tokens 500 --tp_size 1 --out_json_dir ${OUT_DIR} --load_format ${LOAD_FORMAT} --stream  --overwrite_results
# # pkill -f vllm
# # sleep 10
# # python ./run_benchmark.py --backend ${BACKEND}  --model ${MODEL} --mean_prompt_length 16000 --mean_max_new_tokens 500 --tp_size 1 --out_json_dir ${OUT_DIR} --load_format ${LOAD_FORMAT} --stream  --overwrite_results
# # pkill -f vllm
# # sleep 10

# pkill -f vllm
# sleep 10

# MODEL="meta-llama/Llama-3.2-3B"

# python ./run_benchmark.py --backend ${BACKEND}  --model ${MODEL} --mean_prompt_length 500 --mean_max_new_tokens 500 --tp_size 1 --out_json_dir ${OUT_DIR} --load_format ${LOAD_FORMAT} --stream --overwrite_results
# pkill -f vllm
# sleep 10
# python ./run_benchmark.py --backend ${BACKEND}  --model ${MODEL} --mean_prompt_length 4000 --mean_max_new_tokens 500 --tp_size 1 --out_json_dir ${OUT_DIR} --load_format ${LOAD_FORMAT} --stream --overwrite_results
# pkill -f vllm
# sleep 10
# python ./run_benchmark.py --backend ${BACKEND}  --model ${MODEL} --mean_prompt_length 500 --mean_max_new_tokens 4000 --tp_size 1 --out_json_dir ${OUT_DIR} --load_format ${LOAD_FORMAT} --stream --overwrite_results
# pkill -f vllm
# sleep 10
# python ./run_benchmark.py --backend ${BACKEND}  --model ${MODEL} --mean_prompt_length 4000 --mean_max_new_tokens 4000 --tp_size 1 --out_json_dir ${OUT_DIR} --load_format ${LOAD_FORMAT} --stream --overwrite_results
# pkill -f vllm
# sleep 10
# python ./run_benchmark.py --backend ${BACKEND}  --model ${MODEL} --mean_prompt_length 8000 --mean_max_new_tokens 500 --tp_size 1 --out_json_dir ${OUT_DIR} --load_format ${LOAD_FORMAT} --stream  --overwrite_results
# pkill -f vllm
# sleep 10
# python ./run_benchmark.py --backend ${BACKEND}  --model ${MODEL} --mean_prompt_length 16000 --mean_max_new_tokens 500 --tp_size 1 --out_json_dir ${OUT_DIR} --load_format ${LOAD_FORMAT} --stream  --overwrite_results
# pkill -f vllm
# sleep 10

# MODEL="microsoft/Phi-3.5-mini-instruct"

# python ./run_benchmark.py --backend ${BACKEND}  --model ${MODEL} --mean_prompt_length 500 --mean_max_new_tokens 500 --tp_size 1 --out_json_dir ${OUT_DIR} --load_format ${LOAD_FORMAT} --stream --overwrite_results
# pkill -f vllm
# sleep 10
# python ./run_benchmark.py --backend ${BACKEND}  --model ${MODEL} --mean_prompt_length 4000 --mean_max_new_tokens 500 --tp_size 1 --out_json_dir ${OUT_DIR} --load_format ${LOAD_FORMAT} --stream --overwrite_results
# pkill -f vllm
# sleep 10
# python ./run_benchmark.py --backend ${BACKEND}  --model ${MODEL} --mean_prompt_length 500 --mean_max_new_tokens 4000 --tp_size 1 --out_json_dir ${OUT_DIR} --load_format ${LOAD_FORMAT} --stream --overwrite_results
# pkill -f vllm
# sleep 10
# python ./run_benchmark.py --backend ${BACKEND}  --model ${MODEL} --mean_prompt_length 4000 --mean_max_new_tokens 4000 --tp_size 1 --out_json_dir ${OUT_DIR} --load_format ${LOAD_FORMAT} --stream --overwrite_results
# pkill -f vllm
# sleep 10
# python ./run_benchmark.py --backend ${BACKEND}  --model ${MODEL} --mean_prompt_length 8000 --mean_max_new_tokens 500 --tp_size 1 --out_json_dir ${OUT_DIR} --load_format ${LOAD_FORMAT} --stream  --overwrite_results
# pkill -f vllm
# sleep 10
# python ./run_benchmark.py --backend ${BACKEND}  --model ${MODEL} --mean_prompt_length 16000 --mean_max_new_tokens 500 --tp_size 1 --out_json_dir ${OUT_DIR} --load_format ${LOAD_FORMAT} --stream  --overwrite_results
# pkill -f vllm
# sleep 10

# OUT_DIR=./results_20250127_benchmark_yocov2newdrop_longer_llama32
# LOAD_FORMAT=dummy
# BACKEND="vllm"
# MODEL="meta-llama/Llama-3.2-3B"

# pkill -f vllm
# sleep 10

# # python ./run_benchmark.py --backend ${BACKEND}  --model ${MODEL} --mean_prompt_length 8000 --mean_max_new_tokens 500 --tp_size 1 --out_json_dir ${OUT_DIR} --load_format ${LOAD_FORMAT} --stream  --overwrite_results --port 26500 --parallel --cuda_visible_devices 0 &
# # python ./run_benchmark.py --backend ${BACKEND}  --model ${MODEL} --mean_prompt_length 16000 --mean_max_new_tokens 500 --tp_size 1 --out_json_dir ${OUT_DIR} --load_format ${LOAD_FORMAT} --stream  --overwrite_results --port 26501 --parallel --cuda_visible_devices 1 &

# # python ./run_benchmark.py --backend ${BACKEND}  --model ${MODEL} --mean_prompt_length 4000 --mean_max_new_tokens 2000 --tp_size 1 --out_json_dir ${OUT_DIR} --load_format ${LOAD_FORMAT} --stream  --overwrite_results --port 26502 --parallel --cuda_visible_devices 2 &
# # python ./run_benchmark.py --backend ${BACKEND}  --model ${MODEL} --mean_prompt_length 8000 --mean_max_new_tokens 2000 --tp_size 1 --out_json_dir ${OUT_DIR} --load_format ${LOAD_FORMAT} --stream  --overwrite_results --port 26503 --parallel --cuda_visible_devices 3 &

# # python ./run_benchmark.py --backend ${BACKEND}  --model ${MODEL} --mean_prompt_length 500 --mean_max_new_tokens 4000 --tp_size 1 --out_json_dir ${OUT_DIR} --load_format ${LOAD_FORMAT} --stream  --overwrite_results --port 26504 --parallel --cuda_visible_devices 4 &
# # python ./run_benchmark.py --backend ${BACKEND}  --model ${MODEL} --mean_prompt_length 4000 --mean_max_new_tokens 4000 --tp_size 1 --out_json_dir ${OUT_DIR} --load_format ${LOAD_FORMAT} --stream  --overwrite_results --port 26505 --parallel --cuda_visible_devices 5 &

# # python ./run_benchmark.py --backend ${BACKEND}  --model ${MODEL} --mean_prompt_length 500 --mean_max_new_tokens 8000 --tp_size 1 --out_json_dir ${OUT_DIR} --load_format ${LOAD_FORMAT} --stream  --overwrite_results --port 26506 --parallel --cuda_visible_devices 6 &
# python ./run_benchmark.py --backend ${BACKEND}  --model ${MODEL} --mean_prompt_length 4000 --mean_max_new_tokens 8000 --tp_size 1 --out_json_dir ${OUT_DIR} --load_format ${LOAD_FORMAT} --stream  --overwrite_results --port 26507 --parallel --cuda_visible_devices 7 &

OUT_DIR=./results_20250128_benchmark_yocov2newdrop_longgen_llama32
LOAD_FORMAT=dummy
BACKEND="vllm"
MODEL="meta-llama/Llama-3.2-3B"

pkill -f vllm
sleep 10

python ./run_benchmark.py --backend ${BACKEND}  --model ${MODEL} --mean_prompt_length 2000 --mean_max_new_tokens 8000 --tp_size 1 --out_json_dir ${OUT_DIR} --load_format ${LOAD_FORMAT} --stream  --overwrite_results --port 26500 --parallel --cuda_visible_devices 0 &

python ./run_benchmark.py --backend ${BACKEND}  --model ${MODEL} --mean_prompt_length 2000 --mean_max_new_tokens 16000 --tp_size 1 --out_json_dir ${OUT_DIR} --load_format ${LOAD_FORMAT} --stream  --overwrite_results --port 26501 --parallel --cuda_visible_devices 1 &