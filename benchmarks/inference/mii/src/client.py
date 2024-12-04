# Copyright (c) Microsoft Corporation.
# SPDX-License-Identifier: Apache-2.0

# DeepSpeed Team

import argparse
import asyncio
import json
import multiprocessing
import os
import queue
import random
import re
import requests
import subprocess
import threading
import time

from concurrent.futures import ProcessPoolExecutor, wait
from typing import List, Iterable, Union

import numpy as np
from transformers import AutoTokenizer

try:
    from .postprocess_results import ResponseDetails
    from .random_query_generator import RandomQueryGenerator
    from .sample_input import all_text
    from .utils import parse_args, print_summary, get_args_product, CLIENT_PARAMS, BENCHMARK_MODEL_NAME
except ImportError:
    from postprocess_results import ResponseDetails
    from random_query_generator import RandomQueryGenerator
    from sample_input import all_text
    from utils import parse_args, print_summary, get_args_product, CLIENT_PARAMS, BENCHMARK_MODEL_NAME


def call_fastgen(
    input_tokens: str, max_new_tokens: int, args: argparse.Namespace
) -> ResponseDetails:
    import mii

    client = mii.client(args.deployment_name)

    output_tokens = []
    token_gen_time = []
    time_last_token = 0

    def callback(response):
        nonlocal time_last_token
        # print(f"Received: {response[0].generated_text} time_last_token={time_last_token}")
        output_tokens.append(response[0].generated_text)
        time_now = time.time()
        token_gen_time.append(time_now - time_last_token)
        time_last_token = time_now

    time_last_token = start_time = time.time()
    token_gen_time = []
    if args.stream:
        output_tokens = []
        client.generate(
            input_tokens, max_new_tokens=max_new_tokens, streaming_fn=callback
        )
    else:
        result = client.generate(input_tokens, max_new_tokens=max_new_tokens)
        output_tokens = result[0].generated_text

    return ResponseDetails(
        generated_tokens=output_tokens,
        prompt=input_tokens,
        start_time=start_time,
        end_time=time.time(),
        model_time=0,
        token_gen_time=token_gen_time,
    )


def call_vllm(
    input_tokens: str, max_new_tokens: int, args: argparse.Namespace
) -> ResponseDetails:
    if not args.stream:
        raise NotImplementedError("Not implemented for non-streaming")

    api_url = "http://localhost:26500/generate"
    headers = {"User-Agent": "Benchmark Client"}
    pload = {
        "prompt": input_tokens,
        "n": 1,
        # "use_beam_search": False,
        "temperature": 1.0,
        "top_p": 0.9,
        "max_tokens": max_new_tokens,
        "ignore_eos": True, #False,
        "stream": args.stream,
    }

    def clear_line(n: int = 1) -> None:
        LINE_UP = "\033[1A"
        LINE_CLEAR = "\x1b[2K"
        for _ in range(n):
            print(LINE_UP, end=LINE_CLEAR, flush=True)

    def get_streaming_response(
        response: requests.Response, time_last_token
    ) -> Iterable[List[str]]:
        for chunk in response.iter_lines(
            chunk_size=8192, decode_unicode=False, delimiter=b"\0"
        ):
            if chunk:
                data = json.loads(chunk.decode("utf-8"))
                output = data["text"][0]
                time_now = time.time()
                yield output, time_now - time_last_token
                time_last_token = time_now

    # For non-streaming, but currently non-streaming is not fully implemented
    def get_response(response: requests.Response) -> List[str]:
        data = json.loads(response.content)
        output = data["text"]
        return output

    token_gen_time = []
    start_time = time.time()
    response = requests.post(api_url, headers=headers, json=pload, stream=args.stream)
    for h, t in get_streaming_response(response, start_time):
        output = h
        token_gen_time.append(t)

    return ResponseDetails(
        generated_tokens=output,
        prompt=input_tokens,
        start_time=start_time,
        end_time=time.time(),
        model_time=0,
        token_gen_time=token_gen_time,
    )


class TimeoutError(RuntimeError):
    pass

