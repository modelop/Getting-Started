fastscore use engine-5
fastscore engine reset
fastscore engine put iris_back_test.json input.jsons 
fastscore run xgboost_iris_backtest-py3 xgboost_file rest:
fastscore engine inspect

fastscore model output -c
