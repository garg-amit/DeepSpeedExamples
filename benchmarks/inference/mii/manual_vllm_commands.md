################
# BASELINE - SERVER - EXE - WORKING
VLLM_ALLOW_LONG_MAX_MODEL_LEN=true /home/aiscuser/.local/bin/vllm serve meta-llama/Llama-3.2-3B --host 127.0.0.1 --port 26500 --trust-remote-code --load-format dummy --served-model-name "BENCHMARK_MODEL_NAME" --tensor-parallel-size 1 --max-model-len 100000

curl http://localhost:26500/v1/completions -H "Content-Type: application/json" -d '{"prompt": "San Francisco is a","max_tokens": 128,"temperature": 0.1, "top_p": 0.95, "ignore_eos": true, "stream": true, "n":1, "model": "BENCHMARK_MODEL_NAME"}'
################
# BASELINE - SERVER - EXE - WORKING
VLLM_ALLOW_LONG_MAX_MODEL_LEN=true /home/aiscuser/.local/bin/vllm serve /data/users/adatkins/dev/phivnext/yoco/yocov2/DeepSpeedExamples/benchmarks/inference/mii/dummy_checkpoints/phi4mini_tied-gqa3-attn_head24_phi_impl_new_Tversion --host 127.0.0.1 --port 26500 --trust-remote-code --load-format dummy --served-model-name "BENCHMARK_MODEL_NAME" --tensor-parallel-size 1 --max-model-len 100000

curl http://localhost:26500/v1/completions -H "Content-Type: application/json" -d '{"prompt": "San Francisco is a","max_tokens": 128,"temperature": 0.1, "top_p": 0.95, "ignore_eos": true, "stream": true, "n":1, "model": "BENCHMARK_MODEL_NAME"}'
################
# YOCO - SERVER - EXE - WORKING
VLLM_ALLOW_LONG_MAX_MODEL_LEN=true /home/aiscuser/.local/bin/vllm serve /data/users/adatkins/dev/phivnext/yoco/yocov2/DeepSpeedExamples/benchmarks/inference/mii/dummy_checkpoints/yocov2_samba_no_da_hf --host 127.0.0.1 --port 26500 --trust-remote-code --load-format dummy --served-model-name "BENCHMARK_MODEL_NAME" --tensor-parallel-size 1 --max-model-len 100000

curl http://localhost:26500/v1/completions -H "Content-Type: application/json" -d '{"prompt": "San Francisco is a","max_tokens": 128,"temperature": 0.1, "top_p": 0.95, "ignore_eos": true, "stream": true, "n":1, "model": "BENCHMARK_MODEL_NAME"}'
################





# YOCO - SERVER - PYTHON MODULE - WORKING
VLLM_ALLOW_LONG_MAX_MODEL_LEN=true python -m vllm.entrypoints.api_server --model /data/users/adatkins/dev/phivnext/yoco/yocov2/DeepSpeedExamples/benchmarks/inference/mii/dummy_checkpoints/yocov2_samba_no_da_hf --host 127.0.0.1 --port 26500  --trust-remote-code --load-format dummy --served-model-name "BENCHMARK_MODEL_NAME" --tensor-parallel-size 1 --max-model-len 100000

### but curl doesn't seem to work: 200 but no output
curl http://localhost:26500/generate -H "Content-Type: application/json" -d '{"prompt": "San Francisco is a","max_tokens": 128,"temperature": 0.1, "top_p": 0.95, "ignore_eos": true, "stream": true, "n":1}'
