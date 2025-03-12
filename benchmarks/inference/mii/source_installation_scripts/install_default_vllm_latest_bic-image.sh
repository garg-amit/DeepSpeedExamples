#!/bin/bash
# source me!
# tested and running with vllm==0.7.2
conda create -n myenvdefaultlatest python=3.10 -y
source activate myenvdefaultlatest
conda activate myenvdefaultlatest

conda install -y ccache
export MAX_JOBS=8192 # set this to larger num to make build faster
export NVCC_THREADS=128

#pip install torch torchvision torchaudio --index-url https://download.pytorch.org/whl/cu118

conda install -y pytorch pytorch-cuda=11.8 torchvision torchaudio -c pytorch -c nvidia
cd /data/users/adatkins/dev/phivnext/yoco/yocov2/upstream_src_main_vllm
pip install -e . --user
#pip install flash-attn

pip install transformers accelerate tokenizers tabulate matplotlib

cd /data/users/adatkins/dev/phivnext/yoco/yocov2/DeepSpeedExamples/benchmarks/inference/mii
