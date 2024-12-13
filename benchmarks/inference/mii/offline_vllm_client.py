#!/usr/bin/env python
import os
from vllm import LLM, SamplingParams

os.environ["CUDA_VISIBLE_DEVICES"] = "1"
os.environ["VLLM_ALLOW_LONG_MAX_MODEL_LEN"] = "true"

# Sample prompts.
prompts = [
    "Hello, my name is",
    "The president of the United States is",
    "The capital of France is",
    "The future of AI is",
]
# Create a sampling params object.
sampling_params = SamplingParams(
    temperature=0.8,
    top_p=0.95,
    ignore_eos=True,
    max_tokens=16000,
)

# [rank0]: ValueError: The model's max seq len (262144) is larger than the maximum number of tokens that can be stored in KV cache (164016). Try increasing `gpu_memory_utilization` or decreasing `max_model_len` when initializing the engine.
# so `max_model_len`

# Create an LLM.
llm = LLM(
    model="/data/users/adatkins/dev/phivnext/yoco/yocov2/DeepSpeedExamples/benchmarks/inference/mii/real_checkpoints/yocov2_samba_no_da_hf",
    #model="facebook/opt-125m",
    trust_remote_code=True,
    tensor_parallel_size=1,
    max_model_len=100000, # kwargs passed to the engine
    enforce_eager=True, # disable CUDA graph. tmp fix to issue: `yoco_input_block_tables[i, :len(yoco_block_table)] = yoco_block_table`
)
# Generate texts from the prompts. The output is a list of RequestOutput objects
# that contain the prompt, generated text, and other information.
outputs = llm.generate(prompts, sampling_params)
# Print the outputs.
for i, output in enumerate(outputs):
    prompt = output.prompt
    generated_text = output.outputs[0].text
    # print(f"Prompt: {prompt!r}, Generated text: {generated_text!r}")
    print(i)
