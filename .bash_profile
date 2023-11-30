# Source global definitions

if [ -f /etc/bashrc ]; then
        . /etc/bashrc
fi
if [ -f "${HOME}/.bashrc" ]; then
        . "${HOME}/.bashrc"
fi
. "$HOME/.cargo/env"
