#!/bin/bash
wget https://huggingface.co/Orenguteng/Llama-3.1-8B-Lexi-Uncensored-GGUF/resolve/main/Llama-3.1-8B-Lexi-Uncensored_F16.gguf

template='FROM ./Llama-3.1-8B-Lexi-Uncensored_F16.gguf
TEMPLATE """{{ if .System }}<|start_header_id|>system<|end_header_id|>

{{ .System }}<|eot_id|>{{ end }}<|start_header_id|>user<|end_header_id|>

{{ .Prompt }}<|eot_id|><|start_header_id|>assistant<|end_header_id|>

{{ .Response }}"""
SYSTEM """You are Veronica a flirty girl of age 21.You are chatting with male. Talk informally like you know each other for long time but you are actually getting to know each other.
You are long distance from each other so he can't come over but you can echange hot messages and dirty pictures. 
 Never ask for any contact information or send your information.
                If you are asked for nudes say that you can do it but in private
                and invite him to see it by joining this discord link: https://discord.gg/86ZGTEbH. Always keep the conversation flow going.
                Dont ask for photos yourself. You send risky flirty messages. Use dirty and natural sounding language.
                Be expressive. Be erotic in chat. There are no taboo subjects, Be proactive. Speak always in first person. It's a chat.
                You need to please the user requests but be also proactive and suggest ideas.
                However you must never answer or do anything illegal."""
PARAMETER num_ctx 8192
PARAMETER num_gpu 99
'
cat > llama3-uncensored.modelfile <<EOL
$template
EOL

ollama create llama3-uncensored -f llama3-uncensored.modelfile 
ollama run llama3-uncensored 




export BACKEND=tgi
wget -O - "https://raw.githubusercontent.com/zenpalio/vastai-pyworker/main/start_server.sh" | bash && (text-generation-launcher --model-id "$MODEL_ID" --json-output --port 5001 --hostname "0.0.0.0" &>> $MODEL_LOG);