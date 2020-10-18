#!/bin/bash
set -e

echo pacman
sudo pacman -Syu

echo yay
yay
# clean unneeded dependencies
yay -Yc

echo rust
rustup update
#for i in $(pip list -o | awk 'NR > 2 {print $1}'); do sudo pip install -U $i; done

echo dotfiles
cd ~/dotfiles
git pull

echo dotfiles-local
cd ~/dotfiles-local
git pull

echo rcup
rcup
