function setup_gsutils() {
    echo "Setting up gsutils..."
    sudo apt-get update -y
    sudo apt-get install apt-transport-https ca-certificates gnupg curl -y

    if [ -f /usr/share/keyrings/cloud.google.gpg ]; then
        sudo rm /usr/share/keyrings/cloud.google.gpg
    fi

    curl https://packages.cloud.google.com/apt/doc/apt-key.gpg | sudo gpg --dearmor -o /usr/share/keyrings/cloud.google.gpg
    echo "deb [signed-by=/usr/share/keyrings/cloud.google.gpg] https://packages.cloud.google.com/apt cloud-sdk main" | sudo tee -a /etc/apt/sources.list.d/google-cloud-sdk.list
    sudo apt-get install google-cloud-cli -y

    echo "$SERVICE_ACCOUNT_JSON" > ./zenpalio-f0ec2f137303.json

    gcloud auth activate-service-account --key-file=./zenpalio-f0ec2f137303.json
    gcloud config set project zenpalio
    echo "finished setting up gsutils"
}

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

EOF

# Call the Python script
python3 script.py
setup_gsutils
export BACKEND=automatic1111
wget -O - "https://raw.githubusercontent.com/zenpalio/vastai-pyworker/main/start_server.sh" | bash && (text-generation-launcher --model-id "$MODEL_ID" --json-output --port 5001 --hostname "0.0.0.0" &>> $MODEL_LOG);
/opt/ai-dock/bin/init.sh &



