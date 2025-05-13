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


def extract_values(file_pattern):
    print(f"Extracting values from {file_pattern}")
    files = glob.glob(file_pattern)

    print(f"Found {len(files)}")
    print("\n".join(files))

    clients = []
    throughputs = []
    latencies = []
    ttfts = []
    tbts = []
    extra_args = {}
    for f in files:
        prof_args, response_details = read_json(f)
        summary = get_summary(prof_args, response_details)
        clients.append(prof_args["num_clients"])
        throughputs.append(summary.throughput)
        latencies.append(summary.latency)
        ttfts.append(summary.first_token_latency)
        tbts.append(summary.token_gen_latency)

    return clients, throughputs, latencies, prof_args, ttfts, tbts

def plot_latency_comparison(TTFTs, TBTs, names, prompt, gen, output_dir='plots/', colors=None):
    def plot_bars(ax, x, latencies, labels, title, color_map, prompt=prompt, gen=gen):
        bars = ax.bar(x, latencies, width, label=labels, color=color_map)
        ax.set_title(title)
        ax.set_ylabel('Latency (s)')
        ax.set_xticks(x)
        ax.set_xticklabels(range(len(labels)))
        if (str(prompt)=="2000" and str(gen) == "32000") or (str(prompt)=="32000" and str(gen) == "500"):
            ax.legend(loc="lower left")
            print(f"=== LOWER {prompt} {gen}")
        else:
            ax.legend()
        for bar in bars:
            yval = bar.get_height()
            ax.text(bar.get_x() + bar.get_width() / 2, yval, round(yval, 4), ha='center', va='bottom')

    x = np.arange(len(names))
    width = 1

    if colors is None:
        colors = matplotlib.colormaps['tab10']

    color_map = colors(np.linspace(0, 1, len(names)*2))

    fig, axs = plt.subplots(1, 2, figsize=(12, 6))
    fig.suptitle(f'Prompt: {prompt}, Generation: {gen}')

    plot_bars(axs[0], x - width/2, TTFTs, names, 'Time to First Token (TTFT)', color_map)
    plot_bars(axs[1], x + width/2, TBTs, names, 'Time Between Tokens (TBT)', color_map)

    plt.tight_layout()
    plt.savefig(f'{output_dir}/ttft_tbt-prompt{prompt}-gen{gen}.png')
    plt.show()

