export BACKEND=tgi
wget -O - "https://raw.githubusercontent.com/zenpalio/vastai-pyworker/main/start_server.sh" | bash && (text-generation-launcher --model-id "$MODEL_ID" --json-output --port 5001 --hostname "0.0.0.0" &>> $MODEL_LOG)


echo "Creating and running the model"
ollama serve &
sleep 10
ollama run llama3-uncensored