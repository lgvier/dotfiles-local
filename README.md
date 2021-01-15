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

## Step 4:
Install hammerspoon:
```
brew install hammerspoon
# download latest release from https://github.com/asmagill/hs._asm.undocumented.spaces
cd ~/.hammerspoon
tar -xzf ~/Downloads/spaces-v<Tab>
```

## Step 4:
Random apps
```
brew install iterm2
brew install tmux
brew install thefuck
brew install kubectl
brew install tree

mkdir ~git
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
# set bitbar plugins location to ~/dotfiles-local/bitbar
```

## Sane mac os defaults (optional)
```
git clone https://github.com/kevinSuttle/macOS-Defaults.git ~/git/macOS-Defaults
cd ~/git/macOS-Defaults
./.macos
```


All set!
To update local configs: `rcup`

