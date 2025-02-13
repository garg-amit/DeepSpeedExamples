#!/bin/bash
# source me!
conda create -n myenvperfeditableccrb python=3.10 -y
## If conda activate fails, then need to run this command 
source activate myenvperfeditableccrb
conda activate myenvperfeditableccrb
## verify that the correct env is used by
conda env list

# git clone & checkout https://github.com/microsoft/vllm/tree/congcongchen/yoco_v2_rebase_main_swa_no_memory_optimizationat commit 61494be7d7e4ec447369a2a82565c753565eb310
cd /data/users/adatkins/dev/phivnext/yoco/yocov2/perf_editable_ccrb_custom_vllm

conda install -y ccache
export MAX_JOBS=8192 # set this to larger num to make build faster
export NVCC_THREADS=128

# # opt 1
# pip install flash-attn==2.4.2 # --force-reinstall should install torch?

pip install --user -e . -vvv # This may take 5-10 minutes.

# for Amit's benchmark
pip install matplotlib tabulate deepspeed-mii>=0.2.0 

# opt 2
pip install uninstall flash-attn
pip install -U flash-attn
# pip install flash-attn==2.4.2 # fails

cd /data/users/adatkins/dev/phivnext/yoco/yocov2/DeepSpeedExamples/benchmarks/inference/mii