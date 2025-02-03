#!/bin/bash
# source me!
conda create -n myenvdefault python=3.10 -y
## If conda activate fails, then need to run this command 
source activate myenvdefault
conda activate myenvdefault

conda install -y ccache
export MAX_JOBS=8192 # set this to larger num to make build faster
export NVCC_THREADS=128

## UNTESTED!!!!

conda install -y pytorch pytorch-cuda=11.8 -c pytorch -c nvidia
# BEWARE yocov2 needs a specific transformers version
# BEWARE non-yoco needs a specific vllm version
# TODO may work with a more recent version of flash attn, numpy
pip install -U --force-reinstall flash-attn==v2.7.3 transformers==v4.48.1 accelerate tokenizers deepspeed-mii>=0.2.0 vllm==v0.6.3.post1 tabulate matplotlib
#pip install -U --force-reinstall transformers flash-attn==2.4.2 numpy==1.24.4 pandas accelerate tokenizers  matplotlib deepspeed-mii>=0.2.0 tabulate vllm==v0.6.3.post1
