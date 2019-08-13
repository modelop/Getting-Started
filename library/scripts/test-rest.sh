fastscore use engine-1
fastscore engine reset
fastscore run multiplier-py3 watermark-1 watermark-1

curl -k -X POST -d 20 https://localhost:8000/api/1/service/engine-1/2/active/model/roundtrip/0/1
