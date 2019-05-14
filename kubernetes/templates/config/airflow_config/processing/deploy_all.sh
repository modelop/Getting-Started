#connect
fastscore connect https://dashboard:8000
fastscore -wait fleet

#enigine 1 - lr-1 streaming
fastscore use engine-1
fastscore engine reset
fastscore run lr-1-py3 lr-input-file-stream influx-mux-kafka

#engine 2 - lr-2 streaming
fastscore use engine-2
fastscore engine reset
fastscore run lr-2-py3 lr-input-file-stream influx-mux-kafka

#engine 3 - influx mux 
fastscore use engine-3
fastscore engine reset
fastscore model load influx-mux-py3 
fastscore stream attach influx-mux-kafka 0

#engine 4 - PFA
fastscore use engine-4
fastscore engine reset
fastscore run credit_sample_model-pfa pfa-credit-file-input pfa-credit-file-output

#recommender
fastscore use recommender
fastscore engine reset
fastscore run recommender-py3 rest: rest: 
