#!/bin/bash

# Activate the virtual environment
source .venv/bin/activate

# Install necessary packages
pip install uv
pip install aphrodite-engine
pip install setuptools
pip install ray

# Run aphrodite
aphrodite run Orenguteng/Llama-3-8B-Lexi-Uncensored