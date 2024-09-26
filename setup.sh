#!/bin/bash

# Update the package list
sudo apt update

# Install helpful tools (byobu, curl, wget)
sudo apt install -y byobu curl wget

# Install audio processing tools (espeak-ng, ffmpeg, libopus0, libopus-dev)
sudo apt install -y espeak-ng ffmpeg libopus0 libopus-dev 

# Install mamba, a faster alternative to conda, in the base environment
conda install mamba -n base -c conda-forge -y 

# Create a new environment with Python 3.11
mamba create -y -n voicechat2 python=3.11

# Initialize Mamba for the current shell session
eval "$(mamba shell hook --shell bash)"

# Activate the environment
mamba activate voicechat2

# Optional: Persist Mamba initialization for future sessions (commented out if not needed)
# mamba shell init --shell bash --root-prefix=~/.local/share/mamba

pip install -r requirements.txt
