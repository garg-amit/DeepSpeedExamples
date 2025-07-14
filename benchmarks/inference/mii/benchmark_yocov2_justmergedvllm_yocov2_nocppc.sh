# Copyright (c) Microsoft Corporation.
# SPDX-License-Identifier: Apache-2.0

# DeepSpeed Team

# VLLM COMMAND=/home/aiscuser/.local/bin/vllm serve microsoft/Phi-4-mini-flash-reasoning --host 127.0.0.1 --port 26500 --trust-remote-code --load-format dummy --served-model-name BENCHMARK_MODEL_NAME --tensor-parallel-size 1 --max-model-len 104208 --max-seq-len-to-capture 104208 --no-enable-chunked-prefill --no-enable-prefix-caching
# https://huggingface.co/microsoft/Phi-4-mini-flash-reasoning
# https://github.com/vllm-project/vllm/commit/2c11a738b35e6e65731c5ad7774581ca2c33dc6a

LOAD_FORMAT=dummy
BACKEND="vllm"
MODEL="microsoft/Phi-4-mini-flash-reasoning"

# OUT_DIR=./results_20250714_benchmark_paper2_justmergedvllm_yocov2_cuda124_py312_nocppc_sanity
# python ./run_benchmark.py --backend ${BACKEND}  --model ${MODEL} --max_prompt_length 128000 --mean_prompt_length 500 --mean_max_new_tokens 500 --tp_size 1 --out_json_dir ${OUT_DIR} --load_format ${LOAD_FORMAT} --stream  --overwrite_results --use_editable --yocov2


# OUT_DIR=./results_20250714_benchmark_paper2_justmergedvllm_yocov2_cuda124_py312_nocppc_paper_repro2
# python ./run_benchmark.py --backend ${BACKEND}  --model ${MODEL} --max_prompt_length 128000 --mean_prompt_length 2000 --mean_max_new_tokens 32000 --tp_size 1 --out_json_dir ${OUT_DIR} --load_format ${LOAD_FORMAT} --stream  --overwrite_results --use_editable --yocov2 --parallel --port 26500 --cuda_visible_devices 0  &

# python ./run_benchmark.py --backend ${BACKEND}  --model ${MODEL} --max_prompt_length 128000 --mean_prompt_length 32000 --mean_max_new_tokens 500 --tp_size 1 --out_json_dir ${OUT_DIR} --load_format ${LOAD_FORMAT} --stream  --overwrite_results --use_editable --yocov2 --parallel --port 26501 --cuda_visible_devices 1  &



OUT_DIR=./results_20250715_benchmark_paper2_justmergedvllm_yocov2_cuda124_py312_nocppc_for_generation_latencies
python ./run_benchmark.py --backend ${BACKEND}  --model ${MODEL} --max_prompt_length 128000 --mean_prompt_length 2000 --mean_max_new_tokens 2000 --tp_size 1 --out_json_dir ${OUT_DIR} --load_format ${LOAD_FORMAT} --stream  --overwrite_results --use_editable --yocov2 --parallel --cuda_visible_devices 0 --port 26500 &

python ./run_benchmark.py --backend ${BACKEND}  --model ${MODEL} --max_prompt_length 128000 --mean_prompt_length 2000 --mean_max_new_tokens 4000 --tp_size 1 --out_json_dir ${OUT_DIR} --load_format ${LOAD_FORMAT} --stream  --overwrite_results --use_editable --yocov2 --parallel --cuda_visible_devices 1 --port 26501 &

python ./run_benchmark.py --backend ${BACKEND}  --model ${MODEL} --max_prompt_length 128000 --mean_prompt_length 2000 --mean_max_new_tokens 8000 --tp_size 1 --out_json_dir ${OUT_DIR} --load_format ${LOAD_FORMAT} --stream  --overwrite_results --use_editable --yocov2 --parallel --cuda_visible_devices 2 --port 26502 &

python ./run_benchmark.py --backend ${BACKEND}  --model ${MODEL} --max_prompt_length 128000 --mean_prompt_length 2000 --mean_max_new_tokens 16000 --tp_size 1 --out_json_dir ${OUT_DIR} --load_format ${LOAD_FORMAT} --stream  --overwrite_results --use_editable --yocov2 --parallel --cuda_visible_devices 3 --port 26503 &

python ./run_benchmark.py --backend ${BACKEND}  --model ${MODEL} --max_prompt_length 128000 --mean_prompt_length 2000 --mean_max_new_tokens 32000 --tp_size 1 --out_json_dir ${OUT_DIR} --load_format ${LOAD_FORMAT} --stream  --overwrite_results --use_editable --yocov2 --parallel --cuda_visible_devices 4 --port 26504 &

python ./run_benchmark.py --backend ${BACKEND}  --model ${MODEL} --max_prompt_length 128000 --mean_prompt_length 2000 --mean_max_new_tokens 500 --tp_size 1 --out_json_dir ${OUT_DIR} --load_format ${LOAD_FORMAT} --stream  --overwrite_results --use_editable --yocov2 --parallel --cuda_visible_devices 5 --port 26505 &
