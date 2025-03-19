# Copyright (c) Microsoft Corporation.
# SPDX-License-Identifier: Apache-2.0

# DeepSpeed Team

OUT_DIR=./results_20250319_benchmark_yocov2newdrop_yocov2_cuda124
LOAD_FORMAT=dummy
BACKEND="vllm"
MODEL="/data/users/adatkins/dev/phivnext/yoco/yocov2/MoE/qyocov2/checkpoint/"

# basic

python ./run_benchmark.py --backend ${BACKEND}  --model ${MODEL} --max_prompt_length 128000 --mean_prompt_length 500 --mean_max_new_tokens 500 --tp_size 1 --out_json_dir ${OUT_DIR} --load_format ${LOAD_FORMAT} --stream  --overwrite_results --port 26500 --parallel --cuda_visible_devices 0 --use_editable --yocov2 &

python ./run_benchmark.py --backend ${BACKEND}  --model ${MODEL} --max_prompt_length 128000 --mean_prompt_length 4000 --mean_max_new_tokens 500 --tp_size 1 --out_json_dir ${OUT_DIR} --load_format ${LOAD_FORMAT} --stream  --overwrite_results --port 26501 --parallel --cuda_visible_devices 1 --use_editable --yocov2 &

python ./run_benchmark.py --backend ${BACKEND}  --model ${MODEL} --max_prompt_length 128000 --mean_prompt_length 4000 --mean_max_new_tokens 4000 --tp_size 1 --out_json_dir ${OUT_DIR} --load_format ${LOAD_FORMAT} --stream  --overwrite_results --port 26502 --parallel --cuda_visible_devices 2 --use_editable --yocov2 &

# longer prompt

python ./run_benchmark.py --backend ${BACKEND}  --model ${MODEL} --max_prompt_length 128000 --mean_prompt_length 8000 --mean_max_new_tokens 500 --tp_size 1 --out_json_dir ${OUT_DIR} --load_format ${LOAD_FORMAT} --stream  --overwrite_results --port 26503 --parallel --cuda_visible_devices 3 --use_editable --yocov2 &

# longer gen

python ./run_benchmark.py --backend ${BACKEND}  --model ${MODEL} --max_prompt_length 128000 --mean_prompt_length 2000 --mean_max_new_tokens 8000 --tp_size 1 --out_json_dir ${OUT_DIR} --load_format ${LOAD_FORMAT} --stream  --overwrite_results --port 26504 --parallel --cuda_visible_devices 4 --use_editable --yocov2 &

# extreme long prompt

python ./run_benchmark.py --backend ${BACKEND}  --model ${MODEL} --max_prompt_length 128000 --mean_prompt_length 64000 --mean_max_new_tokens 500 --tp_size 1 --out_json_dir ${OUT_DIR} --load_format ${LOAD_FORMAT} --stream  --overwrite_results --port 26505 --parallel --cuda_visible_devices 5 --use_editable --yocov2 &

# extreme long gen

python ./run_benchmark.py --backend ${BACKEND}  --model ${MODEL} --max_prompt_length 128000 --mean_prompt_length 500 --mean_max_new_tokens 64000 --tp_size 1 --out_json_dir ${OUT_DIR} --load_format ${LOAD_FORMAT} --stream  --overwrite_results --port 26506 --parallel --cuda_visible_devices 6 --use_editable --yocov2 &

# extreme long both

python ./run_benchmark.py --backend ${BACKEND}  --model ${MODEL} --max_prompt_length 128000 --mean_prompt_length 32000 --mean_max_new_tokens 32000 --tp_size 1 --out_json_dir ${OUT_DIR} --load_format ${LOAD_FORMAT} --stream  --overwrite_results --port 26507 --parallel --cuda_visible_devices 7 --use_editable --yocov2 &