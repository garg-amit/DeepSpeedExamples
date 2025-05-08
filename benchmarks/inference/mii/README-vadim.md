# VLLM Online Benchmarking Setup

## Install vllm

To install vllm, you can use pip:

```bash
pip install vllm
```

Or to install from source:
```
export CUDA_HOME=/usr/local/cuda
export PATH="${CUDA_HOME}/bin:$PATH"
VLLM_USE_PRECOMPILED=1 pip install -e 
```

## Benchmark setup:
`git clone https://github.com/garg-amit/DeepSpeedExamples -b vadim/bech_setup`

Edit `DeepSpeedExamples/benchmarks/inference/mii/src/server.py` to update the vLLM config, specifically the LoRA modules path (typically subfolders of the model paths):

```
"speech=/home/azureuser/cloudfiles/code/Users/vadimma/src/Phi-4-Mini-MM/speech-lora",
"vision=/home/azureuser/cloudfiles/code/Users/vadimma/src/Phi-4-Mini-MM/vision-lora"
```

## Run Benchmarking Script
```
cd DeepSpeedExamples/benchmarks/inference/mii
./run_all_lens.sh
```
### Things to Review in the Script
```
MODELS="/home/azureuser/cloudfiles/code/Users/vadimma/src/Phi-4-Mini-MM/"
AUDIO_DIR=/home/azureuser/cloudfiles/code/Users/vadimma/audio-ds
```

## If there are issues running the script (typically due to starting the server), try starting it manually to see detailed log output:

```vllm serve /home/azureuser/cloudfiles/code/Users/vadimma/src/Phi-4-Mini-MM/ \
  --host 127.0.0.1 \
  --port 26500 \
  --tensor-parallel-size 1 \
  --trust-remote-code \
  --load-format auto \
  --max-model-len 32000 \
  --enable-lora \
  --max-lora-rank 512 \
  --lora-extra-vocab-size 256 \
  --limit-mm-per-prompt audio=100 \
  --max-loras 5 \
  --lora-modules speech=/home/azureuser/cloudfiles/code/Users/vadimma/src/Phi-4-Mini-MM/speech-lora \
                 vision=/home/azureuser/cloudfiles/code/Users/vadimma/src/Phi-4-Mini-MM/vision-lora

```