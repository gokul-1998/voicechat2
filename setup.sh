#!/bin/bash

# Update the package list
sudo apt update

# Install helpful tools (byobu, curl, wget)
sudo apt install -y byobu curl wget

# Install audio processing tools (espeak-ng, ffmpeg, libopus0, libopus-dev)
sudo apt install -y espeak-ng ffmpeg libopus0 libopus-dev 

# Check if conda is installed, and if not, download and install Miniconda
if ! command -v conda &> /dev/null
then
    echo "Conda not found, installing Miniconda..."
    wget https://repo.anaconda.com/miniconda/Miniconda3-latest-Linux-x86_64.sh -O miniconda.sh
    bash miniconda.sh -b -p $HOME/miniconda
    export PATH="$HOME/miniconda/bin:$PATH"
    source "$HOME/miniconda/etc/profile.d/conda.sh"
    echo "Conda installed successfully."
else
    echo "Conda is already installed."
    source "$HOME/miniconda/etc/profile.d/conda.sh"
fi

# Initialize conda for the current shell session
conda init bash
source ~/.bashrc

# Install mamba, a faster alternative to conda, in the base environment
conda install mamba -n base -c conda-forge -y 

# Create a new environment with Python 3.11 using mamba
mamba create -y -n voicechat2 python=3.11

# Initialize Mamba for the current shell session
eval "$(mamba shell hook --shell bash)"

# Activate the environment
mamba activate voicechat2

# Optional: Persist Mamba initialization for future sessions (commented out if not needed)
# mamba shell init --shell bash --root-prefix=~/.local/share/mamba

# Ensure pip is available in the new environment
mamba install -y pip

# Install required Python packages from requirements.txt
pip install -r requirements.txt
