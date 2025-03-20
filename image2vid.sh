#diffusion_models
mkdir /workspace/ComfyUI/models/diffusion_models
cd /workspace/ComfyUI/models/diffusion_models
wget --show-progress 'https://huggingface.co/Comfy-Org/HunyuanVideo_repackaged/resolve/main/split_files/diffusion_models/hunyuan_video_image_to_video_720p_bf16.safetensors'
wget --show-progress 'https://huggingface.co/Comfy-Org/HunyuanVideo_repackaged/resolve/main/split_files/diffusion_models/hunyuan_video_v2_replace_image_to_video_720p_bf16.safetensors'


#vae
cd /workspace/ComfyUI/models/vae
wget --show-progress 'https://huggingface.co/Kijai/HunyuanVideo_comfy/resolve/main/hunyuan_video_vae_bf16.safetensors'


#text_encoders
mkdir /workspace/ComfyUI/models/text_encoders
cd /workspace/ComfyUI/models/text_encoders
wget --show-progress 'https://huggingface.co/Comfy-Org/HunyuanVideo_repackaged/resolve/main/split_files/text_encoders/llava_llama3_fp16.safetensors'
wget --show-progress 'https://huggingface.co/comfyanonymous/flux_text_encoders/resolve/main/clip_l.safetensors'
wget --show-progress 'https://huggingface.co/calcuis/hunyuan-gguf/resolve/main/llava_llama3_fp8_scaled.safetensors'

#clip_vision
mkdir /workspace/ComfyUI/models/clip_vision
cd /workspace/ComfyUI/models/clip_vision
wget --show-progress 'https://huggingface.co/Comfy-Org/HunyuanVideo_repackaged/resolve/main/split_files/clip_vision/llava_llama3_vision.safetensors'


