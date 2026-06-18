#!/bin/bash
set -e # Exit immediately if any command fails

# Download stable release
curl -LO https://github.com/neovim/neovim/releases/download/stable/nvim-linux-x86_64.tar.gz

# Remove old folder if it exists
sudo rm -rf /opt/nvim-linux-x86_64

# Extract (This creates /opt/nvim-linux-x86_64/)
sudo tar -C /opt -xzf nvim-linux-x86_64.tar.gz

# Corrected symlink to account for the internal archive folder structure
sudo ln -sf /opt/nvim-linux-x86_64/bin/nvim /usr/local/bin/nvim

# Clean up archive
rm nvim-linux-x86_64.tar.gz

# Verify installation
nvim --version
