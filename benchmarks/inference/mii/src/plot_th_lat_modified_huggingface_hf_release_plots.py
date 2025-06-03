# Copyright (c) Microsoft Corporation.
# SPDX-License-Identifier: Apache-2.0

# DeepSpeed Team

import argparse
import glob
import os
import re
import yaml
from pathlib import Path

import matplotlib
import matplotlib.pyplot as plt
import numpy as np

from postprocess_results import read_json, get_summary, get_result_sets


def get_args():
    parser = argparse.ArgumentParser()
    parser.add_argument("--data_dirs", type=str, nargs="+", \
                        help="Specify the data directories to generate plots for")
    parser.add_argument("--result_dirs", type=str, nargs="+", \
                        help="Specify the data directories to generate plots for")
    parser.add_argument("--model_names", type=str, nargs="+", \
                        help="model names")
    parser.add_argument("--out_dir", type=Path, default="./plots/throughput_latency")
    parser.add_argument("--model_name", type=str, default="", help="Optional model name override")
    args = parser.parse_args()
    return args

import ipdb

def extract_values(file_pattern):
    print(f"Extracting values from {file_pattern}")
    files = glob.glob(file_pattern)

    print(f"Found {len(files)}: {files=}")
    print("\n".join(files))

    clients = []
    throughputs = []
    latencies = []

    for f in files:
        prof_args, response_details = read_json(f)
        # response_details = List[ResponseDetails] ie a list of the response objects of list of requesuts
        # there are as many requests as items in response_details

        clients.append(prof_args["num_clients"])

        # # per-token metrics
        # token_gen_time_per_response = [sum(r.token_gen_time) for r in response_details]
        # num_tokens_per_response = [len(r.token_gen_time) for r in response_details]
        # assert len(token_gen_time_per_response) == len(num_tokens_per_response)
        # token_throughputs_per_response = [a/b for a,b in zip(num_tokens_per_response, token_gen_time_per_response)]

        # per response metrics
        # omit first token since would be TTFT
        # these two are basically equivalent
        total_latency_per_response_s = [sum(r.token_gen_time) - r.token_gen_time[0] for r in response_details]
        total_latency_per_response_s1 = [r.end_time - r.start_time - r.token_gen_time[0] for r in response_details] # This is off because end_time=time.time(),
        adjusted_qps_per_response_s = [t / prof_args["num_clients"] for t in total_latency_per_response_s] # TODO this isn't throughput...
        throughputs.append(adjusted_qps_per_response_s)
        latencies.append(total_latency_per_response_s)

    return clients, throughputs, total_latency_per_response_s


from collections import defaultdict

def output_charts(models, tp_size, bs, replicas, prompt, gen, out_dir, ax=None, data_dir_path=None, model_names=None):
    out_dir.mkdir(parents=True, exist_ok=True)

    color_cycle = matplotlib.colormaps['tab10']

    # all_data_by_completion_len[model][num_clients][completion_len_bucket]
    # completion_len_bucket is likely overkill since we're only called for one completionlen (or gen) at a time
    all_data_total_request_latency_by_model_by_completion_len = defaultdict(lambda: defaultdict(lambda: defaultdict(float)))

    for _id, model in enumerate(models):
        result_file_pattern = f"{model}-tp{tp_size}-bs{bs}-replicas{replicas}-prompt{prompt}-gen{gen}-clients*.json"
        
        dir_path = [data_dir_path[_id]]
        for idx, data_dir in enumerate(dir_path):
            file_pattern = f"{data_dir}/{result_file_pattern}"
            print(f"{file_pattern=}")
            suffix = file_pattern.split('/')[-1]
            prompt_len_bucket = int(re.search("prompt(\d+)", suffix).group(1))
            completion_len_bucket = int(re.search("gen(\d+)", suffix).group(1))
            # if prompt_len_bucket != 2000:
            #     continue
            clients, throughputs, latencies = extract_values(file_pattern)
            assert completion_len_bucket == int(gen)
            # use all clients
            for client, sub_latencies in zip(clients, latencies):
                all_data_total_request_latency_by_model_by_completion_len[f"{os.path.basename(data_dir)}/{model}"][client][completion_len_bucket] = np.mean(sub_latencies)

    # for m, d in all_data_total_request_latency_by_model_by_completion_len.items():
    #     for c, d2 in d.items():
    #         for g, l in d2.items():
    #             print(f"model={m};clients={c};completionlen={g};latency={l}")
    # print(f"{gen=}")
    # ipdb.set_trace()
    return all_data_total_request_latency_by_model_by_completion_len


# def extract_values(file_pattern):
#     print(f"Extracting values from {file_pattern}")
#     files = glob.glob(file_pattern)

#     print(f"Found {len(files)}")
#     print("\n".join(files))

#     clients = []
#     throughputs = []
#     latencies = []
#     ttfts = []
#     tbts = []
#     extra_args = {}
#     for f in files:
#         prof_args, response_details = read_json(f)
#         summary = get_summary(prof_args, response_details)
#         ipdb.set_trace()
#         clients.append(prof_args["num_clients"])
#         throughputs.append(summary.throughput)
#         latencies.append(summary.latency)
#         ttfts.append(summary.first_token_latency)
#         tbts.append(summary.token_gen_latency)

#     return clients, throughputs, latencies, prof_args, ttfts, tbts


# def output_charts(models, tp_size, bs, replicas, prompt, gen, out_dir, ax=None, data_dir_path=None, model_names=None):
#     out_dir.mkdir(parents=True, exist_ok=True)

#     color_cycle = matplotlib.colormaps['tab10']
#     TTFTs = []
#     TBTs = []
#     for id, model in enumerate(models):
#         result_file_pattern = f"{model}-tp{tp_size}-bs{bs}-replicas{replicas}-prompt{prompt}-gen{gen}-clients*.json"
        
#         dir_path = [data_dir_path[id]] if data_dir_path else args.data_dirs
#         for idx, data_dir in enumerate(dir_path):
#             file_pattern = f"{data_dir}/{result_file_pattern}"
#             _, throughputs, latencies, _, ttfts, tbts = extract_values(file_pattern)

#             # Consider only TTFTs and TBTS when num of clients is 1 i.e. at index 0
#             TTFTs.append(ttfts[0])
#             TBTs.append(tbts[0])

#     ipdb.set_trace()

if __name__ == "__main__":
    args = get_args()
    results = [get_result_sets(args, data_dir_path=[data_dir]) for data_dir in args.result_dirs]
    all_processed_data = None
    for idx, (_, tp_size, bs, replicas, prompt, gen) in enumerate(results[0]):
        processed_data = output_charts(
            models=[item[idx][0] for item in results],
            tp_size=tp_size,
            bs=bs,
            replicas=replicas,
            prompt=prompt,
            gen=gen,
            out_dir=args.out_dir,
            data_dir_path=args.result_dirs,
            model_names=args.model_names
        )
        if all_processed_data is None:
            all_processed_data = processed_data
        else: # zip
            # all_processed_data[model][num_clients][completion_len_bucket]
            for m, d in processed_data.items():
                for c, d2 in d.items():
                    for g, l in d2.items():
                       all_processed_data[m][c][g] = l #processed_data[m][c][g]

    for m, d in all_processed_data.items():
        for c, d2 in d.items():
            for g, l in d2.items():
                print(f"model={m};clients={c};completionlen={g};latency={l}")
    ipdb.set_trace()
