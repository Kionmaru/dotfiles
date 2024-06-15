# This is the file used by zsh's interactive login. Interacty stuff goes here.
#
# I would put these in zshenv, but that file is overridden by /etc/zshrc
# ....
# Always respect history && histfile.
HISTFILE=~/.histfile
HISTSIZE=500000
SAVEHIST=1000000000000000000
# append into history file; save only one command if 2 are
# common/same/consistent; add timestamps for each entry
setopt INC_APPEND_HISTORY HIST_IGNORE_DUPS EXTENDED_HISTORY

# Global setopts that we want respected even in non-login, non-interactive scripted shells.
setopt appendhistory extendedglob notify prompt_subst

zstyle ':completion:*' completer _expand _complete _ignored
zstyle ':completion:*' completions 1
zstyle ':completion:*' glob 1
zstyle ':completion:*' max-errors 2
zstyle ':completion:*' prompt 'Assuming %e errors:'
zstyle ':completion:*' substitute 1
zstyle :compinstall filename '${HOME}/.zshrc'

autoload -Uz compinit
autoload -U colors
colors
compinit

# We have to set this explicitly
bindkey '^R' history-incremental-search-backward

# ANSI escape codes for setting xterm-ish titlebars.
_thing1=$'\e]0;'
_thing2=$'\a'

# If we're root, lets be "bright" about it, ha, ha, ha.
_setspacer()
{
        case ${USER} in
                root)
                        _spacer='%{%F{red}%}#%{%f%}'
                        ;;
                *)
                        _spacer="$"
                        ;;
        esac
}

# These don't carry through su -; root will need a .zshrc as well.
# But they do carry through su now that I did it right.
autoload -Uz add-zsh-hook
add-zsh-hook precmd _setspacer


# Exported variables go here.
# export PS1="%{${_thing1}%* %n@%m: ~% ${_thing2}%}[%* %{$fg[green]%}${STY##*.}%{%b%} %n@%m:%~]%{${_spacer}%G%} "
export PS1='%{${_thing1}%* %n@%m: ~% ${_thing2}%}[%* %F{green}${STY##*.} %n@%m%f:%F{yellow}%~%f]${_spacer} '

# If we're about to run a command.... Set the title bar
preexec() { printf "${_thing1}%s${_thing2}" "${1}"; }

# Aliases in general go here.
alias ls="ls --color=auto -a"
alias config='/usr/bin/git --git-dir=$HOME/.cfg/ --work-tree=$HOME'

# general functions go here
ssm() { aws ssm start-session --target "${2}" --profile "${1}" --region us-east-1 }

killssm() { ps aux | grep ssm | grep botocore | awk '{ print $2 }' | while read pid; do kill ${pid}; done; }

# TODO: This should be a script.
oncall() {
  while true; do
    if (( $(curl --request GET \
      --url "https://api.pagerduty.com/incidents?total=true&user_ids[]=$(cat ${HOME}/.config/pd/user_id)" \
      --header 'Accept: application/json' \
      --header "Authorization: Token $(cat ${HOME}/.config/pd/token)" \
      --header 'Content-Type: application/json' -s | jq .total) != 0 ));
    then
      ffplay ${HOME}/.config/pd/"Time to Wake After Midnight.mp3" -loop 0 -nodisp;
    fi;
    echo "$(date): Checked for open incidents, found none.";
    sleep 5;
  done
}

# Just... fuck it... grab a current neovim and dump it to .local
# Should almost never need to run this; so comment it out entirely by
# default
# linux-local-stable-neovim() {
#   curl https://github.com/neovim/neovim/releases/download/stable/nvim-linux64.tar.gz -L --output - | gzip -cd - | tar xf - --strip-components=1 -C ${HOME}/.local/
# }

gopathremove() {
  # Split PATH into array of elements
  parts=(${(@s/:/)PATH})
  # Remove elements identical to parameter
  # NOTE: If it was ${~1}, it would match a pattern - wildcards possible
  parts=(${parts:#${1}/bin})
  # Re-assemble to PATH
  export PATH=${(j/:/)${parts}}
}

gover() {
  if [[ -v GOROOT ]]; then
    gopathremove "${GOROOT}"
    unset GOROOT;
  fi;

  if [[ ! -e /home/raven/sdk/go${1}/bin/go ]]; then
    go install golang.org/dl/go${1}@latest && \
    go${1} download && \
  fi;

  export GOROOT="$(go${1} env GOROOT)" && \
  export PATH="${GOROOT}/bin:${PATH}" && \
}


# >>> mamba initialize >>>
# Well, I've modified it a bit...
# !! Contents within this block are NO LONGER managed by 'mamba init' !!
if [[ "$(uname -o)" == "Darwin" ]]; then
  export MAMBA_EXE="/opt/homebrew/opt/micromamba/bin/micromamba"
else
  export MAMBA_EXE="${HOME}/.local/bin/micromamba";
fi

export MAMBA_ROOT_PREFIX="${HOME}/micromamba";
__mamba_setup="$("$MAMBA_EXE" shell hook --shell zsh --root-prefix "$MAMBA_ROOT_PREFIX" 2> /dev/null)"
if [ $? -eq 0 ]; then
    eval "$__mamba_setup"
else
    alias micromamba="$MAMBA_EXE"  # Fallback on help from mamba activate
fi
unset __mamba_setup
# <<< mamba initialize <<<
