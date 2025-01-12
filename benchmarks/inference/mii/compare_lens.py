import json
import os 

num_clients = [1,2,4,6,8,12,16,20,24,28,32]
def get_avg_p_g_lens(path, pl=500, gl=500, prefix="meta-llama_Llama-3.2-3B-tp1-bs768-replicas1"):
    p_avg = []
    g_avg = []
    for num in num_clients:
        json_w_wt_path = f"{path}/{prefix}-prompt{pl}-gen{gl}-clients{str(num)}.json"
        # Load JSON data from the file
        with open(json_w_wt_path, 'r') as file:
            json_w_wt = json.load(file)
        prompt_lens = []
        gen_lens = []
        for item in json_w_wt['response_details']:
            prompt_lens.append(len(item['prompt'].split(" "))) # Approximate prompt length
            gen_lens.append(len(item['token_gen_time']))
        p_avg.append(sum(prompt_lens) / len(prompt_lens))
        g_avg.append(sum(gen_lens) / len(gen_lens))
    return sum(p_avg) / len(p_avg), sum(g_avg) / len(g_avg)

def find_distinct_prefixes(dir_path):
    prefixes = set()
    for root, dirs, files in os.walk(dir_path):
        for file in files:
            prefix = file.split('-prompt')[0]
            prefixes.add(prefix)
    return list(prefixes)

def print_lens(dir_path, prefixes, p_g_lens):
    
    for prefix in prefixes:
        print(f"\n\nPrefix: {prefix}\n")
        for pl, gl in p_g_lens:
            pl_real, gl_real = get_avg_p_g_lens(dir_path, pl, gl, prefix)
            print(f"Prompt Length: {pl}, Gen Length: {gl}, Avg Prompt Length: {round(pl_real,2)}, Avg Gen Length: {round(gl_real,2)}")

if __name__ == "__main__":
    dir_paths = [
        "/home/azureuser/cloudfiles/code/Users/gargamit/DeepSpeedExamples/benchmarks/inference/mii/results_vllm/phi_35_mini_tp1",
        "/home/azureuser/cloudfiles/code/Users/gargamit/DeepSpeedExamples/benchmarks/inference/mii/results_phio/llama_32_3b_no_weights_vllm",
        "/home/azureuser/cloudfiles/code/Users/gargamit/DeepSpeedExamples/benchmarks/inference/mii/results_vllm/Phio-SFT-long-001-DPO-002_vllm",
    ]
    
    p_g_lens = ((500,500), (1300,120), (2600, 60), (4096, 500))
    for dir_path in dir_paths:
        prefixes = find_distinct_prefixes(dir_path)
        print_lens(dir_path, prefixes, p_g_lens)
