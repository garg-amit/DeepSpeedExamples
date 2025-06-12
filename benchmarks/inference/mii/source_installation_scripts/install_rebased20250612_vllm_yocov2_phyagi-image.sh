#!/bin/bash
# source me!
conda create -n myenv20250612RBphyagipy312 python=3.12 -y
## If conda activate fails, then need to run this command 
source activate myenv20250612RBphyagipy312
conda activate myenv20250612RBphyagipy312
## verify that the correct env is used by
conda env list

# make sure you download and activate conda (via miniconda) first

# git clone & checkout https://github.com/microsoft/vllm/tree/congcongchen/phi4-mini-shadow
cd /data/users/adatkins/dev/phivnext/yoco/yocov2/custom_vllm090
rm -rf .deps/
pip install jinja2 # TODO May not be necessary?
# TODO don't need https://anaconda.org/conda-forge/libstdcxx-ng/
pip install pandas # NEW and needed

conda install -y ccache
export MAX_JOBS=8192 # set this to larger num to make build faster
export NVCC_THREADS=128

pip install --user -e . -vvv # This may take 5-10 minutes.

# for Amit's benchmark
pip install matplotlib tabulate 

cd /data/users/adatkins/dev/phivnext/yoco/yocov2/DeepSpeedExamples/benchmarks/inference/mii
