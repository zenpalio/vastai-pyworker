apt-get update -y
apt-get install apt-transport-https ca-certificates gnupg curl -y
curl https://packages.cloud.google.com/apt/doc/apt-key.gpg | sudo gpg --dearmor -o /usr/share/keyrings/cloud.google.gpg
echo "deb [signed-by=/usr/share/keyrings/cloud.google.gpg] https://packages.cloud.google.com/apt cloud-sdk main" | sudo tee -a /etc/apt/sources.list.d/google-cloud-sdk.list
apt-get update &&  apt-get install google-cloud-cli -y

echo "$SERVICE_ACCOUNT_JSON" > ./zenpalio-f0ec2f137303.json

gcloud auth activate-service-account --key-file=./zenpalio-f0ec2f137303.json
gcloud config set project zenpalio
gsutil cp gs://aibabe-models/lustifySDXLNSFW_endgameDMD2.safetensors lustifySDXLNSFW_endgameDMD2.safetensors

