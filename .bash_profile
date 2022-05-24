# Source global definitions


# preload these variables so we stop spawning stacks of ssh-agents
# when logging into boxes over SSH.
if [[ -z "${SSH_AGENT_PID}" ]] && [[ -z "${SSH_AUTH_SOCK}" ]]; then
        . ~/.agent;
fi;

if ( [[ ! -z "${SSH_AGENT_PID}" ]] && [[ ! -z "${SSH_AUTH_SOCK}" ]] ) && ! kill -0 ${SSH_AGENT_PID}; then
        /usr/bin/ssh-agent -s > ~/.agent;
        . ~/.agent;

        # We don't care if we already have a running agent.
        if [ -e "/usr/libexec/x11-ssh-askpass" ]; then
                # Probably on slackware...
                export SSH_ASKPASS="/usr/libexec/x11-ssh-askpass";
        elif [ -e "/usr/libexec/openssh/x11-ssh-askpass" ]; then
                # Probably on some rh derivative
                export SSH_ASKPASS="/usr/libexec/openssh/x11-ssh-askpass"
        fi
        /usr/bin/ssh-add

fi;
if [ -f /etc/bashrc ]; then
        . /etc/bashrc
fi
if [ -f ~/.bashrc ]; then
        . ~/.bashrc
fi
