fastscore use engine-2
fastscore engine reset
fastscore run xgb_model-py3 influx-mux-kafka rest
fastscore engine inspect
fastscore use engine-1
fastscore engine reset
fastscore run hp_input_monitor rest influx-mux-kafka
fastscore engine inspect
cat hp_file_in.jsons | fastscore model input
fastscore use engine-2
fastscore model output
