# Copyright (c) Microsoft Corporation.
# SPDX-License-Identifier: Apache-2.0

# DeepSpeed Team

LOAD_FORMAT=dummy
BACKEND=vllm
OUT_DIR=results_20250116_benchmark_yocov2newdrop_parallel_advanced_without_cuda
#MODEL="/data/users/adatkins/dev/phivnext/yoco/yocov2/DeepSpeedExamples/benchmarks/inference/mii/dummy_checkpoints/yocov2_samba_no_da_hf"
MODEL="/data/users/adatkins/dev/phivnext/yoco/yocov2/MoE/qyocov2/checkpoint/"

# longgen fail: max seqlen doesn't have an effect?

# success and still running
python ./run_benchmark.py --backend ${BACKEND}  --model ${MODEL} --mean_prompt_length 4000 --mean_max_new_tokens 500 --tp_size 1 --out_json_dir ${OUT_DIR} --load_format ${LOAD_FORMAT} --stream --cuda_visible_devices 0 --port 26500 --overwrite_results --parallel --enforce_eager &

python ./run_benchmark.py --backend ${BACKEND}  --model ${MODEL} --mean_prompt_length 4000 --mean_max_new_tokens 4000 --tp_size 1 --out_json_dir ${OUT_DIR} --load_format ${LOAD_FORMAT} --stream --cuda_visible_devices 1 --port 26501 --overwrite_results --parallel  --enforce_eager &

# TODO: long prompt AND long completion?


python ./run_benchmark.py --backend ${BACKEND}  --model ${MODEL} --mean_prompt_length 500 --mean_max_new_tokens 8000 --tp_size 1 --out_json_dir ${OUT_DIR} --load_format ${LOAD_FORMAT} --stream --cuda_visible_devices 2 --port 26502 --overwrite_results --parallel --enforce_eager &

python ./run_benchmark.py --backend ${BACKEND}  --model ${MODEL} --mean_prompt_length 500 --mean_max_new_tokens 16000 --tp_size 1 --out_json_dir ${OUT_DIR} --load_format ${LOAD_FORMAT} --stream --cuda_visible_devices 3 --port 26503 --overwrite_results --parallel --enforce_eager &



# # success and still running
python ./run_benchmark.py --backend ${BACKEND}  --model ${MODEL} --mean_prompt_length 8000 --mean_max_new_tokens 500 --tp_size 1 --out_json_dir ${OUT_DIR} --load_format ${LOAD_FORMAT} --stream --cuda_visible_devices 4 --port 26504 --overwrite_results --parallel --enforce_eager &

python ./run_benchmark.py --backend ${BACKEND}  --model ${MODEL} --mean_prompt_length 8000 --mean_max_new_tokens 4000 --tp_size 1 --out_json_dir ${OUT_DIR} --load_format ${LOAD_FORMAT} --stream --cuda_visible_devices 5 --port 26505 --overwrite_results --parallel  --enforce_eager &



# # success and still running
python ./run_benchmark.py --backend ${BACKEND}  --model ${MODEL} --mean_prompt_length 16000 --mean_max_new_tokens 500 --tp_size 1 --out_json_dir ${OUT_DIR} --load_format ${LOAD_FORMAT} --stream --cuda_visible_devices 6 --port 26506 --overwrite_results --parallel --enforce_eager &

python ./run_benchmark.py --backend ${BACKEND}  --model ${MODEL} --mean_prompt_length 16000 --mean_max_new_tokens 4000 --tp_size 1 --out_json_dir ${OUT_DIR} --load_format ${LOAD_FORMAT} --stream --cuda_visible_devices 7 --port 26507 --overwrite_results --parallel  --enforce_eager &
