#!/bin/bash
# source me!

# make sure you download and activate conda (via miniconda) first
# https://www.anaconda.com/docs/getting-started/miniconda/install#macos-linux-installation
# then `source ~/.bashrc`
conda create -n myenvlatestphyagi python=3.10 -y # TODO upgrade to python 310
## If conda activate fails, then need to run this command 
source activate myenvlatestphyagi
conda activate myenvlatestphyagi
## verify that the correct env is used by
conda env list

conda install -y ccache
export MAX_JOBS=8192 # set this to larger num to make build faster
export NVCC_THREADS=128

pip3 install torch torchvision torchaudio --index-url https://download.pytorch.org/whl/cu124
pip install vllm # no flash-attn uninstalls stuff

# for Amit's benchmark
pip install matplotlib tabulate 

cd /data/users/adatkins/dev/phivnext/yoco/yocov2/DeepSpeedExamples/benchmarks/inference/mii
