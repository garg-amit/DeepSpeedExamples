#!/bin/bash
# source me!
# tested and running with vllm==0.7.0
conda create -n myenvdefaultlatest python=3.10 -y
source activate myenvdefaultlatest
conda activate myenvdefaultlatest

conda install -y ccache
export MAX_JOBS=8192 # set this to larger num to make build faster
export NVCC_THREADS=128

conda install -y pytorch pytorch-cuda=11.8 -c pytorch -c nvidia

pip install -U --force-reinstall transformers flash-attn accelerate tokenizers deepspeed-mii>=0.2.0 vllm tabulate matplotlib
