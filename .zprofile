source ${HOME}/.zpath

# Have ssh-agent laying around when we want it.
# Found this here:
# https://stackoverflow.com/questions/18880024/start-ssh-agent-on-login
#
# I never thought of using a symlink to simplify everything this way.
# TODO: Use netstat -ap to check if destination socket is actually
# connected to an active ssh-agent. WSL doesn't clean /tmp properly.
if [ ! -S ~/.ssh/ssh_auth_sock ]; then
  eval `ssh-agent`
  ln -sf "$SSH_AUTH_SOCK" ~/.ssh/ssh_auth_sock
fi

export SSH_AUTH_SOCK=~/.ssh/ssh_auth_sock
