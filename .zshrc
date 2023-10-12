# Path to your oh-my-zsh installation.
export ZSH="$HOME/.oh-my-zsh"

# Path 
export PATH=$HOME/bin:/usr/local/bin:$PATH

# Set name of the theme to load 
ZSH_THEME="nicoulaj"

# Uncomment the following line to use case-sensitive completion.
# CASE_SENSITIVE="true"

# Uncomment the following line to use hyphen-insensitive completion.
# Case-sensitive completion must be off. _ and - will be interchangeable.
HYPHEN_INSENSITIVE="true"

# Uncomment one of the following lines to change the auto-update behavior
# zstyle ':omz:update' mode disabled  # disable automatic updates
# zstyle ':omz:update' mode reminder  # just remind me to update when it's time
zstyle ':omz:update' mode auto      # update automatically without asking

# Uncomment the following line if pasting URLs and other text is messed up.
# DISABLE_MAGIC_FUNCTIONS="true"

# Uncomment the following line to enable command auto-correction.
ENABLE_CORRECTION="true"

# Uncomment the following line if you want to disable marking untracked files
# under VCS as dirty. This makes repository status check for large repositories
# much, much faster.
# DISABLE_UNTRACKED_FILES_DIRTY="true"

# change the command execution time stamp shown in the history command output.
HIST_STAMPS="yyyy/mm/dd"

# Would you like to use another custom folder than $ZSH/custom?
# ZSH_CUSTOM=/path/to/new-custom-folder

# Which plugins would you like to load?
# Standard plugins can be found in $ZSH/plugins/
# Custom plugins may be added to $ZSH_CUSTOM/plugins/
# Example format: plugins=(rails git textmate ruby lighthouse)
# Add wisely, as too many plugins slow down shell startup.
plugins=(
    fasd
    poetry
    zsh-autosuggestions
)

source $ZSH/oh-my-zsh.sh

# User configuration

# export MANPATH="/usr/local/man:$MANPATH"

# You may need to manually set your language environment
# export LANG=en_US.UTF-8

# Preferred editor for local and remote sessions
# if [[ -n $SSH_CONNECTION ]]; then
#   export EDITOR='vim'
# else
#   export EDITOR='mvim'
# fi

# Compilation flags
# export ARCHFLAGS="-arch x86_64"

# Set personal aliases, overriding those provided by oh-my-zsh libs,
# plugins, and themes. Aliases can be placed here, though oh-my-zsh
# users are encouraged to define aliases within the ZSH_CUSTOM folder.
# For a full list of active aliases, run `alias`.
alias gs='git status'
alias kl='kubectl'
alias pip='pip3'
alias python='python3'
alias tas='tmux attach-session -t'
alias tf='terraform'
alias tns='tmux new -s'
alias vi='mvim -v'
alias vim='mvim -v'

# Vim Bindings
bindkey -v

# File Tree
# source /Users/quinnherden/.config/broot/launcher/bash/br

# The next line updates PATH for the Google Cloud SDK.
if [ -f '/Users/quinnherden/google-cloud-sdk/path.zsh.inc' ]; then . '/Users/quinnherden/google-cloud-sdk/path.zsh.inc'; fi

# The next line enables shell command completion for gcloud.
if [ -f '/Users/quinnherden/google-cloud-sdk/completion.zsh.inc' ]; then . '/Users/quinnherden/google-cloud-sdk/completion.zsh.inc'; fi

# Display text on terminal init
#figlet -d ~/figlet-fonts -f "sub-zero" Quinn
#figlet -d ~/figlet-fonts -f "Alpha" Q
figlet -d ~/figlet-fonts -f "Lean" QH
