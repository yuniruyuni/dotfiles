#! /bin/bash

# ------------------------- collect variables
SETTINGS_ROOT=$(cd $(dirname $0); pwd)

read -p "input your name: " NAME
NAME=${NAME:-yuniruyuni}

read -p "input your email: " EMAIL
EMAIL=${EMAIL:-yuniruyuni@gmail.com}

read -p "install languages? (y/N): " yn
case "$yn" in
  [yY]*) INSTALL_LANGUAGES=true ;;
  *) INSTALL_LANGUAGES=false ;;
esac

# ------------------------- setup functions

# create if not file exists
# otherwise, don't touch.
function create_if_missing () {
  [[ -e "$1" ]] || cat - > "$1"
}

# ------------------------- install asdf
if "${INSTALL_LANGUAGES}"; then
  source install_asdf.sh
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
