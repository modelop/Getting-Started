fastscore use engine-3
fastscore engine reset
fastscore run lr-1-monitored-py3 lr-input-file-stream influx-mux-kafka

fastscore use engine-2
fastscore engine reset
fastscore model load evaluator-py3 
fastscore stream attach influx-mux-kafka 0
