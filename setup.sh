#! /bin/bash

# ------------------------- collect variables
SETTINGS_ROOT=$(cd $(dirname $0); pwd)

read -p "input your name: " NAME
NAME=${NAME:-yuniruyuni}

read -p "input your email: " EMAIL
EMAIL=${EMAIL:-your-email@example.com}

read -p "install mise? (y/N): " yn
case "$yn" in
  [yY]*) INSTALL_MISE=true ;;
  *) INSTALL_MISE=false ;;
esac

# ------------------------- setup functions

# create if not file exists
# otherwise, don't touch.
function create_if_missing () {
  [[ -e "$1" ]] || cat - > "$1"
}

# create (or refresh) a symlink at $2 pointing to $1.
# if $2 is an existing real file, back it up to $2.pre-dotfiles first.
function link_to_repo () {
  local src="$1" dst="$2"
  if [[ -e "$dst" && ! -L "$dst" ]]; then
    mv "$dst" "${dst}.pre-dotfiles"
  fi
  ln -sfn "$src" "$dst"
}

# ------------------------- prepare directory
mkdir -p ~/bin
mkdir -p ~/.config/nvim

# ------------------------- install oh-my-posh
curl -s https://ohmyposh.dev/install.sh | bash -s -- -d ~/bin

# ------------------------- install rust
curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh
rustup update
rustup component add rustfmt
rustup component add clippy
rustup component add rust-analyzer
rustup component add rust-src

# ------------------------- install mise
if "${INSTALL_MISE}"; then
  source install_mise.sh
fi

# ------------------------- output template

# ------------ .zshrc

create_if_missing "$HOME/.zshrc" << EOS
# ------------------------- variables
# profiling mode
PROFILING=false

# dotfiles directory
export SETTINGS_ROOT="${SETTINGS_ROOT}"

# ------------------------- start profiling
if \$PROFILING; then
  zmodload zsh/zprof && zprof
fi

# ------------------------- load common config
source "${SETTINGS_ROOT}/.zshrc"

# ------------------------- environment specific configs

# (you can setup environment specific configs here)

# ------------------------- end profiling
if \$PROFILING ; then
  if (which zprof > /dev/null 2>&1) ;then
    zprof
  fi
fi
EOS

# ------------ .zshenv
create_if_missing "$HOME/.zshenv" << EOS
source $SETTINGS_ROOT/.zshenv
EOS

# ------------ .gitconfig
create_if_missing "$HOME/.gitconfig" << EOS
[user]
  email = ${EMAIL}
  name = ${NAME}

[include]
  path = ${SETTINGS_ROOT}/.gitconfig
EOS

# ------------ nvim/init.lua
create_if_missing "$HOME/.config/nvim/init.lua" << EOS
dofile("${SETTINGS_ROOT}/nvim/init.lua")
EOS

# ------------ .wezterm.lua
create_if_missing "$HOME/.wezterm.lua" << EOS
dofile("${SETTINGS_ROOT}/wezterm.lua")
EOS

# ------------ ~/.config/zellij
# zellij's config has no include directive, and zellij auto-regenerates
# config.kdl atomically (which would replace a file-level symlink), so
# symlink the whole directory. zellij-generated *.bak is gitignored.
link_to_repo "${SETTINGS_ROOT}/zellij" "$HOME/.config/zellij"
