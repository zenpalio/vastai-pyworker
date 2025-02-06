#!/bin/bash
# Install necessary packages
pip install uv
uv venv
source .venv/bin/activate
uv pip install setuptools
uv pip install ray
uv pip install vllm

echo "starting aphrodite"
vllm serve  ./workspace/Llama-3.3-70B-Instruct-abliterated-IQ3_M.gguff --tokenizer huihui-ai/Llama-3.3-70B-Instruct-abliterated -port 2242 --enforce-eager --max-model-len 8192 &

# Wait for the curl request to return a successful response with a timeout of 10 minutes
timeout=600  # Total timeout in seconds
interval=5   # Interval between checks in seconds
elapsed=0

while [ $elapsed -lt $timeout ]; do
    status=$(curl -s -o /dev/null -w "%{http_code}" -k http://localhost:2242/v1/models \
      -H "Content-Type: application/json")
    echo "Status: $status"
    if [ "$status" -eq 200 ]; then
        break
    fi
    sleep $interval
    elapsed=$((elapsed + interval))
done

if [ $elapsed -ge $timeout ]; then
    echo "Timeout reached while waiting for the curl request to return a successful response."
    exit 1
fi

echo "starting server"
wget -O - "https://raw.githubusercontent.com/zenpalio/vastai-pyworker/main/start_server.sh" | bash && (text-generation-launcher --model-id "$MODEL_ID" --json-output --port 5001 --hostname "0.0.0.0" &>> $MODEL_LOG)



