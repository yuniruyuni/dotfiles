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

# ------------------------- fzf
export FZF_DEFAULT_OPTS='--height 40% --reverse --border'
export FZF_DEFAULT_COMMAND='fd --type f --hidden --follow --exclude .git'

# ----------- path (OS-specific)
case ${OSTYPE} in
  darwin*)
    export PATH="$HOME/.cargo/bin:/usr/local/opt/llvm/bin:${HOME}/bin:${HOME}/.local/bin:/usr/local/bin:${HOME}/dotfiles/bin:${PATH}"
    ;;
  msys*)
    # MSYS2: Include Windows-side tools (cargo, oh-my-posh, etc.)
    export PATH="$HOME/.cargo/bin:${HOME}/bin:${HOME}/.local/bin:${HOME}/dotfiles/bin:/c/Users/$USER/AppData/Local/Programs/oh-my-posh/bin:/c/Users/$USER/.cargo/bin:${PATH}"
    ;;
  *)
    export PATH="$HOME/.cargo/bin:${HOME}/bin:${HOME}/.local/bin:${HOME}/dotfiles/bin:${PATH}"
    ;;
esac

# ------------------------- zinit

zinit ice wait"0" lucid; zinit light mollifier/anyframe

zinit ice wait"0" lucid as"program" from"gh-r"; zinit light junegunn/fzf
zinit ice wait"0" lucid as"program" from"gh-r" pick"*/ghq"; zinit light x-motemen/ghq

zinit ice wait"0" lucid atload"_zsh_autosuggest_start"
zinit light zsh-users/zsh-autosuggestions

zinit ice pick'git-escape-magic'
zinit light knu/zsh-git-escape-magic

zinit ice wait"0" lucid
zinit light zsh-users/zsh-syntax-highlighting

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

# ------------------------- functions (OS-specific)
case ${OSTYPE} in
  darwin*)
    google() { open -a "Google Chrome" "https://www.google.com/search?q=$*"; }
    ;;
  msys*)
    google() { start "https://www.google.com/search?q=$*"; }
    ;;
esac

# ------------------------- events

# ------------------------- alias
alias dkc=docker-compose
alias vtuber="task list --label=VTuber"
alias doing="task doing"
alias closed="task closed"
alias xa="eza -lha --git --sort type"

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

# ------------------------- load mise (OS-specific)
case ${OSTYPE} in
  darwin*|linux*)
    if [ -f $HOME/.local/bin/mise ]; then
      eval "$($HOME/.local/bin/mise activate zsh)"
      eval "$($HOME/.local/bin/mise activate --shims)"
    fi
    ;;
  msys*)
    # Windows: mise installed via winget
    if command -v mise &> /dev/null; then
      eval "$(mise activate zsh)"
    fi
    ;;
esac

# ----------- prompt setting (OS-specific)
POSH_CONFIG="$HOME/dotfiles/oh-my-posh.json"
case ${OSTYPE} in
  darwin*)
    eval "$(oh-my-posh init zsh --config $POSH_CONFIG)"
    ;;
  msys*)
    # Windows: use oh-my-posh installed via winget (Windows path required)
    eval "$(/c/Users/$USER/AppData/Local/Programs/oh-my-posh/bin/oh-my-posh.exe init zsh --config /c/Users/$USER/dotfiles/oh-my-posh.json)"
    ;;
  *)
    if command -v oh-my-posh &> /dev/null; then
      eval "$(oh-my-posh init zsh --config $POSH_CONFIG)"
    fi
    ;;
esac

# ------------------------- load local config
# Host-specific settings can be placed in ~/.zshrc_local
if [ -f ~/.zshrc_local ]; then
  source ~/.zshrc_local
fi