def call_vllm_yoco(prompt, max_new_tokens: int):
    """This is a worker function"""
    input_tokens = prompt #"San Francisco is a"
    pload = {
        "model": "BENCHMARK_MODEL_NAME",
        "prompt": input_tokens,
        "n": 1,
        "temperature": 1.0,
        "top_p": 0.9,
        "max_tokens": max_new_tokens,
        "ignore_eos": True,
        "stream": True,
    }

    # TODO error??? /bin/sh: 3: Syntax error: Unterminated quoted string
    pload_json = json.dumps(pload, ensure_ascii=False)
    print(f"{pload_json=}")
    cmd = f"""curl "http://localhost:26501/v1/completions" -X POST -H "Content-Type: application/json" -d '{pload_json}'"""
    # TODO no buffering? https://stackoverflow.com/questions/8362428/stream-response-from-curl-request-without-waiting-for-it-to-finish
    output = ""
    start_time = time.time()
    last_data = None
    retries = 0
    MAX_RETRIES = 4
    while retries <= MAX_RETRIES:
        try:
            start_time = time.time()
            data = subprocess.run(cmd, capture_output=True, shell=True)
            last_data = data
            # TODO need something better than this, maybe generator? Or we could use `requests`
            # For this hack just do a bunch of ints since dependent on `get_summary` which only needs length conditional on type != str
            # see `get_summary`
            output1 = data.stdout.decode('utf-8')
            output = len(re.findall('finish_reason":\s*(null|"length")', output1, re.M)) * [1]

            # # for debugging
            # print(f"{len(output)=} {output=}")
            # print(data.stderr.decode('utf-8'))
            data.check_returncode() # https://docs.python.org/3/library/subprocess.html
            break
        except subprocess.CalledProcessError:
            retries += 1
            # print(f"~~~ retrying {retries=} ~~~")
            # print(f"\n{last_data.returncode=} {last_data.stdout=} {last_data.stderr=} {cmd=}")

    if retries >= MAX_RETRIES:
        # print("!!! MAX RETRIES !!!")
        # print(f"\n{last_data.returncode=} {last_data.stdout=} {last_data.stderr=} {cmd=}")
        raise TimeoutError("Maxed out the retries for the request!")
    
    end_time = time.time()
    token_gen_time = [float(end_time - start_time)] * 3 # this doesn't appear to be used in postprocess_results anyway

    return ResponseDetails(
        generated_tokens=output,
        prompt=input_tokens,
        start_time=start_time,
        end_time=end_time,
        model_time=0,
        token_gen_time=token_gen_time,
    )


# client talks with openai api
def call_openai(
    input_tokens: str, max_new_tokens: int, args: argparse.Namespace
) -> ResponseDetails:

    api_url = args.openai_api_url
    headers = {
        "User-Agent": "Benchmark Client",
        "Content-Type": "application/json",
        "Authorization": f"Bearer {args.openai_api_key}"
    }

    pload = {
        "prompt": input_tokens,
        "model": args.model,
        "n": 1,
        "use_beam_search": False,
        "temperature": 1.0,
        "top_p": 0.9,
        "max_tokens": max_new_tokens,
        "ignore_eos": False,
        "stream": args.stream,
    }

    def clear_line(n: int = 1) -> None:
        LINE_UP = "\033[1A"
        LINE_CLEAR = "\x1b[2K"
        for _ in range(n):
            print(LINE_UP, end=LINE_CLEAR, flush=True)

    def get_streaming_response(
        response: requests.Response, time_last_token
    ) -> Iterable[List[str]]:
        for chunk in response.iter_lines(
            chunk_size=8192, decode_unicode=False, delimiter=b"data:"
        ):
            if chunk:
                plain=chunk.decode("utf-8")
                if plain.strip() == "[DONE]":
                    continue
                data = json.loads(plain)
                output = data["choices"][0]["text"]
                time_now = time.time()
                yield output, time_now - time_last_token
                time_last_token = time_now

    # For non-streaming, but currently non-streaming is not fully implemented
    def get_response(response: requests.Response) -> List[str]:
        data = json.loads(response.content)
        output = data["choices"][0]["text"]
        return output

    token_gen_time = []
    start_time = time.time()
    #response = requests.post(api_url, headers=headers, json=pload, stream=False)
    response = requests.post(api_url, headers=headers, json=pload, stream=args.stream)
    if args.stream:
        output = ""
        for h, t in get_streaming_response(response, start_time):
            output += h
            token_gen_time.append(t)
    else:
        output = get_response(response)

    return ResponseDetails(
        generated_tokens=output,
        prompt=input_tokens,
        start_time=start_time,
        end_time=time.time(),
        model_time=0,
        token_gen_time=token_gen_time,
    )


