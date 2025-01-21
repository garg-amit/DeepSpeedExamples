# Copyright (c) Microsoft Corporation.
# SPDX-License-Identifier: Apache-2.0

# DeepSpeed Team

LOAD_FORMAT=dummy
BACKEND=vllm
OUT_DIR=results_dev_benchmark_yocov2newdrop_flashattn
# MODEL="/data/users/adatkins/dev/phivnext/yoco/yocov2/DeepSpeedExamples/benchmarks/inference/mii/dummy_checkpoints/yocov2_samba_no_da_hf"
MODEL="/data/users/adatkins/dev/phivnext/yoco/yocov2/MoE/qyocov2/checkpoint/"

python ./run_benchmark.py --backend ${BACKEND}  --model ${MODEL} --mean_prompt_length 8000 --mean_max_new_tokens 2000 --tp_size 1 --out_json_dir ${OUT_DIR} --load_format ${LOAD_FORMAT} --stream --cuda_visible_devices 0 --port 26500 --overwrite_results
