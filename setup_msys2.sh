#!/bin/bash
# MSYS2 setup script
# Run this inside MSYS2 terminal: ./setup_msys2.sh

set -e

echo "Updating MSYS2 packages..."
pacman -Syu --noconfirm

echo "Installing essential tools..."
# Note: fzf, ghq, eza etc. are managed by Zinit (installed from GitHub releases)
pacman -S --noconfirm \
  zsh \
  git \
  make \
  curl \
  wget

echo ""
echo "Setup complete!"
echo "Restart WezTerm to start using zsh."
