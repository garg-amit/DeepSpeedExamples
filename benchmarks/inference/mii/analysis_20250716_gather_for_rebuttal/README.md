# Notes

1. Something changed in vllm 080 and got worse in 090 with parallelism in SSMs. Happens with >4 concurrent clients. Unsure if it's vllm or mamba-ssm
2. If lines are disconnected, increase the number of points in the np.linspace
3. If the colors are weird, eg > 5 models, make the colormap over twice as many points (eg `colors(np.linspace(0, 1, len(names)*2 - 3))`)