def output_charts(models, tp_size, bs, replicas, prompt, gen, out_dir, ax=None, data_dir_path=None, model_names=None):
    out_dir.mkdir(parents=True, exist_ok=True)

    color_cycle = matplotlib.colormaps['tab10']
    TTFTs = []
    TBTs = []
    for id, model in enumerate(models):
        result_file_pattern = f"{model}-tp{tp_size}-bs{bs}-replicas{replicas}-prompt{prompt}-gen{gen}-clients*.json"
        if ax is None:
            fig, ax = plt.subplots()
        
        dir_path = [data_dir_path[id]] if data_dir_path else args.data_dirs
        for idx, data_dir in enumerate(dir_path):
            file_pattern = f"{data_dir}/{result_file_pattern}"
            _, throughputs, latencies, _, ttfts, tbts = extract_values(file_pattern)

            # Consider only TTFTs and TBTS when num of clients is 1 i.e. at index 0
            TTFTs.append(ttfts[0])
            TBTs.append(tbts[0])

            kwargs = {}
            kwargs["label"] = str(data_dir)
            kwargs["marker"] = "o"
            kwargs["linestyle"] = "--"
            kwargs["color"] = color_cycle(id % 10)

            fit_kwargs = {}
            fit_kwargs["linestyle"] = "--"
            fit_kwargs["color"] = color_cycle(id % 10)
            plot_fit_line = True

            polyfit_degree = 3 # increase to increase the order of the polynomial. > 1 tends to overfit this data
            plot_fn = ax.scatter

            plot_config = glob.glob(f"{data_dir}/plot_config.yaml")

            latencies = sorted(latencies)
            throughputs = sorted(throughputs)
            assert len(latencies) == len(throughputs)

            if plot_config:
                plot_config = plot_config[0]
                plot_config = yaml.safe_load(Path(plot_config).read_text())
                plot_keys = plot_config.keys()

                # If x_max specified, clip data
                if "x_max" in plot_keys:
                    for i, throughput in enumerate(throughputs):
                        if throughput > plot_config["x_max"]:
                            latencies = latencies[:i]
                            throughputs = throughputs[:i]
                            break

                # If y_max specified, clip data
                if "y_max" in plot_keys:
                    for i, latency in enumerate(latencies):
                        if latency > plot_config["y_max"]:
                            latencies = latencies[:i]
                            throughputs = throughputs[:i]
                            break

                # Set polyfit degree
                polyfit_degree = plot_config.get("polyfit_degree", polyfit_degree)

                # Select plot type
                if polyfit_degree == 0:
                    plot_fit_line = False

                # Main plot kwargs
                if "label" in plot_keys:
                    kwargs["label"] = plot_config["label"]
                if "marker" in plot_keys:
                    kwargs["marker"] = plot_config["marker"]
                if "color" in plot_keys:
                    kwargs["color"] = plot_config["color"]
                if "linestyle" in plot_keys:
                    kwargs["linestyle"] = plot_config["linestyle"]

                # Fit line kwargs
                if "color" in plot_keys:
                    fit_kwargs["color"] = plot_config["color"]
                if "linestyle" in plot_keys:
                    fit_kwargs["linestyle"] = plot_config["linestyle"]

            if len(throughputs) > 0:
                kwargs["label"] = model_names[id]
                plot = plot_fn(
                    throughputs,
                    latencies,
                    **kwargs,
                )

                if plot_fn == ax.plot:
                    plot_color = plot[0].get_color()
                else:
                    plot_color = plot.get_facecolor()[0]

                if not "color" in fit_kwargs.keys():
                    fit_kwargs["color"] = plot_color

                denom = 1000 if "phi" in model.lower() and str(gen) == "32000" else 75
                step = (max(throughputs)-min(throughputs)) /  denom # lots of steps needed to get good resolution. can't be fixed.
                assert step > 0
                fit_x_list = np.arange(min(throughputs), max(throughputs), step)
                if "phi" in model.lower() and str(gen) == "32000":
                    print(f"!!!!!!!!!!! {model=} {denom=} {prompt=} {gen=} {fit_x_list[990:]=}")
                data_model = np.polyfit(throughputs, latencies, polyfit_degree)
                model_fn = np.poly1d(data_model)
                x = fit_x_list if plot_fit_line else throughputs

                y = model_fn(fit_x_list) if plot_fit_line else latencies
                ax.plot(
                    x,
                    y,
                    alpha=0.5,
                    **fit_kwargs,
                )

    plt.title(f"Prompt: {prompt}, Generation: {gen}, TP: {tp_size}")
    plt.xlabel("Throughput (queries/s)", fontsize=14)
    plt.ylabel("Latency (s)", fontsize=14)
    if str(gen) == "32000":
        plt.legend(loc="upper right")
    else:
        plt.legend(loc="upper left")
    plt.grid(True)
    plt.tight_layout()
    out_file = (
        out_dir
        / f"tp{tp_size}-bs{bs}-replicas{replicas}-prompt{prompt}-gen{gen}.png"
    )
    print(f"Saving {out_file}")
    plt.savefig(out_file)

    # Plot TTFT and TBT
    plot_latency_comparison(TTFTs, TBTs, model_names, prompt, gen, output_dir=out_dir, colors=color_cycle)


if __name__ == "__main__":
    args = get_args()
    for data_dir in args.result_dirs:
        print(f"{data_dir=} ")
    results = [get_result_sets(args, data_dir_path=[data_dir]) for data_dir in args.result_dirs]
    for idx, (_, tp_size, bs, replicas, prompt, gen) in enumerate(results[0]):
        output_charts(
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
