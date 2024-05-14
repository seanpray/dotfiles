# If you come from bash you might have to change your $PATH.
if [[ $ZSH_PROFILE ]]; then
     zmodload zsh/zprof
fi
# export PATH=$HOME/bin:/usr/local/bin:$PATH

# Path to your oh-my-zsh installation.
#export ZSH="$HOME/.config/.oh-my-zsh"

CURRENT_PATH=$PWD

# Set name of the theme to load --- if set to "random", it will
# load a random theme each time oh-my-zsh is loaded, in which case,
# to know which specific one was loaded, run: echo $RANDOM_THEME
# See https://github.com/ohmyzsh/ohmyzsh/wiki/Themes
#ZSH_THEME="lambda-gitster"

# Set list of themes to pick from when loading at random
# Setting this variable when ZSH_THEME=random will cause zsh to load
# a theme from this variable instead of looking in $ZSH/themes/
# If set to an empty array, this variable will have no effect.
# ZSH_THEME_RANDOM_CANDIDATES=( "robbyrussell" "agnoster" )

# Uncomment the following line to use case-sensitive completion.
# CASE_SENSITIVE="true"

# Uncomment the following line to use hyphen-insensitive completion.
# Case-sensitive completion must be off. _ and - will be interchangeable.
HYPHEN_INSENSITIVE="true"

# Uncomment one of the following lines to change the auto-update behavior
zstyle ':omz:update' mode disabled  # disable automatic updates
# zstyle ':omz:update' mode auto      # update automatically without asking
# zstyle ':omz:update' mode reminder  # just remind me to update when it's time

# Uncomment the following line to change how often to auto-update (in days).
# zstyle ':omz:update' frequency 13

# Uncomment the following line if pasting URLs and other text is messed up.
# DISABLE_MAGIC_FUNCTIONS="true"

# Uncomment the following line to disable colors in ls.
DISABLE_LS_COLORS="false"

# Uncomment the following line to disable auto-setting terminal title.
# DISABLE_AUTO_TITLE="true"

# Uncomment the following line to enable command auto-correction.
ENABLE_CORRECTION="true"

# Uncomment the following line to display red dots whilst waiting for completion.
# You can also set it to another string to have that shown instead of the default red dots.
# e.g. COMPLETION_WAITING_DOTS="%F{yellow}waiting...%f"
# Caution: this setting can cause issues with multiline prompts in zsh < 5.7.1 (see #5765)
COMPLETION_WAITING_DOTS="true"

# Uncomment the following line if you want to disable marking untracked files
# under VCS as dirty. This makes repository status check for large repositories
# much, much faster.
DISABLE_UNTRACKED_FILES_DIRTY="true"

# Uncomment the following line if you want to change the command execution time
# stamp shown in the history command output.
# You can set one of the optional three formats:
# "mm/dd/yyyy"|"dd.mm.yyyy"|"yyyy-mm-dd"
# or set a custom format using the strftime function format specifications,
# see 'man strftime' for details.
# HIST_STAMPS="mm/dd/yyyy"

# Would you like to use another custom folder than $ZSH/custom?
# ZSH_CUSTOM=/path/to/new-custom-folder

# Which plugins would you like to load?
# Standard plugins can be found in $ZSH/plugins/
# Custom plugins may be added to $ZSH_CUSTOM/plugins/
# Example format: plugins=(rails git textmate ruby lighthouse)
# Add wisely, as too many plugins slow down shell startup.
# plugins=(
# 	gitfast
# 	ripgrep
# 	zsh-navigation-tools
# 	yarn
# 	colored-man-pages
# 	npm
# 	fd
# 	pip
# 	jump
# 	you-should-use
# 	dotenv
# )
#
# source $ZSH/oh-my-zsh.sh

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
#
# Example aliases
# alias zshconfig="mate ~/.zshrc"
# alias ohmyzsh="mate ~/.oh-my-zsh"
if [[ ! -d ~/.config/zsh-autopair ]]; then
     git clone https://github.com/hlissner/zsh-autopair ~/.config/zsh-autopair
fi

setopt autocd
stty stop undef
setopt interactive_comments

# History in cache directory:
HISTSIZE=30000
SAVEHIST=30000
HISTFILE=~/.cache/zsh/history

export PATH=$PATH:/home/sean/.config/scripts/

# move coredumps
#export ZSH_COMPDUMP=$ZSH/cache/.zcompdump-$HOST
# compinit -d ~/.cache/zsh/zcompdump-$HOST
setopt autocd
source ~/.config/zsh-autopair/autopair.zsh
autopair-init
export COLORTERM=truecolor

# ZSH_AUTOSUGGEST_HIGHLIGHT_STYLE="fg=#c6d6f7,bold"
# bindkey '^k' autosuggest-accept
# bindkey '^ ' autosuggest-execute
# bindkey '^b' autosuggest-clear

### ctrl+arrows
bindkey "\e[1;5C" forward-word
bindkey "\e[1;5D" backward-word
# urxvt
bindkey "\eOc" forward-word
bindkey "\eOd" backward-word

### ctrl+delete
bindkey "\e[3;5~" kill-word
# urxvt
bindkey "\e[3^" kill-word

### ctrl+backspace
bindkey '^H' backward-kill-word

### ctrl+shift+delete
bindkey "\e[3;6~" kill-line
# urxvt
bindkey "\e[3@" kill-line


source ~/.config/.cargo/env

# git clone https://github.com/zsh-users/zsh-autosuggestions ~/.config/zsh-autosuggestions
# source ~/.config/zsh-autosuggestions/zsh-autosuggestions.zsh

# git clone https://github.com/zsh-users/zsh-syntax-highlighting.git ~/.config/zsh-syntax-highlighting
# echo "source ${(q-)PWD}/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh" >> ${ZDOTDIR:-$HOME}/.zshrc
source ~/.config/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh

source ~/.config/alias_all

PS1='%F{blue}%1~ %F{white}ς '

# set PWD to current file
cd $CURRENT_PATH

# bun completions
#[ -s "/home/sean/.bun/_bun" ] && source "/home/sean/.bun/_bun"

[ -f "/home/sean/.ghcup/env" ] && . "/home/sean/.ghcup/env" # ghcup-env

export PATH="$PATH:/home/sean/.local/bin"
export PYENV_ROOT="${HOME}/.config/pyenv"
export PATH="${PYENV_ROOT}/bin:${PATH}"
[[ -d $PYENV_ROOT/bin ]] && export PATH="$PYENV_ROOT/bin:$PATH"
eval "$(pyenv init -)"
if [[ $ZSH_PROFILE ]]; then
     zprof
fi

