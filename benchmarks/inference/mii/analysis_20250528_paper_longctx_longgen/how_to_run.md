```
<copy data>
<-- neurips data for p*c500 and p2000c*: _data_with_8_16_fix -->
<-- additional neurips data for p2000c32000 for llama3.2-3B and qwen2.5-7B: _data_latest_deps>
pip install matplotlib tabulate
<git clone and checkout https://github.com/garg-amit/DeepSpeedExamples/tree/adatkins/fix-bugs-custom-yocov2>
cd DeepSpeedExamples/benchmark/inference/mii
bash analysis_20250528_paper_longctx_longgen/plot{8, 14-2_mixture}.sh
```