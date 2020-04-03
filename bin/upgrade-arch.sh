#!/bin/bash
set -e

sudo pacman -Syu
yay
# clean unneeded dependencies
yay -Yc

rustup update
#for i in $(pip list -o | awk 'NR > 2 {print $1}'); do sudo pip install -U $i; done

cd ~/dotfiles
git pull

cd ~/dotfiles-local
git pull

rcup
