#!/bin/bash
# source me!

# make sure you download and activate conda (via miniconda) first
# https://www.anaconda.com/docs/getting-started/miniconda/install#macos-linux-installation
# wget https://repo.anaconda.com/miniconda/Miniconda3-latest-Linux-x86_64.sh
# then `source ~/.bashrc`
conda create -n myenvdefault073phyagi312_4 python=3.12 -y
#conda create -n myenvdefault073phyagi310_3 python=3.10 -y
#conda create -n myenvdefault073phyagi python=3.12 -y
## If conda activate fails, then need to run this command 
source activate myenvdefault073phyagi312_4
conda activate myenvdefault073phyagi312_4
## verify that the correct env is used by
conda env list

conda install -y ccache
export MAX_JOBS=8192 # set this to larger num to make build faster
export NVCC_THREADS=128

pip3 install torch torchvision torchaudio --index-url https://download.pytorch.org/whl/cu124
pip install vllm==0.7.3
# pip uninstall -y transformers
# uses newer transformers by default; can do this to be end of march after uninstall but why pip install transformers==v4.50.3

# for Amit's benchmark
pip install matplotlib tabulate 

cd /data/users/adatkins/dev/phivnext/yoco/yocov2/DeepSpeedExamples/benchmarks/inference/mii
