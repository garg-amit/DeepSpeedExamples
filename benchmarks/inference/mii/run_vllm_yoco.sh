#!/bin/bash
CHECKPOINT_PATH=/stdblob/users/adatkins/dev/phivnext/checkpoints/yoco/yocov1_samba_hf/hf_version/

# ~/.local/bin/vllm serve $CHECKPOINT_PATH --dtype auto --trust-remote-code --max-model-len 100000 --enforce-eager --load-format dummy --host  127.0.0.1  --port  26500

# also works
python -m vllm.entrypoints.api_server --host 127.0.0.1 --port 26500 --model $CHECKPOINT_PATH --trust-remote-code --load-format dummy --enforce-eager --max-model-len 100000