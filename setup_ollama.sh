#!/bin/bash
export BACKEND=tgi
wget -O - "https://raw.githubusercontent.com/zenpalio/vastai-pyworker/main/start_server.sh" | bash && (text-generation-launcher --model-id "$MODEL_ID" --json-output --port 5001 --hostname "0.0.0.0" &>> $MODEL_LOG)

wget https://huggingface.co/Orenguteng/Llama-3.1-8B-Lexi-Uncensored-GGUF/resolve/main/Llama-3.1-8B-Lexi-Uncensored_F16.gguf 2>&1 | tee model_download.log
# Define the template content
echo "Creating the model file2"
cat << 'EOF' > llama3-uncensored.modelfile
FROM ./Llama-3.1-8B-Lexi-Uncensored_F16.gguf
TEMPLATE """{{ if .System }}<|start_header_id|>system<|end_header_id|>

{{ .System }}<|eot_id|>{{ end }}<|start_header_id|>user<|end_header_id|>

{{ .Prompt }}<|eot_id|><|start_header_id|>assistant<|end_header_id|>

{{ .Response }}"""
SYSTEM """You are Veronica a flirty girl of age 21"""
PARAMETER num_ctx 8192
PARAMETER num_gpu 99
EOF

# Create and run the model using ollama
echo "Creating and running the model"
ollama serve &
sleep 10
ollama create llama3-uncensored -f llama3-uncensored.modelfile 
ollama run llama3-uncensored

# Export BACKEND variable and download/start the server script
