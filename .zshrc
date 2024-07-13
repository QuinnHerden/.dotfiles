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

###############
# Environments
#
## General
export LC_TIME=C
export LANG=en_US.UTF-8
## OS-Specific
if [[ "$OSTYPE" == "darwin"* ]]; then
elif [[ "$OSTYPE" == "linux-gnu"* ]]; then
fi
## SSH-Dependent
if [[ -n $SSH_CONNECTION ]]; then
  export EDITOR='vim'
else
  export EDITOR='nvim'
fi
###############

###############
# Path
# 
## Binaries
### Home Bin
PATH=$PATH:$HOME/bin
### Home Local Bin
export PATH=$PATH:$HOME/.local/bin
### Home Local Bin Scripts
export PATH=$PATH:$HOME/.local/bin/scripts
### User Local Bin
export PATH=$PATH:/usr/local/bin
###############

###############
# Aliases
#
## Tmux
alias tmns='tmux new -s'
alias tmls='tmux list-session'
alias tmas='tmux attach-session -t'
alias tmrs='tmux rename-session -t'
alias tmks='tmux kill-session -t'
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

###############
# Evals
## Zoxide
eval "$(zoxide init --cmd cd zsh)"
## TheFuck
eval $(thefuck --alias f)
###############

###############
# Display
figlet -d ~/figlet-fonts -f "sub-zero" QSH
#figlet -d ~/figlet-fonts -f "Alpha" QSH
#figlet -d ~/figlet-fonts -f "Lean" QSH
###############
