
OUT_DIR=./results_phi4_dev
LOAD_FORMAT=dummy
BACKEND="vllm"
MODEL="microsoft/phi-4"

pkill -f vllm
sleep 10

python ./run_benchmark.py --backend ${BACKEND}  --model ${MODEL} --mean_prompt_length 500 --mean_max_new_tokens 500 --tp_size 1 --out_json_dir ${OUT_DIR} --load_format ${LOAD_FORMAT} --stream  --overwrite_results