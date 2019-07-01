fastscore connect https://localhost:8000
sleep 3
fastscore config set config.yaml
sleep 3
fastscore fleet -wait
