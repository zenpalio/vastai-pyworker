#!/bin/bash

export REPORT_ADDR WORKER_PORT USE_SSL

cd "$SERVER_DIR"

echo "launching PyWorker server"

# if instance is rebooted, we want to clear out the log file so pyworker doesn't read lines
# from the run prior to reboot. past logs are saved in $MODEL_LOG.old for debugging only
[ -e "$MODEL_LOG" ] && cat "$MODEL_LOG" >> "$MODEL_LOG.old" && : > "$MODEL_LOG"

(python3 -m "workers.$BACKEND.server" |& tee -a "$PYWORKER_LOG") &
echo "launching PyWorker server done"

echo "downloading model"
wget -O /workspace/stable-diffusion-webui/models/Stable-diffusion/lustify40.safetensors "https://civitai.com/api/download/models/926965?type=Model&format=SafeTensor&size=pruned&fp=fp16&token=9cbb5054c4234bacc32bdcc1c19dfff7"
wget -O /workspace/stable-diffusion-webui/models/Stable-diffusion/foxya30.safetensors "https://civitai.com/api/download/models/60506?type=Model&format=SafeTensor&size=full&fp=fp16&token=9cbb5054c4234bacc32bdcc1c19dfff7"
wget -O /workspace/stable-diffusion-webui/models/VAE/sd-vae.pt "https://civitai.com/api/download/models/138458?type=Model&format=PickleTensor&size=pruned&fp=fp16&token=9cbb5054c4234bacc32bdcc1c19dfff7"
git clone https://github.com/Bing-su/adetailer /workspace/stable-diffusion-webui/extensions/adetailer
# Wait for /internal/ping to return 200 with a timeout of 10 minutes
timeout=600  # Total timeout in seconds
interval=5   # Interval between checks in seconds
elapsed=0

while [ $elapsed -lt $timeout ]; do
    status=$(curl -s -o /dev/null -w "%{http_code}" http://127.0.0.1:7860/internal/ping)
    echo "Status: $status"
    if [ "$status" -eq 200 ]; then
        break
    fi
    sleep $interval
    elapsed=$((elapsed + interval))
done

if [ $elapsed -ge $timeout ]; then
    echo "Timeout reached while waiting for /internal/ping to return 200."
    exit 1
fi
# Create script.py
cat << 'EOF' > script.py
import requests
import urllib3
import os

url = "http://127.0.0.1:7860"  # or your URL

# Disable SSL warnings
urllib3.disable_warnings(urllib3.exceptions.InsecureRequestWarning)
requests.post(
    url=f"{url}/sdapi/v1/refresh-checkpoints",
    verify=False,  # Disable SSL verification
)
opt = requests.get(
    url=f"{url}/sdapi/v1/options",
    verify=False,  # Disable SSL verification
)
opt_json = opt.json()
opt_json["sd_model_checkpoint"] = "lustify40"
requests.post(
    url=f"{url}/sdapi/v1/options",
    json=opt_json,
    verify=False,  # Disable SSL verification
)
requests.post(
    url=f"{url}/sdapi/v1/reload-checkpoint",
    verify=False,  # Disable SSL verification
)

# Send POST request to REPORT_ADDR
report_addr = os.environ["REPORT_ADDR"]
container_id = os.environ["CONTAINER_ID"]
public_ip = os.environ["PUBLIC_IPADDR"]
worker_port = os.environ["WORKER_PORT"]
vast_tcp_port = os.environ[f"VAST_TCP_PORT_{worker_port}"]
full_url = f"{public_ip}:{vast_tcp_port}"

data = {
    "id": container_id,
    "url": full_url
}

requests.post(
    url=f"{report_addr}/public/v1/webhook/vastai/automatic/register",
    json=data,
    verify=False,  # Disable SSL verification
)
EOF

# Call the Python script
python3 script.py

# export BACKEND=automatic1111
# wget -O - "https://raw.githubusercontent.com/zenpalio/vastai-pyworker/main/start_server.sh" | bash && (text-generation-launcher --model-id "$MODEL_ID" --json-output --port 5001 --hostname "0.0.0.0" &>> $MODEL_LOG);

