fastscore use engine-2
fastscore engine reset
fastscore run lr-champion-py3 lr-input-file-stream influx-mux-kafka

fastscore use engine-1
fastscore engine reset
fastscore model load influx-mse-py3
fastscore stream attach influx-mux-kafka 0
