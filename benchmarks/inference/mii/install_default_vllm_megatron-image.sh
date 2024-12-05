#!/bin/bash

# BEWARE yocov2 needs a specific transformers version
# BEWARE non-yoco needs a specific vllm version
pip install -U --force-reinstall transformers flash-attn==2.4.2 torch==2.4.0 numpy==1.26.4 pandas accelerate tokenizers vllm==v0.6.3.post1 matplotlib deepspeed-mii>=0.2.0 tabulate
