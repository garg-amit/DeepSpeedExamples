# Copyright (c) Microsoft Corporation.
# SPDX-License-Identifier: Apache-2.0

# DeepSpeed Team

import argparse
import os
import subprocess
import time


try:
    from .utils import parse_args, SERVER_PARAMS, BENCHMARK_MODEL_NAME
except ImportError:
    from utils import parse_args, SERVER_PARAMS, BENCHMARK_MODEL_NAME


def start_server(args: argparse.Namespace) -> None:
    start_server_fns = {
        "fastgen": start_fastgen_server,
        "vllm": start_vllm_server,
        "aml": start_aml_server,
        "openai": start_openai_server,
    }
    start_fn = start_server_fns[args.backend]
    start_fn(args)


def start_vllm_server(args: argparse.Namespace) -> None:
    # ValueError: The model's max seq len (200000) is larger than the maximum number of tokens that can be stored in KV cache (195104). Try increasing `gpu_memory_utilization` or decreasing `max_model_len` when initializing the engine.
    max_model_len = 104208 # default to custom yocov2
    # <= 32k is needed for the new rebased codebase

    # to prevent `ValueError: The model's max seq len (100000) is larger than the maximum number of tokens that can be stored in KV cache (30928). Try increasing `gpu_memory_utilization` or decreasing `max_model_len` when initializing the engine.`:
    if "phi-3.5-mini" in args.model.lower():
        max_model_len = 30928
    # ValueError: The model's max seq len (131072) is larger than the maximum number of tokens that can be stored in KV cache (118912). Try increasing `gpu_memory_utilization` or decreasing `max_model_len` when initializing the engine.
    elif "llama-3.2-3b" in args.model.lower():
        max_model_len = 118912
    elif "phi4" in args.model.lower() or "phi-4" in args.model.lower():
        max_model_len = 131072
    elif args.disable_chunked_prefill:
        max_model_len = 32000

    cmd = "vllm"
    if args.use_editable:
        cmd = "/home/aiscuser/.local/bin/vllm"
    elif "llama" in args.model.lower() or "phi-4" in args.model.lower():
        cmd = "vllm"
    elif "yoco" in args.model.lower():
        cmd = "/home/aiscuser/.local/bin/vllm"

    vllm_cmd = (
        cmd,
        "serve",
        args.model,
        "--host",
        "127.0.0.1",
        "--port",
        str(args.port),
        "--trust-remote-code",
        "--load-format",
        args.load_format,
        "--served-model-name",
        BENCHMARK_MODEL_NAME,
        "--tensor-parallel-size",
        str(args.tp_size),
        "--max-model-len",
        str(max_model_len), # `--max-model-len` causes issues --- but may still be needed? 16384. Can override with env var VLLM_ALLOW_LONG_MAX_MODEL_LEN
        "--max-seq-len-to-capture",
        str(max_model_len),
    )

    if args.disable_chunked_prefill:
        vllm_cmd += (
            "--enable-chunked-prefill", # always needed with yocov2 else `"prefix caching not supported"`
            "false"
        )
        print(f"--HERE! f{vllm_cmd=}--")

    if args.enforce_eager:
        vllm_cmd += ("--enforce-eager",)

    print(vllm_cmd)
    # assert 0

    my_env = os.environ.copy()
    my_env["VLLM_ALLOW_LONG_MAX_MODEL_LEN"] = "true" # TODO need this?
    my_env["CUDA_VISIBLE_DEVICES"] = str(args.cuda_visible_devices)
    if args.vllm_profile_dir:
        my_env["VLLM_TORCH_PROFILER_DIR"] = args.vllm_profile_dir

    print("START THE SERVER!")
    time.sleep(30)
    # comment out the below and start the server yourself to manually debug any weirdness
    # important since we lose track of the process running the vllm server: we only track it starting the server

    # p = subprocess.Popen(
    #     vllm_cmd, stdout=subprocess.DEVNULL, stderr=subprocess.PIPE, close_fds=True, env=my_env
    # )
    # start_time = time.time()
    # timeout_after = 60 * 5  # 5 minutes
    # while True:
    #     # line = ""
    #     # for l in p.stderr.readlines(): 
    #     #     print(f"SERVER ERR? {l.decode('utf-8')}")
    #     # #line = "".join([l.decode("utf-8") for l in p.stderr.readlines()]) # causes a hang!!
    #     # #print(f"SERVER ERR?: {line}")
        
    #     line = p.stderr.readline().decode("utf-8")
    #     # print(f"SERVER ERR full?: {line}")
    #     if "Application startup complete" in line:
    #         break
    #     if "error" in line.lower():
    #         p.terminate()
    #         stop_vllm_server(args)
    #         raise RuntimeError(f"Error starting VLLM server: {line}")
    #     if time.time() - start_time > timeout_after:
    #         p.terminate()
    #         stop_vllm_server(args)
    #         raise TimeoutError("Timed out waiting for VLLM server to start")
    #     time.sleep(1)


