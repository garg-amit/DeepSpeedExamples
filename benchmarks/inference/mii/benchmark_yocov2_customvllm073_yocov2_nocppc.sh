# Copyright (c) Microsoft Corporation.
# SPDX-License-Identifier: Apache-2.0

# DeepSpeed Team

# OUT_DIR=./results_20250529_benchmark_yocov2newdrop_essentialcustomvllmyocov2_phi4miniinstruct_cuda124_py312_nocppc_rerun_longgen
# LOAD_FORMAT=dummy
# BACKEND="vllm"
# MODEL="microsoft/Phi-4-mini-instruct"

# python ./run_benchmark.py --backend ${BACKEND}  --model ${MODEL} --max_prompt_length 128000 --mean_prompt_length 2000 --mean_max_new_tokens 32000 --tp_size 1 --out_json_dir ${OUT_DIR} --load_format ${LOAD_FORMAT} --stream --overwrite_results --yocov2 --parallel --cuda_visible_devices 0 --use_editable --port 26500 &



# OUT_DIR=./results_20250529_benchmark_yocov2newdrop_essentialcustomvllmyocov2_Qwen25-7B_cuda124_py312_nocppc_rerun_longgen
# LOAD_FORMAT=dummy
# BACKEND="vllm"
# MODEL="Qwen/Qwen2.5-7B"

# python ./run_benchmark.py --backend ${BACKEND}  --model ${MODEL} --max_prompt_length 128000 --mean_prompt_length 2000 --mean_max_new_tokens 32000 --tp_size 1 --out_json_dir ${OUT_DIR} --load_format ${LOAD_FORMAT} --stream --overwrite_results --yocov2 --parallel --cuda_visible_devices 1 --use_editable --port 26501 &



# OUT_DIR=./results_20250529_benchmark_yocov2newdrop_essentialcustomvllmyocov2_llama32-3B_cuda124_py312_nocppc_rerun_longgen
# LOAD_FORMAT=dummy
# BACKEND="vllm"
# MODEL="meta-llama/Llama-3.2-3B"

# python ./run_benchmark.py --backend ${BACKEND}  --model ${MODEL} --max_prompt_length 128000 --mean_prompt_length 2000 --mean_max_new_tokens 32000 --tp_size 1 --out_json_dir ${OUT_DIR} --load_format ${LOAD_FORMAT} --stream --overwrite_results --yocov2 --parallel --cuda_visible_devices 2 --use_editable --port 26502 &


# ONLY YOCOv2 WORKS WITH THIS CODE, ELSE WE GET ERRORS
# uses install_rebased20250325_vllm_yocov2_phyagi-image.sh
# details in deps/paper_releasedvllm_myenvdefault073phyagi312_4.txt
OUT_DIR=./results_20250529_benchmark_paper2_vllm073customRByocov2_yocov2_cuda124_py312_nocppc

LOAD_FORMAT=dummy
BACKEND="vllm"
MODEL="/data/users/adatkins/dev/phivnext/yoco/yocov2/MoE/qyocov2/checkpoint/"

python ./run_benchmark.py --backend ${BACKEND}  --model ${MODEL} --max_prompt_length 128000 --mean_prompt_length 2000 --mean_max_new_tokens 32000 --tp_size 1 --out_json_dir ${OUT_DIR} --load_format ${LOAD_FORMAT} --stream  --overwrite_results --port 26506 --parallel --cuda_visible_devices 6 --use_editable --yocov2 &

LOAD_FORMAT=dummy
BACKEND="vllm"
MODEL="/data/users/adatkins/dev/phivnext/yoco/yocov2/MoE/qyocov2/checkpoint/"

python ./run_benchmark.py --backend ${BACKEND}  --model ${MODEL} --max_prompt_length 128000 --mean_prompt_length 32000 --mean_max_new_tokens 500 --tp_size 1 --out_json_dir ${OUT_DIR} --load_format ${LOAD_FORMAT} --stream  --overwrite_results --port 26507 --parallel --cuda_visible_devices 7 --use_editable --yocov2 &



# ~~~ TEST

