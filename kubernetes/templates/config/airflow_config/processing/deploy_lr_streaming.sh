fastscore use engine-4
fastscore engine reset
fastscore run lr-1-py3 lr-input-file-stream influx-mux-kafka


fastscore use engine-5
fastscore engine reset
fastscore model load influx-mux-py3 
fastscore stream attach influx-mux-kafka 0

