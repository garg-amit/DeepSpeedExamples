# Copyright (c) Microsoft Corporation.
# SPDX-License-Identifier: Apache-2.0

# DeepSpeed Team

# uses install_default_vllm_073_phyagi-image.sh
# details in deps/paper_releasedvllm_myenvdefault073phyagi312_4.txt

OUT_DIR=./results_20250529_benchmark_paper2_vllm073released_phi4miniinstruct_cuda124_py312_nocppc
LOAD_FORMAT=dummy
BACKEND="vllm"
MODEL="microsoft/Phi-4-mini-instruct"

python ./run_benchmark.py --backend ${BACKEND}  --model ${MODEL} --max_prompt_length 128000 --mean_prompt_length 2000 --mean_max_new_tokens 32000 --tp_size 1 --out_json_dir ${OUT_DIR} --load_format ${LOAD_FORMAT} --stream --overwrite_results --yocov2 --parallel --cuda_visible_devices 0 --port 26500 &
python ./run_benchmark.py --backend ${BACKEND}  --model ${MODEL} --max_prompt_length 128000 --mean_prompt_length 32000 --mean_max_new_tokens 500 --tp_size 1 --out_json_dir ${OUT_DIR} --load_format ${LOAD_FORMAT} --stream --overwrite_results --yocov2 --parallel --cuda_visible_devices 1 --port 26501 &



OUT_DIR=./results_20250529_benchmark_paper2_vllm073released_Qwen25-7B_cuda124_py312_nocppc
LOAD_FORMAT=dummy
BACKEND="vllm"
MODEL="Qwen/Qwen2.5-7B"

python ./run_benchmark.py --backend ${BACKEND}  --model ${MODEL} --max_prompt_length 128000 --mean_prompt_length 2000 --mean_max_new_tokens 32000 --tp_size 1 --out_json_dir ${OUT_DIR} --load_format ${LOAD_FORMAT} --stream --overwrite_results --yocov2 --parallel --cuda_visible_devices 2 --port 26502 &
python ./run_benchmark.py --backend ${BACKEND}  --model ${MODEL} --max_prompt_length 128000 --mean_prompt_length 32000 --mean_max_new_tokens 500 --tp_size 1 --out_json_dir ${OUT_DIR} --load_format ${LOAD_FORMAT} --stream --overwrite_results --yocov2 --parallel --cuda_visible_devices 3 --port 26503 &



OUT_DIR=./results_20250529_benchmark_paper2_vllm073released_llama32-3B_cuda124_py312_nocppc
LOAD_FORMAT=dummy
BACKEND="vllm"
MODEL="meta-llama/Llama-3.2-3B"

python ./run_benchmark.py --backend ${BACKEND}  --model ${MODEL} --max_prompt_length 128000 --mean_prompt_length 2000 --mean_max_new_tokens 32000 --tp_size 1 --out_json_dir ${OUT_DIR} --load_format ${LOAD_FORMAT} --stream --overwrite_results --yocov2 --parallel --cuda_visible_devices 4 --port 26504 &
python ./run_benchmark.py --backend ${BACKEND}  --model ${MODEL} --max_prompt_length 128000 --mean_prompt_length 32000 --mean_max_new_tokens 500 --tp_size 1 --out_json_dir ${OUT_DIR} --load_format ${LOAD_FORMAT} --stream --overwrite_results --yocov2 --parallel --cuda_visible_devices 5 --port 26505 &
