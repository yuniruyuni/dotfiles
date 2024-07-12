#! /bin/zsh

# ------------------------- collect variables
SETTINGS_ROOT=$(cd $(dirname $0); pwd)

read -p "input your name: " NAME
NAME=${NAME:-yuniruyuni}

read -p "input your email: " EMAIL
EMAIL=${EMAIL:-yuniruyuni@gmail.com}

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

# ------------------------- prepare directory
mkdir -p ~/bin

# ------------------------- install oh-my-posh
curl -s https://ohmyposh.dev/install.sh | bash -s -- -d ~/bin

# ------------------------- install rust
curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh
rustup update
rustup component add rustfmt
rustup component add clippy
rustup component add rls rust-analysis rust-src

# ------------------------- install asdf
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
