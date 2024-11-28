#!/bin/bash

# git clone https://github.com/vllm-project/vllm.git & git checkout yizhu1/yoco_samba

cd vllm
conda install -y ccache
export MAX_JOBS=8192 # set this to larger num to make build faster
export NVCC_THREADS=128
pip install --user -e . -vvv # This may take 5-10 minutes.