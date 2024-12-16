#!/bin/bash
# This file will be sourced in init.sh
# Namespace functions with provisioning_

# https://raw.githubusercontent.com/ai-dock/stable-diffusion-webui/main/config/provisioning/default.sh

### Edit the following arrays to suit your workflow - values must be quoted and separated by newlines or spaces.
### If you specify gated models you'll need to set environment variables HF_TOKEN and/orf CIVITAI_TOKEN

DISK_GB_REQUIRED=30

APT_PACKAGES=(
    #"package-1"
    #"package-2"
)

PIP_PACKAGES=(
    #"package-1"
    #"package-2"
)

EXTENSIONS=(
    #"https://github.com/Mikubill/sd-webui-controlnet"
    #"https://github.com/deforum-art/sd-webui-deforum"
    #"https://github.com/adieyal/sd-dynamic-prompts"
    #"https://github.com/ototadana/sd-face-editor"
    #"https://github.com/AlUlkesh/stable-diffusion-webui-images-browser"
    #"https://github.com/hako-mikan/sd-webui-regional-prompter"
    #"https://github.com/Coyote-A/ultimate-upscale-for-automatic1111"
    #"https://github.com/Gourieff/sd-webui-reactor"
    "https://github.com/Bing-su/adetailer"
)

CHECKPOINT_MODELS=(
    #"https://civitai.com/api/download/models/929239?type=Model&format=SafeTensor&size=full&fp=fp16" #big lust15
    #"https://civitai.com/api/download/models/926965?type=Model&format=SafeTensor&size=pruned&fp=fp16" #lustify40
    #"https://civitai.com/api/download/models/1047139?type=Model&format=SafeTensor&size=pruned&fp=fp16" #pony40
    #"https://civitai.com/api/download/models/1094291?type=Model&format=SafeTensor&size=pruned&fp=fp16" #lustify50
    "https://civitai.com/api/download/models/128080?type=Model&format=SafeTensor&size=pruned&fp=fp16"
    #"https://civitai.com/api/download/models/176425?type=Model&format=SafeTensor&size=pruned&fp=fp16" #test small model
)

LORA_MODELS=(
    "https://civitai.com/api/download/models/558984?type=Model&format=SafeTensor" #cartoon style        https://civitai.com/models/45521?modelVersionId=558984
    "https://civitai.com/api/download/models/382152?type=Model&format=SafeTensor" #expresive            https://civitai.com/models/341353/expressiveh-hentai-lora-style
    "https://civitai.com/api/download/models/507741?type=Model&format=SafeTensor" #3d blender style     https://civitai.com/models/456102/blender-3d-porn-pony
    "https://civitai.com/api/download/models/467356?type=Model&format=SafeTensor" #3d disney style      https://civitai.com/models/405143?modelVersionId=467356
    "https://civitai.com/api/download/models/839103?type=Model&format=SafeTensor" #sexy buts style      https://civitai.com/models/11161/cutesexyrobutts-style?modelVersionId=839103
    "https://civitai.com/api/download/models/471570?type=Model&format=SafeTensor" #Ahegao               https://civitai.com/models/401685/ahegao?modelVersionId=471570
    "https://civitai.com/api/download/models/410706?type=Model&format=SafeTensor" #butt plug            https://civitai.com/models/136438/butt-plug-pony15-or-goofy-ai?modelVersionId=410706
    "https://civitai.com/api/download/models/691629?type=Model&format=SafeTensor" #mating press         https://civitai.com/api/download/models/691629?type=Model&format=SafeTensor
    "https://civitai.com/api/download/models/598315?type=Model&format=SafeTensor" #double penetration   https://civitai.com/models/136438/butt-plug-pony15-or-goofy-ai?modelVersionId=410706   
    "https://civitai.com/api/download/models/807075?type=Model&format=SafeTensor" #facesitting POV      https://civitai.com/models/721793/face-sit-pov-or-goofy-ai?modelVersionId=807075
    "https://civitai.com/api/download/models/725112?type=Model&format=SafeTensor" #Pillory BDSM         https://civitai.com/models/648133/pillory-or-goofy-ai?modelVersionId=725112
    "https://civitai.com/api/download/models/578868?type=Model&format=SafeTensor" #Sexy Clothing XL     https://civitai.com/models/244864/realisticandanimesexy-clothing-collection-oror-and?modelVersionId=578868
    "https://civitai.com/api/download/models/471781?type=Model&format=SafeTensor" #Feet XL              https://civitai.com/models/200251/feet-xl-sd-15-flux1-dev?modelVersionId=471781
    "https://civitai.com/api/download/models/972475?type=Model&format=SafeTensor" #Spread Pussy XL      https://civitai.com/models/149904/real-pussy-spreading?modelVersionId=972475
    "https://civitai.com/api/download/models/722906?type=Model&format=SafeTensor" #Toys XL              https://civitai.com/models/132350/kinkytoys-balls?modelVersionId=722906
    "https://civitai.com/api/download/models/280241?type=Model&format=SafeTensor" #Fingering XL         https://civitai.com/models/248361/fingering-sdxl?modelVersionId=280241
    "https://civitai.com/api/download/models/626812?type=Model&format=SafeTensor" #Bondage              https://civitai.com/models/528877/fluxsdxlpony-device-bondage?modelVersionId=626812
    "https://civitai.com/api/download/models/136277?type=Model&format=SafeTensor" #sexy underwear       https://civitai.com/models/124782/sdxlsexy-underwear?modelVersionId=136277
)

