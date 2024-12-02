#!/bin/bash




# Install necessary packages
pip install uv
uv venv
source .venv/bin/activate
uv pip install aphrodite-engine
uv pip install setuptools
uv pip install ray
cat > /workspace/finished_aphrodite.txt
aphrodite run Orenguteng/Llama-3-8B-Lexi-Uncensored


tmux new-window -d -n "start_server" "wget -O - 'https://raw.githubusercontent.com/zenpalio/vastai-pyworker/main/start_server.sh' | bash && (text-generation-launcher --model-id '$MODEL_ID' --json-output --port 5001 --hostname '0.0.0.0' &>> '$MODEL_LOG')"