xinput set-prop 'ROCCAT ROCCAT Kone Aimo 16K Mouse' 'libinput Accel Profile Enabled' 0, 1
xinput set-prop 'ROCCAT ROCCAT Kone Aimo 16K Mouse' "libinput Accel Speed" -0.5
xset m 0 0

# Have ssh-agent laying around when we want it.
# Found this here:
# https://stackoverflow.com/questions/18880024/start-ssh-agent-on-login
#
# I never thought of using a symlink to simplify everything this way.
if [ ! -S "${HOME}/.ssh/ssh_auth_sock" ]; then
  eval `ssh-agent`
  ln -sf "$SSH_AUTH_SOCK" ~/.ssh/ssh_auth_sock
fi

export SSH_AUTH_SOCK="${HOME}/.ssh/ssh_auth_sock"
. "$HOME/.cargo/env"
