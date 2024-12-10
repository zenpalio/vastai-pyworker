#!/bin/bash
export BACKEND=tgi
export REPORT_ADDR=https://ede7-2a00-102a-400c-a8f1-a2-30ed-cd71-a9f6.ngrok-free.app 
export USE_SSL=false
export provider=runpod

apt update;
apt install python3-pip -y;
apt install git -y;
apt install curl -y;
# Install necessary packages
pip install uv
uv venv
source .venv/bin/activate
#uv pip install aphrodite-engine
#uv pip install setuptools
#uv pip install ray
#echo "starting aphrodite"
#aphrodite run Orenguteng/Llama-3.1-8B-Lexi-Uncensored-V2 -tp 2 &

#sleep 60
echo "starting server"
wget -O - "https://raw.githubusercontent.com/zenpalio/vastai-pyworker/main/start_server.sh" | bash && (text-generation-launcher --model-id "$MODEL_ID" --json-output --port 5001 --hostname "0.0.0.0" &>> $MODEL_LOG)