def call_aml(
    input_tokens: str,
    max_new_tokens: int,
    args: argparse.Namespace,
    start_time: Union[None, float] = None,
) -> ResponseDetails:
    if args.stream:
        raise NotImplementedError("Not implemented for streaming")

    headers = {
        "Content-Type": "application/json",
        "Authorization": ("Bearer " + args.aml_api_key),
        "azureml-model-deployment": args.deployment_name,
    }
    pload = {
        "input_data": {
            "input_string": [
                input_tokens,
            ],
            "parameters": {
                "max_tokens": max_new_tokens,
                "return_full_text": False,
            },
        }
    }

    def get_response(response: requests.Response) -> List[str]:
        data = json.loads(response.content)
        try:
            output = data[0]["0"]
        except (KeyError, TypeError):
            try:
                output = data[0]
            except (KeyError, TypeError):
                output = data
        return output

    token_gen_time = []
    response = None
    if start_time is None:
        start_time = time.time()
    while True:
        try: # Sometimes the AML endpoint will return an error, so we send the request again
            response = requests.post(args.aml_api_url, headers=headers, json=pload, timeout=180)
            output = get_response(response)
            break
        except Exception as e:
            print(f"Connection failed with {e}. Retrying AML request")
            # make sure response exist before we call it
            if response:
                print(f"{response.status_code}:{response.content}")

    return ResponseDetails(
        generated_tokens=output,
        prompt=input_tokens,
        start_time=start_time,
        end_time=time.time(),
        model_time=0,
        token_gen_time=token_gen_time,
    )


def _run_parallel(
    barrier: Union[threading.Barrier, multiprocessing.Barrier],
    query_queue: Union[queue.Queue, multiprocessing.Queue],
    result_queue: Union[queue.Queue, multiprocessing.Queue],
    args: argparse.Namespace,
):
    pid = os.getpid()
    session_id = f"test_session_p{pid}_t{threading.get_ident()}"

    event_loop = asyncio.new_event_loop()
    asyncio.set_event_loop(event_loop)

    backend_call_fns = {"fastgen": call_fastgen, "vllm": call_vllm, "aml": call_aml, "openai": call_openai}
    call_fn = backend_call_fns[args.backend]

    barrier.wait()

    for _ in range(args.warmup):
        print(f"warmup queue size: {query_queue.qsize()} ({pid})", flush=True)
        input_tokens, req_max_new_tokens = query_queue.get(timeout=1.0)
        _ = call_fn(input_tokens, req_max_new_tokens, args)

    barrier.wait()

    time.sleep(random.uniform(0, args.num_clients) * 0.01)
    try:
        while True:
            print(f"queue size: {query_queue.qsize()} ({pid})", flush=True)
            input_tokens, req_max_new_tokens = query_queue.get(timeout=1.0)

            r = call_fn(input_tokens, req_max_new_tokens, args)

            result_queue.put(r)
    except queue.Empty:
        print(f"queue is empty ({pid})")

    print(f"Worker ({pid}) finished. session_id: {session_id}")


