# ------------------------- zinit modules
# auto install zinit
ZINIT_HOME="${XDG_DATA_HOME:-${HOME}/.local/share}/zinit/zinit.git"
if [[ ! -d $ZINIT_HOME  ]]; then
  mkdir -p "$(dirname $ZINIT_HOME)"
  git clone https://github.com/zdharma-continuum/zinit.git "$ZINIT_HOME"
fi

source "${ZINIT_HOME}/zinit.zsh"

# ------------------------- variables

# ----------- locale
export LANGUAGE=ja_JP.UTF-8
export LC_ALL=ja_JP.UTF-8
export LANG=ja_JP.UTF-8

# ----------- terminfo
export TERM=xterm-256color

# ----------- local
export HOME_LOCAL="${HOME}/.local/"

# ----------- man
export MANPATH="${HOME_LOCAL}/man:/usr/local/man:${MANPATH}"

# ----------- editor
export EDITOR="code --wait"

# ----------- golang
export GOPATH=$HOME

# ----------- python
export PIPENV_VENV_IN_PROJECT=true

# ------------------------- bat
export BAT_THEME="OneHalfLight"

# ----------- path
export PATH="$HOME/.cargo/bin:/usr/local/opt/llvm/bin:${HOME}/bin:${HOME}/.local/bin:/usr/local/bin:${HOME}/dotfiles/bin:${PATH}"

# ------------------------- zinit

zinit ice wait"0" lucid; zinit light mollifier/anyframe

zinit ice wait"0" lucid as"program" from"gh-r" mv"fzf-* -> fzf"; zinit light junegunn/fzf-bin
zinit ice wait"0" lucid as"program" from"gh-r" pick"*/ghq"; zinit light x-motemen/ghq
zinit ice wait"0" lucid as"program" from"gh-r" mv"jq-* -> jq"; zinit light stedolan/jq

zinit ice wait"0" lucid atload"_zsh_autosuggest_start"
zinit light zsh-users/zsh-autosuggestions

zinit ice wait"0" lucid atinit"zpcompinit; zpcdreplay"

# ------------------------- basic options
HISTFILE=~/.zsh_history
HISTSIZE=10000
SAVEHIST=10000
setopt share_history
setopt inc_append_history
setopt hist_ignore_all_dups
setopt hist_ignore_dups
setopt hist_verify
setopt hist_reduce_blanks
setopt extended_glob

# ------------------------- functions

# ------------------------- events

# ------------------------- alias
alias dkc=docker-compose
alias vtuber="task list --label=VTuber"
alias doing="task doing"
alias closed="task closed"
alias xa="exa -lha --git -s type"

# ------------------------- key binding

# ----------- viins
bindkey -v
bindkey -v '^?' backward-delete-char

# ----------- history
autoload history-search-end
zle -N history-beginning-search-backward-end history-search-end
zle -N history-beginning-search-forward-end history-search-end

bindkey "^p" history-beginning-search-backward-end
bindkey "^n" history-beginning-search-forward-end

# ----------- anyframe
bindkey '^r' anyframe-widget-cd-ghq-repository

# ----------- tmux
# iTerm integrated tmux on ssh session
function smux() {
  ssh $* -t "tmux -u -CC new -A -s smux-\${\$(hostname)//\\./-}"
}

# ------------------------- load asdf
if [ -f $HOME/.asdf/asdf.sh ]; then
  . $HOME/.asdf/asdf.sh
  # fpath=($HOME/.asdf/completions $fpath)
fi

# ----------- prompt setting
eval "$(oh-my-posh --init --shell zsh --config ~/dotfiles/oh-my-posh.json)"
