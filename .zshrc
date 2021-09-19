# ------------------------- zplugin modules
if [[ ! -d ~/.zplugin/bin/zmodules/Src  ]]; then
  module_path+=( "~/.zplugin/bin/zmodules/Src" )
  zmodload zdharma/zplugin
fi

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

# ----------- prompt setting
export PURE_POWER_MODE=modern
typeset -g POWERLEVEL9K_KUBECONTEXT_SHOW_ON_COMMAND='kubectl|helm|kubens|kubectx|oc|istioctl|kogito'

# ------------------------- bat
export BAT_THEME="OneHalfLight"

# ----------- path
export PATH="$HOME/.cargo/bin:/usr/local/opt/llvm/bin:${HOME}/bin:${HOME}/.local/bin:/usr/local/bin:${HOME}/dotfiles/bin:${PATH}"

# ------------------------- zplugin

# auto install zplugin
if [[ ! -d ~/.zplugin/bin ]]; then
  mkdir -p ~/.zplugin
  git clone https://github.com/zdharma/zplugin.git ~/.zplugin/bin
fi

declare -A ZPLGM
ZPLGM[COMPINIT_OPTS]=-C
source "$HOME/.zplugin/bin/zplugin.zsh"

# auto install zplugin module
if [[ ! -d ~/.zplugin/bin/zmodules/Src ]]; then
  zplugin module build
fi

zplugin ice depth=1; zplugin light romkatv/powerlevel10k
# zplugin snippet https://github.com/sainnhe/edge/blob/master/zsh/.zsh-pure-power-dark

zplugin ice wait"0" lucid; zplugin light mollifier/anyframe

zplugin ice wait"0" lucid as"program" from"gh-r" mv"fzf-* -> fzf"; zplugin light junegunn/fzf-bin
zplugin ice wait"0" lucid as"program" from"gh-r" pick"*/ghq"; zplugin light x-motemen/ghq
zplugin ice wait"0" lucid as"program" from"gh-r" mv"jq-* -> jq"; zplugin light stedolan/jq

zplugin ice wait"0" lucid atload"_zsh_autosuggest_start"
zplugin light zsh-users/zsh-autosuggestions

zplugin ice wait"0" lucid atinit"zpcompinit; zpcdreplay"
zplugin light zdharma/fast-syntax-highlighting

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

# ------------------------- p10k
[[ -f ${SETTINGS_ROOT}/.p10k.zsh ]] && source ${SETTINGS_ROOT}/.p10k.zsh
