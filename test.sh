#!/bin/bash
rm /opt/ai-dock/bin/provisioning.sh
wget -O /opt/ai-dock/bin/provisioning.sh "https://raw.githubusercontent.com/zenpalio/vastai-pyworker/refs/heads/main/automatic_scripts/provisioning.sh"
rm /opt/ai-dock/bin/supervisor-webui.sh
wget -O /opt/ai-dock/bin/supervisor-webui.sh "https://raw.githubusercontent.com/zenpalio/vastai-pyworker/refs/heads/main/automatic_scripts/supervisor-webui.sh"