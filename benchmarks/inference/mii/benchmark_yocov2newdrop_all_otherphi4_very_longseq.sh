# Copyright (c) Microsoft Corporation.
# SPDX-License-Identifier: Apache-2.0

# DeepSpeed Team

#OUT_DIR=./results_20250212_benchmark_yocov2newdrop_phi4miniinstruct
#OUT_DIR=./results_20250218_benchmark_yocov2newdrop_phi4miniinstruct_newvllm072
#OUT_DIR=./results_20250313_benchmark_yocov2newdrop_phi4miniMM_cuda124_maxseqlen_to_capture_verylongseq2
OUT_DIR=./results_20250313_benchmark_yocov2newdrop_phi4miniMM_cuda124_maxseqlen_to_capture_verylongseq2_justgen
LOAD_FORMAT=dummy
BACKEND="vllm"
MODEL="/data/users/adatkins/dev/phivnext/yoco/yocov2/Phi-4-Mini-Instruct"

pkill -f vllm
sleep 10

# > 32k

# # longer prompt
# python ./run_benchmark.py --backend ${BACKEND}  --model ${MODEL} --max_prompt_length 128000 --mean_prompt_length 32000 --mean_max_new_tokens 1000 --tp_size 1 --out_json_dir ${OUT_DIR} --load_format ${LOAD_FORMAT} --stream  --overwrite_results --port 26500 --parallel --cuda_visible_devices 0 &

# longer gen
python ./run_benchmark.py --backend ${BACKEND}  --model ${MODEL} --max_prompt_length 128000 --mean_prompt_length 1000 --mean_max_new_tokens 32000 --tp_size 1 --out_json_dir ${OUT_DIR} --load_format ${LOAD_FORMAT} --stream  --overwrite_results --port 26501 --parallel --cuda_visible_devices 1 &

# long both
python ./run_benchmark.py --backend ${BACKEND}  --model ${MODEL} --max_prompt_length 128000 --mean_prompt_length 32000 --mean_max_new_tokens 32000 --tp_size 1 --out_json_dir ${OUT_DIR} --load_format ${LOAD_FORMAT} --stream  --overwrite_results --port 26502 --parallel --cuda_visible_devices 2 &

# # very long prompt
# python ./run_benchmark.py --backend ${BACKEND}  --model ${MODEL} --max_prompt_length 128000 --mean_prompt_length 64000 --mean_max_new_tokens 1000 --tp_size 1 --out_json_dir ${OUT_DIR} --load_format ${LOAD_FORMAT} --stream  --overwrite_results --port 26503 --parallel --cuda_visible_devices 3 &

# very long gen
python ./run_benchmark.py --backend ${BACKEND}  --model ${MODEL} --max_prompt_length 128000 --mean_prompt_length 1000 --mean_max_new_tokens 64000 --tp_size 1 --out_json_dir ${OUT_DIR} --load_format ${LOAD_FORMAT} --stream  --overwrite_results --port 26504 --parallel --cuda_visible_devices 4 &

# very long both: 60/60 instead of 64/64 because averages/noise/truncation (?)
python ./run_benchmark.py --backend ${BACKEND}  --model ${MODEL} --max_prompt_length 128000 --mean_prompt_length 60000 --mean_max_new_tokens 60000 --tp_size 1 --out_json_dir ${OUT_DIR} --load_format ${LOAD_FORMAT} --stream  --overwrite_results --port 26505 --parallel --cuda_visible_devices 5 &

# # extremely long prompt
# python ./run_benchmark.py --backend ${BACKEND}  --model ${MODEL} --max_prompt_length 128000 --mean_prompt_length 120000 --mean_max_new_tokens 1000 --tp_size 1 --out_json_dir ${OUT_DIR} --load_format ${LOAD_FORMAT} --stream  --overwrite_results --port 26506 --parallel --cuda_visible_devices 6 &

# extremely long generation
python ./run_benchmark.py --backend ${BACKEND}  --model ${MODEL} --max_prompt_length 128000 --mean_prompt_length 1000 --mean_max_new_tokens 120000 --tp_size 1 --out_json_dir ${OUT_DIR} --load_format ${LOAD_FORMAT} --stream  --overwrite_results --port 26507 --parallel --cuda_visible_devices 7 &
