# shellcheck shell=bash
# Non-login, i.e. run on every instance. Place for aliases and functions.

# Creating a symlink between ~/.bashrc and ~/.bash_profile will ensure that the
# same startup scripts run for both login and non-login sessions. Debian's
# ~/.profile sources ~/.bashrc, which has a similar effect.

###########
# MacBook #
###########

if [[ $(uname -s) == "Darwin" ]]; then
    # Stop saying that zsh is the new default.
    export BASH_SILENCE_DEPRECATION_WARNING=1

    # So Python can find CA certificates.
    ALL_CA_CERTIFICATES="/usr/local/share/ca-certificates/cacert.pem"
    if [[ -f "$ALL_CA_CERTIFICATES" ]]; then
        export REQUESTS_CA_BUNDLE=$ALL_CA_CERTIFICATES
    fi

    # So gpg is working.
    GPG_TTY=$(tty)
    export GPG_TTY

    # So brew is working.
    eval "$(/opt/homebrew/bin/brew shellenv)"
fi

###########
# History #
###########

# so history gets saved on Mac
export SHELL_SESSION_HISTORY=0

export HISTSIZE=999999
export HISTFILESIZE=999999

# don't store lines starting with space and
# duplicate lines (successive and anywhere)
export HISTCONTROL=ignorespace:ignoredups:erasedups

########
# PATH #
########

# Use GNU instead of BSD tools (Mac; brew install coreutils). Must be first.
if [[ -d /opt/homebrew/opt/coreutils/libexec/gnubin ]]; then
        PATH="/opt/homebrew/opt/coreutils/libexec/gnubin:$PATH"
fi

function _addToPath {
    local dir=$1
    if [[ -d "$dir" ]]; then
        PATH="$PATH:$dir"
    fi
}

_addToPath "$HOME/bin"
_addToPath "$HOME/go/bin"
_addToPath "$HOME/Google Drive/My Drive/bin" # emp
_addToPath "$HOME/.krew/bin"
_addToPath "$HOME/Library/Python/3.11/bin" # pip3 installed (Mac)
_addToPath "$HOME/.rd/bin" # rancher desktop

# dedup PATH
# PATH="$(perl -e 'print join(":", grep { not $seen{$_}++ } split(/:/, $ENV{PATH}))')"

export PATH

###############
# Completions #
###############

# SSH hostnames completion (based on ~/.ssh/config)
if [ -e ~/.ssh_bash_completion ]; then
    source ~/.ssh_bash_completion
fi

# Linux
if [[ -r '/usr/share/bash-completion/bash_completion' ]]; then
    source '/usr/share/bash-completion/bash_completion'
fi

# Mac (prerequisite: brew install bash-completion@2)
if [[ -r "/opt/homebrew/etc/profile.d/bash_completion.sh" ]]; then 
    source "/opt/homebrew/etc/profile.d/bash_completion.sh"
fi

###########
# Aliases #
###########

if [[ -r ~/.work-aliases ]]; then
    source ~/.work-aliases
fi

alias githome='git --work-tree=$HOME --git-dir=$HOME/github.com/jreisinger/githome'

alias ls='ls --color=auto --group-directories-first'

alias grep='grep --color=auto'
alias fgrep='fgrep --color=auto'
alias egrep='egrep --color=auto'

alias rm='rm -i'
alias cp='cp -i'
alias mv='mv -i'

alias vi='vim'

alias k9s='k9s --readonly'

if which kubectl > /dev/null 2>&1; then
    source <(kubectl completion bash)
    alias k=kubectl
    complete -F __start_kubectl k # enable completion for k alias
fi

if which kubectx > /dev/null 2>&1; then
    alias kx=kubectx
fi

######################
# Productivity tools #
######################

# Search history. Don't run command from h just store it into history.
function h {
    local tac
    if which tac > /dev/null; then
        tac="tac"
    else
        tac="tail -r"
    fi

    local cmd
    # perl removes numbers and whitespace from the beginning of line
    # awk removes duplicate lines (even not adjacent) and keeps the original order
     cmd=$(history | $tac | perl -wpe 's/^\s*\d+\s+//' | awk '!seen[$0]++' | fzf --scheme=history)
    # add $cmd to history
    history -s "$cmd"
}

# Search names of my documents.
function docs-find {
    local pattern=$1
    find                                \
        ~/github.com/jreisinger/docs    \
        ~/docs                          \
        -not -path '*.git*'             \
        -iname "*$pattern*"             \
        | rg -i "$pattern"
}

# Search contents of my documents.
function docs-grep {
    local pattern=$1
    find                                \
        ~/github.com/jreisinger/docs    \
        ~/docs                          \
        -not -path '*.git*'             \
        -type f -print0                 \
        | xargs -0 rg -i "$pattern"
}

#########
# Other #
#########

# fix locale issue when scp-ing to a server
export LC_ALL=en_US.UTF-8

# to get "new mail" notification in terminal
export MAIL="/var/mail/$USER"

# print one of my favorite quotes when bash is interactive and only 1 out of 10 times
# if [[ $- == *i* ]] && [[ "$RANDOM" -lt 3277 ]]; then
# 	myquote
# fi

# print one of my favorite quotes when bash is interactive and it's morning
if  [[ $- == *i* ]] && [[ "$(TZ=CET date +%k)" -lt 10 ]]; then
    myquote
    #goal
fi

# Fancy PS1 prompt.
eval "$(starship init bash)"
