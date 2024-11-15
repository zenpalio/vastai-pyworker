#!/bin/bash
#!/bin/bash

set -e -o pipefail

WORKSPACE_DIR="${WORKSPACE_DIR:-/workspace}"

SERVER_DIR="$WORKSPACE_DIR/vast-pyworker"
ENV_PATH="$WORKSPACE_DIR/worker-env"
DEBUG_LOG="$WORKSPACE_DIR/debug.log"
PYWORKER_LOG="$WORKSPACE_DIR/pyworker.log"

REPORT_ADDR="${REPORT_ADDR:-https://8024-2a00-102a-4019-cdc7-f097-7b89-887e-223c.ngrok-free.app}"
USE_SSL="${USE_SSL:-true}"
WORKER_PORT="${WORKER_PORT:-3000}"
BACKEND="${BACKEND:-automatic1111}"
rm -rf /workspace/vast-pyworker/
rm -rf /workspace/worker-env/

mkdir -p "$WORKSPACE_DIR"
cd "$WORKSPACE_DIR"

# make all output go to $DEBUG_LOG and stdout without having to add `... | tee -a $DEBUG_LOG` to every command
exec &> >(tee -a "$DEBUG_LOG")

function echo_var(){
    echo "$1: ${!1}"
}

[ -z "$BACKEND" ] && echo "BACKEND must be set!" && exit 1
[ -z "$MODEL_LOG" ] && echo "MODEL_LOG must be set!" && exit 1
[ "$BACKEND" = "comfyui" ] && [ -z "$COMFY_MODEL" ] && echo "For comfyui backends, COMFY_MODEL must be set!" && exit 1

echo "new version"
echo "start_server.sh"
date

echo_var BACKEND
echo_var REPORT_ADDR
echo_var WORKER_PORT
echo_var WORKSPACE_DIR
echo_var SERVER_DIR
echo_var ENV_PATH
echo_var DEBUG_LOG
echo_var PYWORKER_LOG
echo_var MODEL_LOG

env | grep _ >> /etc/environment;


if [ ! -d "$ENV_PATH" ]
then
    apt install -y python3.10-venv
    echo "setting up venv"

    git clone https://github.com/zenpalio/vastai-pyworker "$SERVER_DIR"

    python3 -m venv "$WORKSPACE_DIR/worker-env"
    source "$WORKSPACE_DIR/worker-env/bin/activate"
    pip install uv

    uv pip install -r vast-pyworker/requirements.txt

    touch ~/.no_auto_tmux
else
    source "$WORKSPACE_DIR/worker-env/bin/activate"
    echo "environment activated"
    echo "venv: $VIRTUAL_ENV"
fi

[ ! -d "$SERVER_DIR/workers/$BACKEND" ] && echo "$BACKEND not supported!" && exit 1

if [ "$USE_SSL" = true ]; then

    cat << EOF > /etc/openssl-san.cnf
    [req]
    default_bits       = 2048
    distinguished_name = req_distinguished_name
    req_extensions     = v3_req

    [req_distinguished_name]
    countryName         = US
    stateOrProvinceName = CA
    organizationName    = Vast.ai Inc.
    commonName          = vast.ai

    [v3_req]
    basicConstraints = CA:FALSE
    keyUsage         = nonRepudiation, digitalSignature, keyEncipherment
    subjectAltName   = @alt_names

    [alt_names]
    IP.1   = 0.0.0.0
EOF

openssl req -newkey rsa:2048 -subj "/C=US/ST=CA/CN=pyworker.vast.ai/" \
    -nodes \
    -sha256 \
    -keyout /etc/instance.key \
    -out /etc/instance.csr \
    -config /etc/openssl-san.cnf

curl --header 'Content-Type: application/octet-stream' \
    --data-binary @//etc/instance.csr \
    -X \
    POST "https://console.vast.ai/api/v0/sign_cert/?instance_id=$CONTAINER_ID" > /etc/instance.crt;
fi




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

