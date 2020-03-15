#!/bin/bash
set -e

sudo pacman -Syu
yay

cd ~/dotfiles
git pull

cd ~/dotfiles-local
git pull

rcup
