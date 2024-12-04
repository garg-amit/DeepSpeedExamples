# Copyright (c) Microsoft Corporation.
# SPDX-License-Identifier: Apache-2.0

# DeepSpeed Team
from src.client import run_client, run_client_concurrent_futures
from src.server import start_server, stop_server
from src.utils import (
    get_args_product,
    parse_args,
    print_summary,
    results_exist,
    save_json_results,
    CLIENT_PARAMS,
    SERVER_PARAMS,
)


def run_benchmark() -> None:
    args = parse_args(server_args=True, client_args=True)

    for server_args in get_args_product(args, which=SERVER_PARAMS):
        # run yourser
        if server_args.backend != "aml" and not server_args.client_only and server_args.backend != "vllmyoco":
            print(f"\n****SERVER_ARGS*** {args=} {server_args=}")
            start_server(server_args)
            # # for starting server here and calling with curl
            # from time import sleep
            # sleep(1000)

        for client_args in get_args_product(server_args, which=CLIENT_PARAMS):
            if results_exist(client_args) and not args.overwrite_results:
                print(
                    f"Found existing results and skipping current setting. To ignore existing results, use --overwrite_results"
                )
                continue

            if client_args.num_requests is None:
                client_args.num_requests = client_args.num_clients * 4 + 32

            if args.backend == "vllmyoco":
                client_args.num_clients = 2 # parallelism seems to cause an error when decoding streaming response
                # 2 works fine, even with multiple iters of this loop (no `break`)

            # print(f"\n****CLIENT_ARGS*** {server_args=} {client_args=}\n")
            if args.backend == "vllmyoco":
                response_details = run_client_concurrent_futures(client_args)
            else:
                response_details = run_client(client_args)
            print_summary(client_args, response_details)
            save_json_results(client_args, response_details)

        if server_args.backend != "aml" and not server_args.client_only and server_args.backend != "vllmyoco":
            stop_server(server_args)


if __name__ == "__main__":
    run_benchmark()
