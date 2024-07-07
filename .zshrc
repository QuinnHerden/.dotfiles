####################
# ZSH
#
## Theme
ZSH_THEME="nicoulaj"
## Command auto-correction
ENABLE_CORRECTION="false"
## Completions
HYPHEN_INSENSITIVE="true"
## Vim Bindings
bindkey -v
## Plugins
plugins=(
    zsh-autosuggestions
)
## Command execution time stamp 
HIST_STAMPS="yyyy/mm/dd"
## Updates
zstyle ':omz:update' mode auto
## Source
export ZSH="$HOME/.oh-my-zsh"
source $ZSH/oh-my-zsh.sh

###############
# Aliases
#
## Tmux
alias tmn='tmux new -s'
alias tma='tmux attach-session -t'
## Vim
alias vi='nvim'
alias vim='nvim'
## Git
alias gs='git status'
alias gd='git diff'
## Kubectl
alias kl='kubectl'
## Python
alias python='python3'
alias pip='pip3'
## Terraform
alias tf='terraform'
## Tailscale
alias ts='tailscale'
alias tshr='ts switch herden.io; tailscale set --accept-routes=true;'
alias tssc='ts switch sculpted.io; tailscale set --accept-routes=true;'

###############
# Editor
#
if [[ -n $SSH_CONNECTION ]]; then
  export EDITOR='vim'
else
  export EDITOR='nvim'
fi

###############
# Path
# 
## Binaries
### Local
export PATH=$PATH:$HOME/bin:/usr/local/bin
### Pipx
export PATH="$PATH:$HOME/.local/bin"

###############
# OS Environments
#
if [[ "$OSTYPE" == "darwin"* ]]; then
elif [[ "$OSTYPE" == "linux-gnu"* ]]; then
fi
###############
# Display
#
figlet -d ~/figlet-fonts -f "sub-zero" QSH
#figlet -d ~/figlet-fonts -f "Alpha" QSH
#figlet -d ~/figlet-fonts -f "Lean" QSH
###############
