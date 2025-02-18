export BACKEND=automatic1111
wget -O - "/vastai-pyworker/start_server.sh" | bash && (text-generation-launcher --model-id "$MODEL_ID" --json-output --port 5001 --hostname "0.0.0.0" &>> $MODEL_LOG);
/opt/ai-dock/bin/init.sh &