# # ERROR RuntimeError: Number of heads in key/value must divide number of heads in query
# OUT_DIR=./results_20250529_benchmark_yocov2newdrop_essentialcustomvllmyocov2_llama32-3B_cuda124_py312_nocppc_rerun_longgen_TEST
# LOAD_FORMAT=dummy
# BACKEND="vllm"
# MODEL="meta-llama/Llama-3.2-3B"
# # /home/aiscuser/.local/bin/vllm serve meta-llama/Llama-3.2-3B --host 127.0.0.1 --port 26502 --trust-remote-code --load-format dummy --served-model-name BENCHMARK_MODEL_NAME --tensor-parallel-size 1 --max-model-len 131072 --max-seq-len-to-capture 131072 --enable-chunked-prefill false --no-enable-prefix-caching

# python ./run_benchmark.py --backend ${BACKEND}  --model ${MODEL} --max_prompt_length 128000 --mean_prompt_length 2000 --mean_max_new_tokens 32000 --tp_size 1 --out_json_dir ${OUT_DIR} --load_format ${LOAD_FORMAT} --stream --overwrite_results --yocov2 --cuda_visible_devices 2 --use_editable --port 26502
# OUT_DIR=./results_20250319_benchmark_yocov2newdrop_essentialcustomvllmyocov2_yocov2_cuda124
# LOAD_FORMAT=dummy
# BACKEND="vllm"
# MODEL="/data/users/adatkins/dev/phivnext/yoco/yocov2/MoE/qyocov2/checkpoint/"
# # /home/aiscuser/.local/bin/vllm serve /data/users/adatkins/dev/phivnext/yoco/yocov2/MoE/qyocov2/checkpoint/ --host 127.0.0.1 --port 26503 --trust-remote-code --load-format dummy --served-model-name BENCHMARK_MODEL_NAME --tensor-parallel-size 1 --max-model-len 131072 --max-seq-len-to-capture 131072 --enable-chunked-prefill false --no-enable-prefix-caching
# python ./run_benchmark.py --backend ${BACKEND}  --model ${MODEL} --max_prompt_length 128000 --mean_prompt_length 2000 --mean_max_new_tokens 32000 --tp_size 1 --out_json_dir ${OUT_DIR} --load_format ${LOAD_FORMAT} --stream  --overwrite_results --port 26503 --use_editable --yocov2
# # SUCCESS!

# # ERROR RuntimeError: Paged KV cache block size must be divisible by 16
# OUT_DIR=./results_20250529_benchmark_yocov2newdrop_essentialcustomvllmyocov2_Qwen25-7B_cuda124_py312_nocppc_rerun_longgen
# LOAD_FORMAT=dummy
# BACKEND="vllm"
# MODEL="Qwen/Qwen2.5-7B"
# # /home/aiscuser/.local/bin/vllm serve Qwen/Qwen2.5-7B --host 127.0.0.1 --port 26501 --trust-remote-code --load-format dummy --served-model-name BENCHMARK_MODEL_NAME --tensor-parallel-size 1 --max-model-len 131072 --max-seq-len-to-capture 131072 --enable-chunked-prefill false --no-enable-prefix-caching

# python ./run_benchmark.py --backend ${BACKEND}  --model ${MODEL} --max_prompt_length 128000 --mean_prompt_length 2000 --mean_max_new_tokens 32000 --tp_size 1 --out_json_dir ${OUT_DIR} --load_format ${LOAD_FORMAT} --stream --overwrite_results --yocov2 --use_editable --port 26501

# # ERROR RuntimeError: Paged KV cache block size must be divisible by 16
# OUT_DIR=./results_20250529_benchmark_yocov2newdrop_essentialcustomvllmyocov2_phi4miniinstruct_cuda124_py312_nocppc_rerun_longgen
# LOAD_FORMAT=dummy
# BACKEND="vllm"
# MODEL="microsoft/Phi-4-mini-instruct"
# python ./run_benchmark.py --backend ${BACKEND}  --model ${MODEL} --max_prompt_length 128000 --mean_prompt_length 2000 --mean_max_new_tokens 32000 --tp_size 1 --out_json_dir ${OUT_DIR} --load_format ${LOAD_FORMAT} --stream --overwrite_results --yocov2 --use_editable --port 26500