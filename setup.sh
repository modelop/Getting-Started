fastscore connect https://localhost:8000 --verbose
fastscore config set config.yaml
sleep 3s
fastscore fleet --wait
