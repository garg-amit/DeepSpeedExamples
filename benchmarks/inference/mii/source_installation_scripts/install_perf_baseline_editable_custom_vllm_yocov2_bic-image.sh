#!/bin/bash
# source me!

conda create -n myenvperfbaselineeditable python=3.10 -y
# If conda activate fails, then need to run this command 
source activate myenvperfbaselineeditable
conda activate myenvperfbaselineeditable
# verify that the correct env is used by
conda env list

cd /data/users/adatkins/dev/phivnext/yoco/yocov2/perf_baseline_vllm

conda install -y ccache ipython
export MAX_JOBS=8192 # set this to larger num to make build faster
export NVCC_THREADS=128

pip install --user -e . -vvv # This may take 5-10 minutes.

# for Amit's benchmark
pip install matplotlib tabulate deepspeed-mii>=0.2.0 

pip install uninstall flash-attn
pip install -U flash-attn

cd /data/users/adatkins/dev/phivnext/yoco/yocov2/DeepSpeedExamples/benchmarks/inference/mii
