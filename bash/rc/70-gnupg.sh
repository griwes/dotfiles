# make sure we are always running with a gpg-agent
# also make sure that all the shells use the same gpg-agent session
if [ -f "${HOME}/.gpg-agent-info" ]; then
    . "${HOME}/.gpg-agent-info"
    export GPG_AGENT_INFO
    export SSH_AUTH_SOCK
    export SSH_AGENT_PID
fi
gpg-connect-agent /bye &>/dev/null || gpg-agent --daemon --enable-ssh-support --write-env-file --use-standard-socket "${HOME}/.gpg-agent-info" &>/dev/null
if [ -f "${HOME}/.gpg-agent-info" ]; then
    . "${HOME}/.gpg-agent-info"
    export GPG_AGENT_INFO
    export SSH_AUTH_SOCK
    export SSH_AGENT_PID
fi

GPG_TTY=$(tty)
export GPG_TTY

