# Copyright (c) Microsoft Corporation.
# SPDX-License-Identifier: Apache-2.0

# DeepSpeed Team

LOAD_FORMAT=dummy
BACKEND="vllm"

OUT_DIR=./results_profile_llama32-3B_without_DA_cudagraph_ON
MODEL="meta-llama/Llama-3.2-3B"


python ./run_benchmark.py --backend ${BACKEND}  --model ${MODEL} --mean_prompt_length 500 --mean_max_new_tokens 500 --tp_size 1 --out_json_dir ${OUT_DIR} --load_format ${LOAD_FORMAT} --stream --cuda_visible_devices 0 --port 26500 --overwrite_results --parallel &

python ./run_benchmark.py --backend ${BACKEND}  --model ${MODEL} --mean_prompt_length 500 --mean_max_new_tokens 4000 --tp_size 1 --out_json_dir ${OUT_DIR} --load_format ${LOAD_FORMAT} --stream --cuda_visible_devices 1 --port 26501 --overwrite_results --parallel &

python ./run_benchmark.py --backend ${BACKEND}  --model ${MODEL} --mean_prompt_length 4000 --mean_max_new_tokens 500 --tp_size 1 --out_json_dir ${OUT_DIR} --load_format ${LOAD_FORMAT} --stream --cuda_visible_devices 2 --port 26502 --overwrite_results --parallel &

# # error with this one?
# python ./run_benchmark.py --backend ${BACKEND}  --model ${MODEL} --mean_prompt_length 3500 --mean_max_new_tokens 3500 --tp_size 1 --out_json_dir ${OUT_DIR} --load_format ${LOAD_FORMAT} --stream --cuda_visible_devices 3 --port 26503 --overwrite_results --parallel &

OUT_DIR=./results_profile_llama32-3B_without_DA_cudagraph_OFF
python ./run_benchmark.py --backend ${BACKEND}  --model ${MODEL} --mean_prompt_length 500 --mean_max_new_tokens 500 --tp_size 1 --out_json_dir ${OUT_DIR} --load_format ${LOAD_FORMAT} --stream --cuda_visible_devices 4 --port 26504 --overwrite_results --parallel --enforce_eager &

python ./run_benchmark.py --backend ${BACKEND}  --model ${MODEL} --mean_prompt_length 500 --mean_max_new_tokens 4000 --tp_size 1 --out_json_dir ${OUT_DIR} --load_format ${LOAD_FORMAT} --stream --cuda_visible_devices 5 --port 26505 --overwrite_results --parallel --enforce_eager &

python ./run_benchmark.py --backend ${BACKEND}  --model ${MODEL} --mean_prompt_length 4000 --mean_max_new_tokens 500 --tp_size 1 --out_json_dir ${OUT_DIR} --load_format ${LOAD_FORMAT} --stream --cuda_visible_devices 6 --port 26506 --overwrite_results --parallel --enforce_eager &

# # watch for error
# python ./run_benchmark.py --backend ${BACKEND}  --model ${MODEL} --mean_prompt_length 3500 --mean_max_new_tokens 3500 --tp_size 1 --out_json_dir ${OUT_DIR} --load_format ${LOAD_FORMAT} --stream --cuda_visible_devices 7 --port 26507 --overwrite_results --parallel --enforce_eager &
