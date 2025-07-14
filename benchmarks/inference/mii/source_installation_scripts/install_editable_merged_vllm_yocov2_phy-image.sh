#!/bin/bash
# make sure you download and activate conda (via miniconda) first
# source me!
conda create -n myenvmergedyocov2phyagipy312 python=3.12 -y
source activate myenvmergedyocov2phyagipy312
conda activate myenvmergedyocov2phyagipy312
## verify that the correct env is used by
conda env list

cd /data/users/adatkins/dev/phivnext/yoco/yocov2/editable_merged_yocov2_vllm

conda install -y ccache
export MAX_JOBS=8192
export NVCC_THREADS=128

rm -rf .deps/
pip install jinja2
pip install pandas
pip install --user -e . -vvv

# for Amit's benchmark
pip install matplotlib tabulate ipdb

# ready to go
cd /data/users/adatkins/dev/phivnext/yoco/yocov2/DeepSpeedExamples/benchmarks/inference/mii
