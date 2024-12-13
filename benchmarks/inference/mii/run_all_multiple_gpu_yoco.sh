# Copyright (c) Microsoft Corporation.
# SPDX-License-Identifier: Apache-2.0

# DeepSpeed Team

MODELS=(
    /data/users/adatkins/dev/phivnext/yoco/yocov2/DeepSpeedExamples/benchmarks/inference/mii/dummy_checkpoints/yocov2_samba_no_da_hf
)
OUT_DIR=./results_multiple_gpu_yocov2_sans_da
LOAD_FORMAT=dummy
BACKEND="vllmyoco"

# NOTE `wait` on the PIDs doesn't work for some reason

python ./run_benchmark.py --backend ${BACKEND}  --model ${MODEL} --mean_prompt_length 50 --mean_max_new_tokens 10 --tp_size 1 --out_json_dir ${OUT_DIR} --load_format ${LOAD_FORMAT} --stream --cuda_visible_devices 0 --port 26500 --overwrite_results &

python ./run_benchmark.py --backend ${BACKEND}  --model ${MODEL} --mean_prompt_length 100 --mean_max_new_tokens 10 --tp_size 1 --out_json_dir ${OUT_DIR} --load_format ${LOAD_FORMAT} --stream --cuda_visible_devices 1 --port 26501 --overwrite_results &

python ./run_benchmark.py --backend ${BACKEND}  --model ${MODEL} --mean_prompt_length 200 --mean_max_new_tokens 10 --tp_size 1 --out_json_dir ${OUT_DIR} --load_format ${LOAD_FORMAT} --stream --cuda_visible_devices 2 --port 26502 --overwrite_results &
