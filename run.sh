#!/usr/bin/env bash

DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

print_logo() {
    cat << "EOF"

    __                         
   / /_  __  _____  ____  ____  
  / __ \/ / / / _ \/ __ \/ __ \  setup
 / /_/ / /_/ /  __/ / / / /_/ /  by
/_.___/\__,_/\___/_/ /_/\____/   daym0ns
                               
EOF
}

set -e

source "$DIR/packages.conf"
source "$DIR/scripts.sh"

cd ~
clear
print_logo
echo
echo
echo
echo
echo
read -s -r -p "Press any key to continue..." -n 1
echo
echo

echo "[b] starting system setup."
echo
echo "[b] performing full system upgrade."
echo
logless sudo pacman -Syu --noconfirm


echo "[b] checking for yay."
echo
if pacman -Qi yay > /dev/null 2>&1; then
  echo "[b] yay is already installed."
  echo
else
  if [ -d "$HOME/yay" ]; then
    rm -rf yay
  fi

  logless sudo pacman -S --needed git base-devel go --noconfirm
  cd ~; logless git clone https://aur.archlinux.org/yay.git ~/yay
  cd yay
  logless makepkg -si
  cd ..
  rm -rf yay
  echo "[b] installed yay."
  echo
fi

echo "[b] installing WM dependencies."
echo
logless install_packages "${I3_PKGS[@]}"

no_dm=false
for arg in "$@"; do
    if [ "$arg" = "--no-dm" ]; then
      no_dm = true
    fi
done

if [ "$no_dm" = false ]; then
  echo "[b] installing display manager."
  logless yay -S ly --noconfirm
  logless sudo systemctl enable ly
  echo
fi

echo "[b] installing zsh dependencies."
echo
logless install_packages "${ZSH_PKGS[@]}"

# install oh-my-posh
if [ ! -f "$HOME/.local/bin/oh-my-posh" ]; then
  logless curl -s https://ohmyposh.dev/install.sh | bash -s
fi

echo "[b] installing nvim dependencies."
echo
logless install_packages "${NVIM_PKGS[@]}"

echo "[b] installing dev packages."
echo
logless install_packages "${DEV_PKGS[@]}"

echo "[b] installing dotfiles."
echo
. "$DIR/dotfiles.sh"
