fastscore use engine-2
fastscore engine reset
fastscore run xgb_model-py3 influx-mux-kafka rest
fastscore engine inspect
fastscore use engine-1
fastscore engine reset
fastscore engine put hp_file_in.jsons hp_file_input.jsons
fastscore run hp_input_monitor-py3 hp-input-file-stream influx-mux-kafka
fastscore use engine-2
fastscore model output
fastscore monitor