def start_fastgen_server(args: argparse.Namespace) -> None:
    import mii
    from deepspeed.inference import RaggedInferenceEngineConfig, DeepSpeedTPConfig
    from deepspeed.inference.v2.ragged import DSStateManagerConfig

    tp_config = DeepSpeedTPConfig(tp_size=args.tp_size)
    mgr_config = DSStateManagerConfig(
        max_ragged_batch_size=args.max_ragged_batch_size,
        max_ragged_sequence_count=args.max_ragged_batch_size,
    )
    inference_config = RaggedInferenceEngineConfig(
        tensor_parallel=tp_config, state_manager=mgr_config
    )
    if args.fp6:
        quantization_mode = 'wf6af16'
    else:
        quantization_mode = None
    mii.serve(
        args.model,
        deployment_name=args.deployment_name,
        tensor_parallel=args.tp_size,
        inference_engine_config=inference_config,
        replica_num=args.num_replicas,
        quantization_mode=quantization_mode
    )


def start_aml_server(args: argparse.Namespace) -> None:
    raise NotImplementedError(
        "AML server start not implemented. Please use Azure Portal to start the server."
    )

def start_openai_server(args: argparse.Namespace) -> None:
    # openai api has no command to stop server
    pass

def stop_server(args: argparse.Namespace) -> None:
    stop_server_fns = {
        "fastgen": stop_fastgen_server,
        "vllm": stop_vllm_server,
        "aml": stop_aml_server,
        "openai": stop_openai_server,
    }
    print(f"!!! KILL VLLM YOCO !!! {args.backend=} {stop_server_fns[args.backend]=}")
    stop_fn = stop_server_fns[args.backend]
    stop_fn(args)
    time.sleep(10)


def stop_vllm_server(args: argparse.Namespace) -> None:
    if not args.parallel:
        vllm_cmd = ("pkill", "-f", "/home/aiscuser/.local/bin/vllm")
        p = subprocess.Popen(vllm_cmd, stdout=subprocess.PIPE, stderr=subprocess.PIPE)
        p.wait()


def stop_fastgen_server(args: argparse.Namespace) -> None:
    import mii

    mii.client(args.deployment_name).terminate_server()


def stop_aml_server(args: argparse.Namespace) -> None:
    raise NotImplementedError(
        "AML server stop not implemented. Please use Azure Portal to stop the server."
    )

def stop_openai_server(args: argparse.Namespace) -> None:
    # openai api has no command to stop server
    pass

if __name__ == "__main__":
    args = parse_args(server_args=True)

    if args.cmd == "start":
        start_server(args)
    elif args.cmd == "stop":
        stop_server(args)
    elif args.cmd == "restart":
        stop_server(args)
        start_server(args)
    else:
        raise ValueError(f"Invalid command {args.cmd}")
