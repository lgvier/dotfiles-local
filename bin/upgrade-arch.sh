#!/bin/bash
set -e

sudo pacman -Syu
yay
# clean unneeded dependencies
yay -Yc

cd ~/dotfiles
git pull

cd ~/dotfiles-local
git pull

rcup
