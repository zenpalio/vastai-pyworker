#!/bin/bash

# Activate the virtual environment


# Install necessary packages
pip install uv
uv venv
source .venv/bin/activate
uv pip install aphrodite-engine
uv pip install setuptools
uv pip install ray


aphrodite run Orenguteng/Llama-3-8B-Lexi-Uncensored