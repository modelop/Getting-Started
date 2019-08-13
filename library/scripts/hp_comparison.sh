fastscore use engine-1
fastscore engine reset
fastscore run hp_comparison-py3 rest-batch rest:
cat hp_sample.jsons | fastscore model input
fastscore model output -c
