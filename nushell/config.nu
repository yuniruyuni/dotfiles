# ------------------------- basic options
$env.config.show_banner = false
$env.config.edit_mode = "vi"
$env.config.shell_integration = {
  osc2: true
  osc7: true
  osc8: true
  osc9_9: true
  osc133: false # to preserve shell integration error for WezTerm
  osc633: true
  reset_application_mode: true
}

# ------------------------- variables

$env.EDITOR = "code --wait"
$env.BAT_THEME = "OneHalfLight"
$env.GOPATH = $nu.home-dir
$env.PIPENV_VENV_IN_PROJECT = "true"

# ------------------------- PATH
use std/util "path add"
path add ($nu.home-dir | path join ".cargo" "bin")
path add ($nu.home-dir | path join "dotfiles" "bin")
path add ($nu.home-dir | path join ".local" "bin")

# mise shims
if ($nu.home-dir | path join ".local" "share" "mise" "shims" | path exists) {
    path add ($nu.home-dir | path join ".local" "share" "mise" "shims")
}

# ------------------------- alias
alias xa = eza -lha --git --sort type
alias dkc = docker-compose
alias yolo = claude --dangerously-skip-permissions

# ------------------------- functions

# Navigate to a ghq-managed repo using fzf
def --env cdg [] {
    let repo = (
        ghq list --full-path
        | fzf
        | decode utf-8
        | str trim
    )
    if ($repo | is-not-empty) {
        cd $repo
    }
}

# ------------------------- keybindings

$env.config.keybindings ++= [
    # Ctrl+P: move up in menu or history
    {
        name: ctrl_p_up
        modifier: control
        keycode: char_p
        mode: [emacs, vi_insert]
        event: {
            until: [
                { send: menuup }
                { send: up }
            ]
        }
    }
    # Ctrl+N: move down in menu or history
    {
        name: ctrl_n_down
        modifier: control
        keycode: char_n
        mode: [emacs, vi_insert]
        event: {
            until: [
                { send: menudown }
                { send: down }
            ]
        }
    }
    # Ctrl+G: ghq + fzf repo navigation
    {
        name: cdg
        modifier: control
        keycode: char_g
        mode: [emacs, vi_insert, vi_normal]
        event: {
            send: executehostcommand
            cmd: "cdg"
        }
    }
]

# ------------------------- mise
mkdir ($nu.data-dir | path join "vendor" "autoload")
^mise activate nu | save -f ($nu.data-dir | path join "vendor" "autoload" "mise.nu")

# ------------------------- oh-my-posh
oh-my-posh init nu --config ($nu.home-dir | path join "dotfiles" "oh-my-posh.json")
