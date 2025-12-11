#!/usr/bin/env bash

DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

source "$DIR/scripts.sh"

echo "[b] checking for stow."
echo
if pacman -Qi stow > /dev/null 2>&1; then
  echo "[b] stow is already installed."
  echo
else
  logless yay -S --noconfirm --needed stow
  echo "[b] installed stow."
  echo
fi

if [ ! -d "$HOME/dotfiles" ]; then
  echo "[b] cloning dotfiles repo."
  echo
  logless git clone --depth 1 https://github.com/daym0ns/dotfiles ~/dotfiles
else
  echo "[b] dotfiles repo already present."
  echo
fi

echo "[b] installing dotfiles via stow."
echo
cd ~/dotfiles
stow *
echo "[b] dotfiles installed."
echo
