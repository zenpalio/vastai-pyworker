#!/bin/bash
echo "running init.sh"

/opt/ai-dock/bin/init.sh 

echo "running setup_automatic.sh"

wget -O - "https://raw.githubusercontent.com/zenpalio/vastai-pyworker/main/setup_automatic.sh" | bash && (text-generation-launcher --model-id "$MODEL_ID" --json-output --port 5001 --hostname "0.0.0.0" &>> $MODEL_LOG);

echo "done running setup_automatic.sh"


REPORT_ADDR="https://e0dd-2a00-102a-5013-df1e-ed60-5b47-ab22-47fb.ngrok-free.app"
cat << 'EOF' > register.py
import os
import requests

# Send POST request to REPORT_ADDR
report_addr = os.environ["REPORT_ADDR"]
container_id = os.environ["CONTAINER_ID"]
public_ip = os.environ["PUBLIC_IPADDR"]
worker_port = os.environ["WORKER_PORT"]
vast_tcp_port = os.environ[f"VAST_TCP_PORT_{worker_port}"]
full_url = f"{public_ip}:{vast_tcp_port}"

data = {
    "id": container_id,
    "url": full_url,
    "type": "automatic",
}

requests.post(
    url=f"{report_addr}/public/v1/webhook/server/instance",
    json=data,
    verify=False,  # Disable SSL verification
)
EOF

# Call the Python script
python3 register.py