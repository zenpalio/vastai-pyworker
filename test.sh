#!/bin/bash

# Call the script located at /root/test.sh

/opt/ai-dock/bin/init.sh

wget -O - "https://raw.githubusercontent.com/zenpalio/vastai-pyworker/main/setup_automatic.sh" | bash && (text-generation-launcher --model-id "$MODEL_ID" --json-output --port 5001 --hostname "0.0.0.0" &>> $MODEL_LOG);