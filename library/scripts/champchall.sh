fastscore use engine-1
fastscore engine reset
fastscore run lr-champion-py3 lr-input-file-stream-truth influx-mux-kafka

fastscore use engine-2
fastscore engine reset
fastscore run influx-mse-py3 influx-mux-kafka rest:

fastscore use engine-3
fastscore engine reset
fastscore run lr-challenger-py3 lr-input-file-stream-truth inter-engine

fastscore use engine-4
fastscore engine reset
fastscore run influx-mse-py3 inter-engine rest:
