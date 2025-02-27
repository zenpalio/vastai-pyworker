wget https://huggingface.co/Kijai/HunyuanVideo_comfy/resolve/main/hunyuan_video_FastVideo_720_fp8_e4m3fn.safetensors
wget https://huggingface.co/Kijai/HunyuanVideo_comfy/resolve/main/hunyuan_video_vae_bf16.safetensors
wget https://huggingface.co/leapfusion-image2vid-test/image2vid-512x320/resolve/main/img2vid.safetensors
wget https://huggingface.co/Kijai/HunyuanVideo_comfy/resolve/main/hyvideo_FastVideo_LoRA-fp8.safetensors
wget https://huggingface.co/JimmyYHung/ESRGAN/resolve/main/4x-UniScaleV2_Sharp.pth




masterpiece, best quality of <image> girl dancing moving her hips softly.

source /opt/environments/python/comfyui/bin/activate
python -c "import torch; print(torch.__version__)"

pip uninstall torch torchvision torchaudio xformers came-pytorch lion-pytorch torchsde -y

pip install --no-cache-dir torch==2.5.0+cu124 torchvision==0.20.0+cu124 torchaudio==2.5.0+cu124 xformers==0.0.28.post2 --index-url https://download.pytorch.org/whl/cu124

pip install --no-cache-dir torchsde==0.2.6

pip install sageattention

deactivate

cp /usr/local/lib/python3.11/dist-packages/nvidia/cudnn /workspace/ComfyUI/venv/lib/python3.11/site-packages/nvidia -r

export LD_LIBRARY_PATH=/usr/lib/x86_64-linux-gnu/:$LD_LIBRARY_PATH

echo "export LD_LIBRARY_PATH=/usr/lib/x86_64-linux-gnu/:$LD_LIBRARY_PATH" >> /workspace/ComfyUI/venv/bin/activate

ldconfig

source /opt/environments/python/comfyui/bin/activate

python -c "import torch; print(torch.__version__)"

pip list | grep -E "torch|torchvision|torchaudio|xformers"
