
sudo apt install wget git python3 python3-venv libgl1 libglib2.0-0 -y
wget -q https://raw.githubusercontent.com/AUTOMATIC1111/stable-diffusion-webui/master/webui.sh
pip install --force-reinstall --pre torch torchvision --index-url  https://download.pytorch.org/whl/nightly/cu128

set XFORMERS_PACKAGE=xformers==0.0.29.post2
apt-get install -y libgl1-mesa-dev
apt-get install -y libglib2.0-0

pip install --pre torch torchvision torchaudio --index-url https://download.pytorch.org/whl/nightly/cu128 -r requirements.txt