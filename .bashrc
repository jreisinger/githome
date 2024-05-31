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

function _prependToPATH {
    local dir=$1
    if [[ -d "$dir" ]]; then
        PATH="$dir:$PATH"
    fi
}

# LIFO order, i.e. last to first.
_prependToPATH "/usr/local/go/bin"
_prependToPATH "$HOME/bin"
_prependToPATH "$HOME/go/bin"
_prependToPATH "${KREW_ROOT:-$HOME/.krew}/bin"  # package manager for kubectl plugins
_prependToPATH "$HOME/Library/Python/3.11/bin"  # pip3 installed (Mac)
_prependToPATH "$HOME/.rd/bin"                  # rancher desktop
_prependToPATH "$HOME/.local/bin"               # fabric
# Use GNU instead of BSD tools (Mac; brew install coreutils). Must be first.
_prependToPATH "/opt/homebrew/opt/coreutils/libexec/gnubin"

# dedup PATH
# PATH="$(perl -e 'print join(":", grep { not $seen{$_}++ } split(/:/, $ENV{PATH}))')"

export PATH

###############
# Completions #
###############

# SSH hostnames completion (based on ~/.ssh/config)
if [[ -r ~/.ssh_bash_completion ]]; then
    source ~/.ssh_bash_completion
fi

# Git, prerequisite: curl https://raw.githubusercontent.com/git/git/master/contrib/completion/git-completion.bash -o ~/.git-completion.bash
if [[ -r ~/.git-completion.bash ]]; then
    source ~/.git-completion.bash
fi

# Bash on Linux
if [[ -r /usr/share/bash-completion/bash_completion ]]; then
    source /usr/share/bash-completion/bash_completion
fi

# Bash on Mac, prerequisite: brew install bash-completion@2
if [[ -r /opt/homebrew/etc/profile.d/bash_completion.sh ]]; then 
    source /opt/homebrew/etc/profile.d/bash_completion.sh
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

    alias bb='kubectl run busybox --image=busybox --rm -it --restart=Never --command -- '
fi

if which kubectx > /dev/null 2>&1; then
    alias kx=kubectx
fi

######################
# Productivity tools #
######################

# Set up fzf key bindings (Ctrl-R) and fuzzy completion
eval "$(fzf --bash)"

function docs {
    local doc mdsrv_pid
    doc="$(find ~/github.com/jreisinger/docs -type f -not -path '*.git*' | fzf)"
    mdsrv "$doc" &
    mdsrv_pid=$!
    open http://localhost:8000/"$(echo -n "$doc" | sed 's/md$/html/')"
    cd "$(dirname "$doc")" || exit 1
    vi "$(basename "$doc")"
    kill $mdsrv_pid
}

# Select from multiple AWS profiles.
function ap {
    AWS_PROFILE=$(aws configure list-profiles | fzf)
    export AWS_PROFILE
}

# Select from multiple k8s cluster configurations.
function kc {
    local k8s_config
    k8s_config=$(find "$HOME"/.kube -type f -not -path "$HOME/.kube/old/*" \( -iname '*.yaml' -o -iname '*.yml' -o -iname '*.conf' -o -iname '*.kube' -o -iname 'config' \) | fzf)
    export KUBECONFIG="$k8s_config"
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
    # myquote
    curl https://raw.githubusercontent.com/jreisinger/quotes/master/quotes.txt --silent | grep -v '^$' | shuf -n 1
    #goal
fi

# Fancy PS1 prompt.
eval "$(starship init bash)"
if [ -f "$HOME/.config/fabric/fabric-bootstrap.inc" ]; then
    . "$HOME/.config/fabric/fabric-bootstrap.inc"
fi

# nvm (manage node versions) stuff
export NVM_DIR="$HOME/.nvm"
[ -s "/opt/homebrew/opt/nvm/nvm.sh" ] && \. "/opt/homebrew/opt/nvm/nvm.sh"  # This loads nvm
[ -s "/opt/homebrew/opt/nvm/etc/bash_completion.d/nvm" ] && \. "/opt/homebrew/opt/nvm/etc/bash_completion.d/nvm"  # This loads nvm bash_completion
if [ -f "/Users/jozef.reisinger/.config/fabric/fabric-bootstrap.inc" ]; then . "/Users/jozef.reisinger/.config/fabric/fabric-bootstrap.inc"; fi