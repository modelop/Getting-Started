fastscore connect https://dashboard:8000
fastscore -wait fleet
cd /usr/local/airflow/processing


fastscore use engine-4
fastscore engine reset
fastscore run lr-1-fast-py3 lr-input-s3 lr-output-s3
