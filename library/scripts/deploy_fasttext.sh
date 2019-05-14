fastscore use engine-1
fastscore engine reset
fastscore run fasttext-py3 rest: rest:

fastscore engine inspect
head -10 testdata/test_inputs.jsons | fastscore model input
sleep 1m
fastscore model output
 
