# dotfiles-local

## Step 1:
Clone this repo
`git clone https://github.com/lgvier/dotfiles-local.git ~/dotfiles-local`

## Step 2:
Install https://github.com/thoughtbot/dotfiles

## Step 3:
Install TPM:
```
git clone https://github.com/tmux-plugins/tpm ~/.tmux/plugins/tpm
```

## Step 4 (optional):
Random apps
```
# brew install iterm2
# or
# brew install --cask alacritty
mkdir ~/git
git clone https://github.com/dracula/iterm.git ~/git/dracula-iterm
# activate the theme in the iterm presets
brew install tmux
brew install thefuck
brew install kubectl
brew install tree
brew install watch
brew install --cask spotify
brew install --cask deluge
brew install --cask beardedspice
brew install --cask mtmr
brew install --cask vlc
brew install --cask private-internet-access
brew install --cask the-unarchiver
brew install --cask cyberduck
# brew install --cask trilium-notes
rm "$HOME/Library/Application Support/MTMR/items.json" && ln -s $HOME/.mtmr/items.json "$HOME/Library/Application Support/MTMR/items.json"
brew install coconutbattery
brew install git
brew install git-gui
brew install visual-studio-code
brew install nvim
brew install eclipse-java
# rust
curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh
cargo install cargo-edit
cargo install cargo-watch`
```

## Step 5 (optional):
Install hammerspoon:
```
brew install hammerspoon
# download latest release from https://github.com/asmagill/hs._asm.undocumented.spaces
cd ~/.hammerspoon
tar -xzf ~/Downloads/spaces-v<Tab>
```

## Step 6 (optional):
Install yabai
```
mkdir ~/git
git clone https://github.com/koekeishiya/limelight.git ~/git/limelight
cd ~/git/limelight
make
ln -s $HOME/git/limelight/bin/limelight /usr/local/bin/limelight

brew install jq
brew install koekeishiya/formulae/yabai
brew install koekeishiya/formulae/skhd
brew services start yabai
brew services start skhd
brew install bitbar
# Manual steps:
# 1. set bitbar plugins location to ~/dotfiles-local/bitbar
# 2. in Preferences > Acessibility > Display, check Reduce motion
```
Limelight patch not to draw on maximized windows:
https://github.com/koekeishiya/limelight/issues/18

## Step 7 (optional):
Sane mac os defaults
```
git clone https://github.com/kevinSuttle/macOS-Defaults.git ~/git/macOS-Defaults
cd ~/git/macOS-Defaults
./.macos
# Customize some of the settings
defaults write NSGlobalDomain KeyRepeat -int 2
defaults write NSGlobalDomain InitialKeyRepeat -int 35
defaults write com.apple.screencapture location -string "${HOME}/Screenshots"
defaults write NSGlobalDomain AppleLanguages -array "en" "us"
defaults write NSGlobalDomain AppleLocale -string "en_US@currency=USD"
sudo systemsetup -settimezone "America/New_York" > /dev/null
# reboot
```
Dont connect bluetooth audio devices automatically:
https://apple.stackexchange.com/a/380909


All set!
To update local configs: `rcup`

