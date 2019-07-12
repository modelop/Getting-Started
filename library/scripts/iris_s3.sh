fastscore use engine-1
fastscore engine reset
fastscore run xgboost_iris-py3 s3-input s3-output 
fastscore engine inspect

head -10 xgboost_iris_inputs.jsons | fastscore model input

fastscore model output
