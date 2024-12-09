#!/bin/bash
# source me!
conda create -n myenv python=3.10 -y
## If conda activate fails, then need to run this command 
source activate myenv
conda activate myenv
## verify that the correct env is used by
conda env list

# git clone & checkout https://github.com/microsoft/vllm/tree/congcongchen/yoco_v2 at commit 61494be7d7e4ec447369a2a82565c753565eb310
cd /data/users/adatkins/dev/phivnext/yoco/yocov2/vllm

conda install -y ccache
export MAX_JOBS=8192 # set this to larger num to make build faster
export NVCC_THREADS=128
pip install --user -e . -vvv # This may take 5-10 minutes.

# for Amit's benchmark
pip install matplotlib deepspeed-mii>=0.2.0 tabulate

cd /data/users/adatkins/dev/phivnext/yoco/yocov2/DeepSpeedExamples/benchmarks/inference/mii