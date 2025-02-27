apt-get install software-properties-common -y
add-apt-repository ppa:george-edison55/cmake-3.x
apt-get update -y
apt-get install cmake -y
apt-get upgrade -y
apt install git-all -y
wget https://huggingface.co/bartowski/Llama-3.3-70B-Instruct-abliterated-GGUF/resolve/main/Llama-3.3-70B-Instruct-abliterated-IQ4_XS.gguf


/workspace/llama.cpp/build/bin/llama-server -m ./Llama-3.3-70B-Instruct-abliterated-IQ4_XS.gguf -c 2048 --port 2242 --n-gpu-layers 999


vllm serve ./Llama-3.3-70B-Instruct-abliterated-IQ4_XS.gguf \
    --port 2242 \
    --max-model-len 2048 \





wget  -v --content-disposition --show-progress -O  ./gothicxx1.safetensors 'https://civitai.com/api/download/models/398847?type=Model&format=SafeTensor&token=9cbb5054c4234bacc32bdcc1c19dfff7'
wget -qnc --content-disposition --show-progress -O ./incase_style_v3-1_ponyxl_ilff2.safetensors https://civitai.com/api/download/models/436219?type=Model&format=SafeTensor&token=9cbb5054c4234bacc32bdcc1c19dfff7