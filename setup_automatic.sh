function setup_gsutils() {
    echo "Setting up gsutils..."
    export DEBIAN_FRONTEND=noninteractive
    sudo apt-get update -y
    sudo apt-get install apt-transport-https ca-certificates gnupg curl -y

    if [ -f /usr/share/keyrings/cloud.google.gpg ]; then
        sudo rm /usr/share/keyrings/cloud.google.gpg
    fi

    curl https://packages.cloud.google.com/apt/doc/apt-key.gpg | sudo gpg --dearmor -o /usr/share/keyrings/cloud.google.gpg
    echo "deb [signed-by=/usr/share/keyrings/cloud.google.gpg] https://packages.cloud.google.com/apt cloud-sdk main" | sudo tee -a /etc/apt/sources.list.d/google-cloud-sdk.list
    export DEBIAN_FRONTEND=noninteractive
    DEBIAN_FRONTEND=noninteractive sudo apt-get install google-cloud-cli -y

    echo "$SERVICE_ACCOUNT_JSON" > ./zenpalio-f0ec2f137303.json

    gcloud auth activate-service-account --key-file=./zenpalio-f0ec2f137303.json
    gcloud config set project zenpalio
    echo "finished setting up gsutils"
}

setup_gsutils
export BACKEND=automatic1111
/opt/ai-dock/bin/init.sh  &
wget -O - "https://raw.githubusercontent.com/zenpalio/vastai-pyworker/main/start_server.sh" | bash && (text-generation-launcher --model-id "$MODEL_ID" --json-output --port 5001 --hostname "0.0.0.0" &>> $MODEL_LOG);