def run_client(args):
    """
    Run MII client for benchmarking. The scenario is a bit complicated:
    1. The main process puts `num_requests` queries into the input queue
    2. Each client runs `warmup` iterations () taking the queries from the input queue
    3. --- barrier ---
    4. The main process marks the start time
    5a. All clients send `num_requests' query in total and put the results into the result queue
    5b. The main process takes the results from the result queue (in parallel with 5a)
    6. The main process marks the end time after receiving `num_requests' results
    """

    if args.use_thread:
        runnable_cls = threading.Thread
        barrier_cls = threading.Barrier
        queue_cls = queue.Queue
    else:
        runnable_cls = multiprocessing.Process
        barrier_cls = multiprocessing.Barrier
        queue_cls = multiprocessing.Queue

    barrier = barrier_cls(args.num_clients + 1)
    query_queue = queue_cls()
    result_queue = queue_cls()

    processes = [
        runnable_cls(
            target=_run_parallel,
            args=(
                barrier,
                query_queue,
                result_queue,
                args,
            ),
        )
        for i in range(args.num_clients)
    ]
    for p in processes:
        p.start()

    tokenizer = AutoTokenizer.from_pretrained(args.model, trust_remote_code=True)
    query_generator = RandomQueryGenerator(all_text, tokenizer, seed=42)
    request_text = query_generator.get_random_request_text(
        args.mean_prompt_length,
        args.mean_prompt_length * args.prompt_length_var,
        args.max_prompt_length,
        args.num_requests + args.warmup * args.num_clients,
    )

    print(f"{args.num_requests=} {args.warmup=} {args.num_clients=}")

    for t in request_text:
        # Set max_new_tokens following normal distribution
        req_max_new_tokens = int(
            np.random.normal(
                args.mean_max_new_tokens,
                args.max_new_tokens_var * args.mean_max_new_tokens,
            )
        )
        query_queue.put((t, req_max_new_tokens))

    # Tokenizers must be initialized after fork.
    # So we need to fork before putting inputs to the queue.
    # We need this barrier to stop child processse from taking inputs before the main process puts them
    barrier.wait()
    # This barrier is to make sure that all clients have finished warmup
    barrier.wait()

    response_details = []
    while len(response_details) < args.num_requests:
        res = result_queue.get()
        # vLLM returns concatinated tokens
        if "vllm" in args.backend:
            all_tokens = tokenizer.tokenize(res.generated_tokens)
            all_tokens = [item.decode(errors='ignore') if isinstance(item, bytes) else item for item in all_tokens]
            res.generated_tokens = all_tokens[len(tokenizer.tokenize(res.prompt)) :]
        response_details.append(res)

    return response_details


def run_client_concurrent_futures(args):

    # 1. Get texts per rand distn
    tokenizer = AutoTokenizer.from_pretrained(args.model, trust_remote_code=True)
    query_generator = RandomQueryGenerator(all_text, tokenizer, seed=42)
    request_text = query_generator.get_random_request_text(
        args.mean_prompt_length,
        args.mean_prompt_length * args.prompt_length_var,
        args.max_prompt_length,
        args.num_requests + args.warmup * args.num_clients,
    )

    print(f"{args.num_requests=} {args.warmup=} {args.num_clients=}")

    prompt_texts_maxtoks = []
    for t in request_text:
        # Set max_new_tokens following normal distribution
        req_max_new_tokens = int(
            np.random.normal(
                args.mean_max_new_tokens,
                args.max_new_tokens_var * args.mean_max_new_tokens,
            )
        )
        prompt_texts_maxtoks.append((t, req_max_new_tokens))

    pool_size = args.num_clients

    # 2 Warmup
    np.random.seed(2024)
    with ProcessPoolExecutor(max_workers=pool_size) as executor:
        futures = []
        for i in np.random.randint(len(prompt_texts_maxtoks), size=args.warmup):
            input_tokens, req_max_new_tokens = prompt_texts_maxtoks[i]
            future = executor.submit(call_vllm_yoco, input_tokens, req_max_new_tokens)
            futures.append(future)
        print("~~~ Waiting on warmup ~~~")
        wait(futures)

    # time.sleep(3) # needed for PPE on our infra to fully delete and heal? NOPE

    # 3 Call
    with ProcessPoolExecutor(max_workers=pool_size) as executor:
        futures = []
        for i in np.random.permutation(list(range(len(prompt_texts_maxtoks)))):
            input_tokens, req_max_new_tokens = prompt_texts_maxtoks[i]
            future = executor.submit(call_vllm_yoco, input_tokens, req_max_new_tokens)
            futures.append(future)
        print("~~~ Waiting on submit ~~~")
        wait(futures)

    # 4 Pre-postprocess
    response_details = []
    timeouts = 0
    for fut in futures:
        try:
            res = fut.result()
            response_details.append(res)
        except TimeoutError:
            timeouts += 1
    
    if timeouts > 0:
        print(f"!!! {timeouts=} ({timeouts/len(futures):.2%})")

    # time.sleep(3) # needed for PPE on our infra to fully delete and heal? NOPE

    return response_details


if __name__ == "__main__":
    args = parse_args(client_args=True)

    for client_args in get_args_product(args, which=CLIENT_PARAMS):
        if args.backend == "vllmyoco":
            response_details = run_client_concurrent_futures(client_args)
        else:
            response_details = run_client(client_args)

        print_summary(client_args, response_details)