VAE_MODELS=(
    "https://huggingface.co/stabilityai/sdxl-vae/resolve/main/sdxl_vae.safetensors"
)

ESRGAN_MODELS=(
    #"https://huggingface.co/ai-forever/Real-ESRGAN/resolve/main/RealESRGAN_x4.pth"
    #"https://huggingface.co/FacehugmanIII/4x_foolhardy_Remacri/resolve/main/4x_foolhardy_Remacri.pth"
    #"https://huggingface.co/Akumetsu971/SD_Anime_Futuristic_Armor/resolve/main/4x_NMKD-Siax_200k.pth"
)

CONTROLNET_MODELS=(
    #"https://huggingface.co/lllyasviel/sd_control_collection/resolve/main/diffusers_xl_canny_mid.safetensors"
    #"https://huggingface.co/lllyasviel/sd_control_collection/resolve/main/diffusers_xl_depth_mid.safetensors?download"
    #"https://huggingface.co/lllyasviel/sd_control_collection/resolve/main/t2i-adapter_diffusers_xl_openpose.safetensors"
    #"https://huggingface.co/webui/ControlNet-modules-safetensors/resolve/main/control_canny-fp16.safetensors"
    #"https://huggingface.co/webui/ControlNet-modules-safetensors/resolve/main/control_depth-fp16.safetensors"
    #"https://huggingface.co/webui/ControlNet-modules-safetensors/resolve/main/control_hed-fp16.safetensors"
    #"https://huggingface.co/webui/ControlNet-modules-safetensors/resolve/main/control_mlsd-fp16.safetensors"
    #"https://huggingface.co/webui/ControlNet-modules-safetensors/resolve/main/control_normal-fp16.safetensors"
    #"https://huggingface.co/webui/ControlNet-modules-safetensors/resolve/main/control_openpose-fp16.safetensors"
    #"https://huggingface.co/webui/ControlNet-modules-safetensors/resolve/main/control_scribble-fp16.safetensors"
    #"https://huggingface.co/webui/ControlNet-modules-safetensors/resolve/main/control_seg-fp16.safetensors"
    #"https://huggingface.co/webui/ControlNet-modules-safetensors/resolve/main/t2iadapter_canny-fp16.safetensors"
    #"https://huggingface.co/webui/ControlNet-modules-safetensors/resolve/main/t2iadapter_color-fp16.safetensors"
    #"https://huggingface.co/webui/ControlNet-modules-safetensors/resolve/main/t2iadapter_depth-fp16.safetensors"
    #"https://huggingface.co/webui/ControlNet-modules-safetensors/resolve/main/t2iadapter_keypose-fp16.safetensors"
    #"https://huggingface.co/webui/ControlNet-modules-safetensors/resolve/main/t2iadapter_openpose-fp16.safetensors"
    #"https://huggingface.co/webui/ControlNet-modules-safetensors/resolve/main/t2iadapter_seg-fp16.safetensors"
    #"https://huggingface.co/webui/ControlNet-modules-safetensors/resolve/main/t2iadapter_sketch-fp16.safetensors"
    #"https://huggingface.co/webui/ControlNet-modules-safetensors/resolve/main/t2iadapter_style-fp16.safetensors"
)


### DO NOT EDIT BELOW HERE UNLESS YOU KNOW WHAT YOU ARE DOING ###

