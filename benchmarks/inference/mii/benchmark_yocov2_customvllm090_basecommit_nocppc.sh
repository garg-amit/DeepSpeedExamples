# Copyright (c) Microsoft Corporation.
# SPDX-License-Identifier: Apache-2.0

# DeepSpeed Team

LOAD_FORMAT=dummy
BACKEND="vllm"

# MODEL="Qwen/Qwen2.5-7B"
# OUT_DIR=./results_20250613_benchmark_base_commit_of_custom_vllm090_qwen25-7_cuda124_py312_nocppc

# # DONE
# MODEL="microsoft/Phi-4-mini-instruct"
# OUT_DIR=./results_20250613_benchmark_base_commit_of_custom_vllm090_phi4mini_cuda124_py312_nocppc


MODEL="meta-llama/Llama-3.2-3B"
OUT_DIR=./results_20250614_benchmark_base_commit_of_custom_vllm090_llama32-3B_cuda124_py312_nocppc

python ./run_benchmark.py --backend ${BACKEND}  --model ${MODEL} --max_prompt_length 128000 --mean_prompt_length 2000 --mean_max_new_tokens 500 --tp_size 1 --out_json_dir ${OUT_DIR} --load_format ${LOAD_FORMAT} --stream  --overwrite_results --use_editable --yocov2 --parallel --port 26500 --cuda_visible_devices 0  &

python ./run_benchmark.py --backend ${BACKEND}  --model ${MODEL} --max_prompt_length 128000 --mean_prompt_length 2000 --mean_max_new_tokens 2000 --tp_size 1 --out_json_dir ${OUT_DIR} --load_format ${LOAD_FORMAT} --stream  --overwrite_results --use_editable --yocov2 --parallel --port 26501 --cuda_visible_devices 1  &

python ./run_benchmark.py --backend ${BACKEND}  --model ${MODEL} --max_prompt_length 128000 --mean_prompt_length 2000 --mean_max_new_tokens 4000 --tp_size 1 --out_json_dir ${OUT_DIR} --load_format ${LOAD_FORMAT} --stream  --overwrite_results --use_editable --yocov2 --parallel --port 26502 --cuda_visible_devices 2  &

python ./run_benchmark.py --backend ${BACKEND}  --model ${MODEL} --max_prompt_length 128000 --mean_prompt_length 2000 --mean_max_new_tokens 8000 --tp_size 1 --out_json_dir ${OUT_DIR} --load_format ${LOAD_FORMAT} --stream  --overwrite_results --use_editable --yocov2 --parallel --port 26503 --cuda_visible_devices 3  &

python ./run_benchmark.py --backend ${BACKEND}  --model ${MODEL} --max_prompt_length 128000 --mean_prompt_length 2000 --mean_max_new_tokens 16000 --tp_size 1 --out_json_dir ${OUT_DIR} --load_format ${LOAD_FORMAT} --stream  --overwrite_results --use_editable --yocov2 --parallel --port 26504 --cuda_visible_devices 4  &

python ./run_benchmark.py --backend ${BACKEND}  --model ${MODEL} --max_prompt_length 128000 --mean_prompt_length 2000 --mean_max_new_tokens 32000 --tp_size 1 --out_json_dir ${OUT_DIR} --load_format ${LOAD_FORMAT} --stream  --overwrite_results --use_editable --yocov2 --parallel --port 26505 --cuda_visible_devices 5  &

python ./run_benchmark.py --backend ${BACKEND}  --model ${MODEL} --max_prompt_length 128000 --mean_prompt_length 32000 --mean_max_new_tokens 500 --tp_size 1 --out_json_dir ${OUT_DIR} --load_format ${LOAD_FORMAT} --stream  --overwrite_results --use_editable --yocov2 --parallel --port 26506 --cuda_visible_devices 6  &

