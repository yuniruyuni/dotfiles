export TMPDIR="$HOME/.tmp"
mkdir -p $TMPDIR

[[ -s ~/.asdfrc ]] || ln -s ~/.asdfrc .asdfrc
[[ -d ~/.asdf ]] || git clone https://github.com/asdf-vm/asdf.git ~/.asdf
(
  cd ~/.asdf
  git checkout "$(git describe --abbrev=0 --tags)"
)

. $HOME/.asdf/asdf.sh
asdf plugin add ruby
asdf plugin add python
asdf plugin add nodejs

# ------------------------- install ruby
LATEST_RUBY=`asdf list all ruby | grep -v - | tail -1`
asdf install ruby $LATEST_RUBY
asdf global ruby $LATEST_RUBY
gem install bundler
gem install neovim

# ------------------------- install python
LATEST_PYTHON2=`asdf list all python | grep -e "^\s*2\.[0-9]\+\.[0-9]\+$" | tail -1`
asdf install python $LATEST_PYTHON2
asdf global python $LATEST_PYTHON2
pip install pynvim

LATEST_PYTHON=`asdf list all python | grep -e "^\s*[0-9]\+\.[0-9]\+\.[0-9]\+$" | tail -1`
asdf install python $LATEST_PYTHON
asdf global python $LATEST_PYTHON
pip install pynvim

pip install --user pipenv

# install poetry (package bundler)
curl -sSL https://raw.githubusercontent.com/python-poetry/poetry/master/get-poetry.py | python

# ------------------------- install nodejs
bash -c '${ASDF_DATA_DIR:=$HOME/.asdf}/plugins/nodejs/bin/import-release-team-keyring'
LATEST_NODEJS=`asdf list all nodejs | grep -v - | tail -1`
asdf install nodejs $LATEST_NODEJS
asdf global nodejs $LATEST_NODEJS
npm install -g typescript
npm install -g neovim
npm install -g typescript-language-server
npm install -g dockerfile-language-server-nodejs
npm install -g vim-language-server
npm install -g vscode-json-languageserver