function provisioning_start() {
    # We need to apply some workarounds to make old builds work with the new default
    printf "Starting provisioning...\n"
    printf "custom provisioning\n"
    if [[ ! -d /opt/environments/python ]]; then 
        export MAMBA_BASE=true
    fi
    source /opt/ai-dock/etc/environment.sh
    source /opt/ai-dock/bin/venv-set.sh webui

    DISK_GB_AVAILABLE=$(($(df --output=avail -m "${WORKSPACE}" | tail -n1) / 1000))
    DISK_GB_USED=$(($(df --output=used -m "${WORKSPACE}" | tail -n1) / 1000))
    DISK_GB_ALLOCATED=$(($DISK_GB_AVAILABLE + $DISK_GB_USED))
    provisioning_print_header
    provisioning_get_apt_packages
    provisioning_get_pip_packages
    provisioning_get_extensions
    provisioning_get_models \
        "${WORKSPACE}/storage/stable_diffusion/models/ckpt" \
        "${CHECKPOINT_MODELS[@]}"
    provisioning_get_models \
        "${WORKSPACE}/storage/stable_diffusion/models/lora" \
        "${LORA_MODELS[@]}"
    provisioning_get_models \
        "${WORKSPACE}/storage/stable_diffusion/models/controlnet" \
        "${CONTROLNET_MODELS[@]}"
    provisioning_get_models \
        "${WORKSPACE}/storage/stable_diffusion/models/vae" \
        "${VAE_MODELS[@]}"
    provisioning_get_models \
        "${WORKSPACE}/storage/stable_diffusion/models/esrgan" \
        "${ESRGAN_MODELS[@]}"
     
    PLATFORM_ARGS=""
    if [[ $XPU_TARGET = "CPU" ]]; then
        PLATFORM_ARGS="--use-cpu all --skip-torch-cuda-test --no-half"
    fi
    PROVISIONING_ARGS="--skip-python-version-check --no-download-sd-model --do-not-download-clip --port 11404 --exit"
    ARGS_COMBINED="${PLATFORM_ARGS} $(cat /etc/a1111_webui_flags.conf) ${PROVISIONING_ARGS}"
    
    # Start and exit because webui will probably require a restart
    cd /opt/stable-diffusion-webui
    if [[ -z $MAMBA_BASE ]]; then
        source "$WEBUI_VENV/bin/activate"
        LD_PRELOAD=libtcmalloc.so python launch.py \
            ${ARGS_COMBINED}
        deactivate
    else 
        micromamba run -n webui -e LD_PRELOAD=libtcmalloc.so python launch.py \
            ${ARGS_COMBINED}
    fi
    provisioning_print_end
}

function pip_install() {
    if [[ -z $MAMBA_BASE ]]; then
            "$WEBUI_VENV_PIP" install --no-cache-dir "$@"
        else
            micromamba run -n webui pip install --no-cache-dir "$@"
        fi
}

function provisioning_get_apt_packages() {
    if [[ -n $APT_PACKAGES ]]; then
            sudo $APT_INSTALL ${APT_PACKAGES[@]}
    fi
}

function provisioning_get_pip_packages() {
    if [[ -n $PIP_PACKAGES ]]; then
            pip_install ${PIP_PACKAGES[@]}
    fi
}

function provisioning_get_extensions() {
    for repo in "${EXTENSIONS[@]}"; do
        dir="${repo##*/}"
        path="/opt/stable-diffusion-webui/extensions/${dir}"
        if [[ -d $path ]]; then
            # Pull only if AUTO_UPDATE
            if [[ ${AUTO_UPDATE,,} == "true" ]]; then
                printf "Updating extension: %s...\n" "${repo}"
                ( cd "$path" && git pull )
            fi
        else
            printf "Downloading extension: %s...\n" "${repo}"
            git clone "${repo}" "${path}" --recursive
        fi
    done
}

function provisioning_get_models() {
    if [[ -z $2 ]]; then return 1; fi
    dir="$1"
    mkdir -p "$dir"
    shift
    if [[ $DISK_GB_ALLOCATED -ge $DISK_GB_REQUIRED ]]; then
        arr=("$@")
    else
        printf "WARNING: Low disk space allocation - Only the first model will be downloaded!\n"
        arr=("$1")
    fi
    
    printf "Downloading %s model(s) to %s...\n" "${#arr[@]}" "$dir"
    for url in "${arr[@]}"; do
        printf "Downloading: %s\n" "${url}"
        provisioning_download "${url}" "${dir}"
        printf "\n"
    done
}

function provisioning_print_header() {
    printf "\n##############################################\n#                                            #\n#          Provisioning container            #\n#                                            #\n#         This will take some time           #\n#                                            #\n# Your container will be ready on completion #\n#                                            #\n##############################################\n\n"
    if [[ $DISK_GB_ALLOCATED -lt $DISK_GB_REQUIRED ]]; then
        printf "WARNING: Your allocated disk size (%sGB) is below the recommended %sGB - Some models will not be downloaded\n" "$DISK_GB_ALLOCATED" "$DISK_GB_REQUIRED"
    fi
}

function provisioning_print_end() {
    printf "\nProvisioning complete:  Web UI will start now\n\n"
}


# Download from $1 URL to $2 file path
function provisioning_download() {
if [[ -n $CIVITAI_TOKEN && $1 =~ ^https://([a-zA-Z0-9_-]+\.)?civitai\.com(/|$|\?) ]]; then
    civit_auth_token="$CIVITAI_TOKEN"
elif [[ -n $HF_TOKEN && $1 =~ ^https://([a-zA-Z0-9_-]+\.)?huggingface\.co(/|$|\?) ]]; then
    auth_token="$HF_TOKEN"
fi

if [[ -n $civit_auth_token ]]; then
    url="${1}&token=${civit_auth_token}"
    printf "Downloading civitai %s\n" "$url"
    wget -qnc --content-disposition --show-progress -e dotbytes="${3:-4M}" -P "$2" "$url"
elif [[ -n $auth_token ]]; then
    wget --header="Authorization: Bearer $auth_token" -qnc --content-disposition --show-progress -e dotbytes="${3:-4M}" -P "$2" "$1"
else
    wget -qnc --content-disposition --show-progress -e dotbytes="${3:-4M}" -P "$2" "$1"
fi
unset civit_auth_token
}

provisioning_start