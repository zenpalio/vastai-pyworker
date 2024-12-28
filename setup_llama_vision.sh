#!/bin/bash
# Install necessary packages
WORKSPACE_DIR="${WORKSPACE_DIR:-/workspace}"
cd "$WORKSPACE_DIR"
pip install uv
uv pip install transformers 
uv pip install torch
uv pip install peft
uv pip install bitsandbytes
uv pip install aiohttp
uv pip install pillow
echo "starting server"
wget -O - "https://raw.githubusercontent.com/zenpalio/vastai-pyworker/main/start_server.sh" | bash && (text-generation-launcher --model-id "$MODEL_ID" --json-output --port 5001 --hostname "0.0.0.0" &>> $MODEL_LOG)



