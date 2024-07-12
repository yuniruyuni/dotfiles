#!/bin/zsh

export TMPDIR="$HOME/.tmp"
mkdir -p $TMPDIR

curl https://mise.jdx.dev/install.sh | sh

eval "$($HOME/.local/bin/mise activate zsh)"
eval "$($HOME/.local/bin/mise activate --shims)"

# ------------------------- install python
mise install python@2
mise global python@2

mise install python@3
mise global python@3

pip install --user pipenv

# install poetry (package bundler)
curl -sSL https://raw.githubusercontent.com/python-poetry/poetry/master/get-poetry.py | python

# ------------------------- install nodejs
mise install nodejs@lts
mise global nodejs@lts

# ------------------------- install bun
mise install bun@latest
mise global bun@latest
bun completions
bun install -g typescript
bun install -g typescript-language-server
bun install -g dockerfile-language-server-nodejs
bun install -g vim-language-server
bun install -g vscode-json-languageserver

# ------------------------- install golang
mise install go@latest
mise global go@latest

# ------------------------- install jq
mise install jq@latest
mise global jq@latest