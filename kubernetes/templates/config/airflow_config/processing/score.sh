#!/bin/bash

fastscore connect https://dashboard:8000
fastscore -wait fleet
cd /usr/local/airflow/processing

fastscore use engine-5
fastscore engine reset
fastscore model load influx-mux-py3
fastscore stream attach influx-mux-kafka 0
fastscore engine inspect

fastscore use engine-1
fastscore engine reset
fastscore run lr-2-py3 lr-input-file-stream influx-mux-kafka
fastscore engine inspect


fastscore use engine-3
fastscore engine reset
fastscore run lr-1-py3 lr-input-file-stream influx-mux-kafka
fastscore engine inspect
