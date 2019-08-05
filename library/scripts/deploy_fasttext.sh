fastscore use engine-7
fastscore engine reset
fastscore run fasttext-py3 rest: rest:

fastscore engine inspect
head -10 test_inputs.jsons | fastscore model input
sleep 1m
fastscore model output
 
