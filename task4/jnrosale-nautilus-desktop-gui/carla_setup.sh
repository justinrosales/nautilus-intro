#!/bin/bash

# Run script with source carla_setup.sh

# Try to change permissions if sudo-root or sudo is available
if command -v sudo-root &> /dev/null; then
    sudo-root -u root chown -R ubuntu /home/ubuntu
elif command -v sudo &> /dev/null; then
    sudo chown -R ubuntu /home/ubuntu
fi

BASE_PATH=/home/ubuntu/persistent
PYTHON_VERSION=3.7

# Change perms on persistent folder
mkdir -p $BASE_PATH
chmod -R 777 $BASE_PATH || echo "Warning: Could not chmod $BASE_PATH"

# Install Miniconda
mkdir -p $BASE_PATH/miniconda3
wget https://repo.anaconda.com/miniconda/Miniconda3-latest-Linux-x86_64.sh -O $BASE_PATH/miniconda3/miniconda.sh
bash $BASE_PATH/miniconda3/miniconda.sh -b -u -p $BASE_PATH/miniconda3
rm -rf $BASE_PATH/miniconda3/miniconda.sh

# Initialize conda
$BASE_PATH/miniconda3/bin/conda init bash
$BASE_PATH/miniconda3/bin/conda init zsh

# Actiavte conda (for the current session if sourced, though we use explicit paths below)
if [ -f ~/.bashrc ]; then . ~/.bashrc; fi
if [ -f ~/.zshrc ]; then . ~/.zshrc; fi

# Create conda environment for CARLA
# Using Python 3.7 as it is robustly supported by CARLA 0.9.15
$BASE_PATH/miniconda3/bin/conda create -n carla python=$PYTHON_VERSION -y

# Define explicit paths to the conda environment executables
CONDA_PYTHON="$BASE_PATH/miniconda3/envs/carla/bin/python"
CONDA_PIP="$BASE_PATH/miniconda3/envs/carla/bin/pip"

# Download and extract CARLA
mkdir -p $BASE_PATH/CARLA_LATEST
echo "Downloading CARLA to $BASE_PATH..."
wget https://carla-releases.s3.us-east-005.backblazeb2.com/Linux/CARLA_0.9.15.tar.gz -P $BASE_PATH
echo "Extracting Carla to $BASE_PATH/CARLA_LATEST/"
tar -xvf $BASE_PATH/CARLA_0.9.15.tar.gz -C $BASE_PATH/CARLA_LATEST > /dev/null
rm $BASE_PATH/CARLA_0.9.15.tar.gz

# Install Python CARLA Library
# We install the wheel/egg included in the distribution instead of the PyPI package to ensure compatibility
echo "Installing CARLA Python API..."
CARLA_DIST="$BASE_PATH/CARLA_LATEST/PythonAPI/carla/dist"
# Find the wheel or egg for Python 3.7
CARLA_PKG=$(find "$CARLA_DIST" -name "*cp37*.whl" -o -name "*py3.7*.egg" | head -n 1)

if [ -n "$CARLA_PKG" ]; then
    echo "Found CARLA package: $CARLA_PKG"
    $CONDA_PIP install "$CARLA_PKG"
else
    echo "Error: Could not find CARLA Python API package for Python $PYTHON_VERSION in $CARLA_DIST"
    echo "Available files:"
    ls "$CARLA_DIST"
fi

# Navigate to PythonAPI/examples directory
cd $BASE_PATH/CARLA_LATEST/PythonAPI/examples || exit

# Install python requirements using the environment's pip
echo "Installing requirements..."
$CONDA_PIP install -r requirements.txt

# Finished!
echo "------------------------------------------------------------"
echo "Installation complete! Please close and re-open your console"
echo "Remember to activate your conda carla environment using 'conda activate carla' every time you reopen a new console tab"
