#!/bin/bash
# source me!
conda create -n myenv20250325RBphyagipy312yocov2noda python=3.12 -y
## If conda activate fails, then need to run this command 
source activate myenv20250325RBphyagipy312yocov2noda
conda activate myenv20250325RBphyagipy312yocov2noda
## verify that the correct env is used by
conda env list

# make sure you download and activate conda (via miniconda) first

# git clone & checkout https://github.com/microsoft/vllm/tree/congcongchen/yoco_v2_rebase_main_swa_no_memory_optimizationat commit 61494be7d7e4ec447369a2a82565c753565eb310
cd /data/users/adatkins/dev/phivnext/yoco/yocov2/20250325_rebased_yocov2NODA_vllm

conda install -y ccache
export MAX_JOBS=8192 # set this to larger num to make build faster
export NVCC_THREADS=128

pip install --user -e . -vvv # This may take 5-10 minutes.

# for Amit's benchmark
pip install matplotlib tabulate 

cd /data/users/adatkins/dev/phivnext/yoco/yocov2/DeepSpeedExamples/benchmarks/inference/mii
