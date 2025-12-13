#!/bin/bash

set -e

# Check if TPM is already installed
if [ -d "$HOME/.tmux/plugins/tpm" ]; then
  echo "TPM is already installed in ~/.tmux/plugins/tpm"
else
  echo "Installing Tmux Plugin Manager (TPM)..."
  git clone https://github.com/tmux-plugins/tpm ~/.tmux/plugins/tpm
fi

echo "TPM installed successfully!"

exit 0
